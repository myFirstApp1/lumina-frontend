import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import '../network/dio_client.dart';
import '../secure_storage/secure_storage_manager.dart';
import '../config/api_config.dart';

class BackgroundLocationService {
  static const String channelId = 'lumina_guardian_tracking';
  static const String notificationTitle = 'Lumina Guardian Active Protection';
  
  static Future<void> initializeService() async {
    final service = FlutterBackgroundService();

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: false,
        isForegroundMode: true,
        notificationChannelId: channelId,
        initialNotificationTitle: notificationTitle,
        initialNotificationContent: 'Monitoring device vitals and environment...',
        foregroundServiceNotificationId: 888,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: false,
        onForeground: onForeground,
        onBackground: onBackground,
      ),
    );
  }

  @pragma('vm:entry-point')
  static void onForeground(ServiceInstance service) {
    debugPrint('Lumina Background Service: iOS Foreground mode active');
  }

  @pragma('vm:entry-point')
  static bool onBackground(ServiceInstance service) {
    debugPrint('Lumina Background Service: iOS Background mode active');
    return true;
  }

  @pragma('vm:entry-point')
  static void onStart(ServiceInstance service) async {
    // Background Isolate Inits
    WidgetsFlutterBinding.ensureInitialized();
    
    final secureStorage = SecureStorageManager();
    final connectivity = Connectivity();
    
    // Config client
    // Set a default server address for testing; in production this reads from secure configuration
    final dioClient = DioClient(
      baseUrl: ApiConfig.safetyBaseUrl, 
      secureStorage: secureStorage,
    );

    String? currentSessionId;
    String trackingMode = 'NORMAL'; // NORMAL, PRE_ALERT, SOS
    StreamSubscription<Position>? positionSubscription;
    Timer? syncTimer;

    // Helper to get sync queue file path
    Future<File> getQueueFile() async {
      final dir = await getApplicationDocumentsDirectory();
      return File('${dir.path}/offline_tracking_queue.json');
    }

    // Helper to write location to queue file
    Future<void> queueLocationOffline(Map<String, dynamic> loc) async {
      try {
        final file = await getQueueFile();
        List<dynamic> queue = [];
        if (await file.exists()) {
          final content = await file.readAsString();
          if (content.isNotEmpty) {
            queue = jsonDecode(content) as List<dynamic>;
          }
        }
        queue.add(loc);
        await file.writeAsString(jsonEncode(queue));
      } catch (e) {
        debugPrint('Failed to queue offline location: $e');
      }
    }

    // Helper to sync queue with server
    Future<void> syncOfflineQueue() async {
      try {
        final connectivityResult = await connectivity.checkConnectivity();
        final isOnline = connectivityResult.isNotEmpty && !connectivityResult.contains(ConnectivityResult.none);
        if (!isOnline) return;

        final file = await getQueueFile();
        if (!await file.exists()) return;

        final content = await file.readAsString();
        if (content.isEmpty) return;

        final queue = jsonDecode(content) as List<dynamic>;
        if (queue.isEmpty) return;

        final token = await secureStorage.getAccessToken();
        if (token == null) return;

        // Try to upload records in batches
        final List<dynamic> failedRecords = [];
        for (var item in queue) {
          try {
            await dioClient.dio.post(
              '/api/v1/tracking/location',
              data: item,
              options: Options(headers: {'Authorization': 'Bearer $token'}),
            );
          } catch (e) {
            failedRecords.add(item);
          }
        }

        if (failedRecords.isEmpty) {
          await file.delete();
        } else {
          await file.writeAsString(jsonEncode(failedRecords));
        }
      } catch (e) {
        debugPrint('Offline sync error: $e');
      }
    }

    // Define subscription params based on state
    void subscribeToLocation(String sessionId, String mode) {
      positionSubscription?.cancel();
      
      int distanceFilter = 10; // meters
      Duration interval = const Duration(seconds: 60);

      if (mode == 'PRE_ALERT') {
        distanceFilter = 2;
        interval = const Duration(seconds: 15);
      } else if (mode == 'SOS') {
        distanceFilter = 0;
        interval = const Duration(seconds: 5);
      }

      final locationSettings = AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: distanceFilter,
        intervalDuration: interval,
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationText: "Lumina Guardian actively tracking location.",
          notificationTitle: notificationTitle,
          enableWakeLock: true,
        ),
      );

      positionSubscription = Geolocator.getPositionStream(
        locationSettings: locationSettings,
      ).listen((Position position) async {
        final payload = {
          'sessionId': sessionId,
          'latitude': position.latitude,
          'longitude': position.longitude,
          'accuracy': position.accuracy,
          'speed': position.speed,
          'timestamp': DateTime.now().toIso8601String(),
        };

        // Emit to main isolate
        service.invoke('onLocationReceived', payload);

        // Upload to server or save offline
        try {
          final connectivityResult = await connectivity.checkConnectivity();
          final isOnline = connectivityResult.isNotEmpty && !connectivityResult.contains(ConnectivityResult.none);
          if (isOnline) {
            final token = await secureStorage.getAccessToken();
            await dioClient.dio.post(
              '/api/v1/tracking/location',
              data: payload,
              options: Options(headers: {
                if (token != null) 'Authorization': 'Bearer $token',
              }),
            );
          } else {
            await queueLocationOffline(payload);
          }
        } catch (e) {
          // Cache offline if network fails
          await queueLocationOffline(payload);
        }
      }, onError: (err) {
        service.invoke('onError', {'message': err.toString()});
      });
    }

    // Start background sync timer
    syncTimer = Timer.periodic(const Duration(seconds: 30), (_) => syncOfflineQueue());

    // Listen for control commands
    service.on('startTracking').listen((event) {
      final sessionId = event?['sessionId'] as String?;
      if (sessionId != null) {
        currentSessionId = sessionId;
        subscribeToLocation(sessionId, trackingMode);
      }
    });

    service.on('updateTrackingMode').listen((event) {
      final mode = event?['mode'] as String?;
      if (mode != null && currentSessionId != null) {
        trackingMode = mode;
        subscribeToLocation(currentSessionId!, trackingMode);
      }
    });

    service.on('stopTracking').listen((_) {
      positionSubscription?.cancel();
      positionSubscription = null;
      currentSessionId = null;
    });

    service.on('stopService').listen((_) {
      positionSubscription?.cancel();
      syncTimer?.cancel();
      service.stopSelf();
    });
  }
}

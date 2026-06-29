import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import '../network/dio_client.dart';
import '../secure_storage/secure_storage_manager.dart';
import '../config/api_config.dart';

@pragma('vm:entry-point')
class BackgroundLocationService {
  static const String channelId = 'lumina_guardian_tracking';
  static const String notificationTitle = 'Lumina Guardian Active Protection';


  static Future<void> initializeService() async {

    debugPrint("==========");
    debugPrint("INITIALIZING BACKGROUND SERVICE");
    debugPrint("==========");

    const AndroidNotificationChannel channel =
    AndroidNotificationChannel(
      channelId,
      notificationTitle,
      description: "Live SOS Tracking",
      importance: Importance.low,
    );

    final FlutterLocalNotificationsPlugin notifications =
    FlutterLocalNotificationsPlugin();

    await notifications
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    final service = FlutterBackgroundService();

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: false,
        isForegroundMode: true,
        notificationChannelId: channelId,
        initialNotificationTitle: notificationTitle,
        initialNotificationContent:
        "Monitoring device vitals and environment...",
        foregroundServiceNotificationId: 888,
      ),

      iosConfiguration: IosConfiguration(
        autoStart: false,
        onForeground: onForeground,
        onBackground: onBackground,
      ),
    );

    debugPrint("BACKGROUND SERVICE CONFIGURED");

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

    debugPrint("################################");
    debugPrint("BACKGROUND onStart ENTERED");
    debugPrint("################################");

    final secureStorage = SecureStorageManager();

    String? currentUserId;
    String? currentTrackingId;
    String? accessToken;

    final connectivity = Connectivity();

    final userId = await secureStorage.getUserId();

    debugPrint("BACKGROUND USER ID");
    debugPrint(userId);
    
    // Config client
    // Set a default server address for testing; in production this reads from secure configuration
    final dioClient = DioClient(
      baseUrl: ApiConfig.safetyBaseUrl, 
      secureStorage: secureStorage,
    );

    String trackingMode = 'NORMAL'; // NORMAL, PRE_ALERT, SOS
    StreamSubscription<Position>? positionSubscription;
    Timer? syncTimer;

    // Helper to get sync queue file path
    Future<File> getQueueFile() async {
      final dir = await getApplicationDocumentsDirectory();
      return File('${dir.path}/offline_tracking_queue.json');
    }

    // Helper to write location to queue file
    Future<void> queueLocationOffline(
        Map<String, dynamic> loc,
        ) async {

      try {

        final file = await getQueueFile();

        debugPrint("QUEUE FILE");
        debugPrint(file.path);

        List<dynamic> queue = [];

        if (await file.exists()) {

          final content = await file.readAsString();

          if (content.isNotEmpty) {
            queue = jsonDecode(content);
          }

        } else {

          debugPrint("CREATING NEW QUEUE FILE");

        }

        queue.add(loc);

        debugPrint("QUEUE SIZE = ${queue.length}");

        await file.writeAsString(
          jsonEncode(queue),
        );

        debugPrint("LOCATION SAVED OFFLINE");

      } catch (e) {

        debugPrint("QUEUE SAVE FAILED");

        debugPrint(e.toString());

      }

    }

    // Helper to sync queue with server
    Future<void> syncOfflineQueue() async {

      debugPrint("========================");
      debugPrint("SYNC OFFLINE QUEUE");
      debugPrint("TIME = ${DateTime.now()}");
      debugPrint("========================");

      try {
        final connectivityResult = await connectivity.checkConnectivity();

        final isOnline =
            connectivityResult.isNotEmpty &&
                !connectivityResult.contains(ConnectivityResult.none);

        debugPrint("NETWORK AVAILABLE = $isOnline");

        if (!isOnline) {

          debugPrint("NETWORK NOT AVAILABLE");
          return;

        }

          final file = await getQueueFile();
        if (!await file.exists()) return;

        final content = await file.readAsString();

        if (content.isEmpty) {

          debugPrint("QUEUE FILE EMPTY");
          return;

        }

        final queue = jsonDecode(content) as List<dynamic>;

        debugPrint("QUEUE SIZE = ${queue.length}");

        if (queue.isEmpty) {

          debugPrint("NO OFFLINE RECORDS");
          return;

        }

        // Try to upload records in batches
        final List<dynamic> failedRecords = [];
        debugPrint("STARTING BACKGROUND UPLOAD LOOP");
        for (var item in queue) {
          debugPrint("=================");
          debugPrint("UPLOADING RECORD");
          debugPrint(item.toString());
          debugPrint("=================");
          try {
            await dioClient.dio.post(
              '/api/tracking/update',
              data: item,
              options: Options(headers: {
                'Authorization': 'Bearer $accessToken',
              }),
            );
            debugPrint("BACKGROUND API UPDATE");
            debugPrint("UPLOAD SUCCESS");
          } catch (e) {
            debugPrint("BACKGROUND UPLOAD FAILED");
            debugPrint(e.toString());

            failedRecords.add(item);
          }
        }

        if (failedRecords.isEmpty) {

          debugPrint("QUEUE CLEARED");

          await file.delete();

        } else {

          debugPrint(
              "FAILED RECORDS = ${failedRecords.length}");

          await file.writeAsString(
            jsonEncode(failedRecords),
          );

        }
      } catch (e) {
        debugPrint('Offline sync error: $e');
      }
    }



    // Define subscription params based on state
    void subscribeToLocation(String trackingId, String mode) {

      debugPrint("==========");
      debugPrint("SUBSCRIBE LOCATION");
      debugPrint("TRACKING ID = $trackingId");
      debugPrint("MODE = $mode");
      debugPrint("==========");

      positionSubscription?.cancel();
      
      int distanceFilter = 0; // meters
      Duration interval = const Duration(seconds: 5);

      if (mode == 'PRE_ALERT') {
        distanceFilter = 2;
        interval = const Duration(seconds: 15);
      } else if (mode == 'SOS') {
        debugPrint("SOS MODE ENABLED");
        distanceFilter = 0;
        interval = const Duration(seconds: 5);
      }

      final locationSettings = AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: distanceFilter,
        intervalDuration: interval,
        forceLocationManager: true,
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationText: "Lumina Guardian actively tracking location.",
          notificationTitle: notificationTitle,
          enableWakeLock: true,
        ),
      );

      positionSubscription = Geolocator.getPositionStream(
        locationSettings: locationSettings,
      ).listen((Position position) async {

        debugPrint("==================");
        debugPrint("BACKGROUND LOCATION RECEIVED");
        debugPrint("TIME = ${DateTime.now()}");
        debugPrint("LAT=${position.latitude}");
        debugPrint("LON=${position.longitude}");
        debugPrint("==================");

        final payload = {
          'userId': currentUserId,
          'trackingId': trackingId,
          'latitude': position.latitude,
          'longitude': position.longitude,
          'accuracy': position.accuracy,
          'speed': position.speed,
          'timestamp': DateTime.now().toIso8601String(),
        };

        debugPrint("SENDING TO MAIN ISOLATE");

        // Emit to main isolate
        service.invoke('onLocationReceived', payload);

        // Upload to server or save offline
        try {
          final connectivityResult = await connectivity.checkConnectivity();
          final isOnline = connectivityResult.isNotEmpty && !connectivityResult.contains(ConnectivityResult.none);

          if (isOnline) {

            debugPrint("ONLINE");
            debugPrint("UPLOADING TO SERVER");

            final token = accessToken;

            await dioClient.dio.post(
              '/api/tracking/update',
              data: payload,
              options: Options(headers: {
                if (token != null) 'Authorization': 'Bearer $token',
              }),
            );
            debugPrint("======================");
            debugPrint("BACKGROUND UPLOAD SUCCESS");
            debugPrint(payload.toString());
            debugPrint("======================");

          } else {
            debugPrint("OFFLINE");
            debugPrint("QUEUE LOCATION");
            await queueLocationOffline(payload);
          }
        } catch (e) {
          debugPrint("======================");
          debugPrint("BACKGROUND UPLOAD FAILED");
          debugPrint(e.toString());
          debugPrint("======================");
          // Cache offline if network fails
          await queueLocationOffline(payload);
        }
      }, onError: (err) {

        debugPrint("LOCATION STREAM ERROR");
        debugPrint(err.toString());

        service.invoke('onError', {'message': err.toString()});
      });
    }

    /// restoreTrackingSession
    Future<void> restoreTrackingSession() async {

      currentUserId = await secureStorage.getTrackingUserId();
      currentTrackingId = await secureStorage.getTrackingId();
      accessToken = await secureStorage.getTrackingAccessToken();

      debugPrint("========== RESTORE SESSION ==========");
      debugPrint("USER = $currentUserId");
      debugPrint("TRACKING = $currentTrackingId");
      debugPrint("TOKEN = ${accessToken != null}");
      debugPrint("=====================================");

      if (currentTrackingId != null &&
          currentUserId != null &&
          accessToken != null) {

        debugPrint("RESTORING LOCATION STREAM");

        subscribeToLocation(
          currentTrackingId!,
          trackingMode,
        );

      } else {

        debugPrint("NO ACTIVE TRACKING SESSION FOUND");

      }
    }

    // Start background sync timer
    syncTimer = Timer.periodic(
      const Duration(seconds: 10),
          (_) async {

        debugPrint("======================");
        debugPrint("BACKGROUND SERVICE ALIVE");
        debugPrint(DateTime.now().toString());

        await syncOfflineQueue();

        debugPrint("======================");

      },
    );

    debugPrint("REGISTERING startTracking LISTENER");

    // Listen for control commands
    service.on('startTracking').listen((event) {

      debugPrint("==========");
      debugPrint("START TRACKING EVENT");
      debugPrint(event.toString());
      debugPrint("==========");

      currentUserId = event?['userId'] as String?;
      currentTrackingId = event?['trackingId'] as String?;
      accessToken = event?['accessToken'] as String?;

      debugPrint("USER ID = $currentUserId");
      debugPrint("TRACKING ID = $currentTrackingId");
      debugPrint("TOKEN EXISTS = ${accessToken != null}");

      if (currentTrackingId != null &&
          currentUserId != null &&
          accessToken != null) {

        subscribeToLocation(
          currentTrackingId!,
          trackingMode,
        );

      }

    });

    service.on('updateTrackingMode').listen((event) {
      final mode = event?['mode'] as String?;
      if (mode != null && currentTrackingId != null) {
        trackingMode = mode;

        subscribeToLocation(
          currentTrackingId!,
          trackingMode,
        );
      }
    });

    service.on('stopTracking').listen((_) {
      positionSubscription?.cancel();
      positionSubscription = null;
      currentTrackingId = null;
      currentUserId = null;
      accessToken = null;
    });

    service.on('stopService').listen((_) {
      positionSubscription?.cancel();
      syncTimer?.cancel();
      service.stopSelf();
    });

    await restoreTrackingSession();

    debugPrint("========================");
    debugPrint("BACKGROUND SERVICE READY");
    debugPrint("========================");

    service.invoke(
      "serviceReady",
    );
  }
}

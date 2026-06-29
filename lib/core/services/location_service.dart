import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import '../secure_storage/secure_storage_manager.dart';
import 'background_location_service.dart';

class LocationService {
  final FlutterBackgroundService _service = FlutterBackgroundService();
  StreamController<Map<String, dynamic>>? _locationStreamController;
  StreamSubscription? _serviceSubscription;

  Stream<Map<String, dynamic>> get locationStream {
    _locationStreamController ??= StreamController<Map<String, dynamic>>.broadcast();
    return _locationStreamController!.stream;
  }

  Future<bool> checkAndRequestPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  Future<void> startTracking( String userId, String trackingId, String accessToken)
  async {

    debugPrint("CHECKING SERVICE");

    final hasPermission =
    await checkAndRequestPermissions();

    if (!hasPermission) {
      throw Exception("GPS Permissions Denied");
    }

    _locationStreamController ??=
    StreamController<Map<String, dynamic>>.broadcast();

    final isRunning = await _service.isRunning();

    debugPrint("SERVICE RUNNING = $isRunning");

    if (!isRunning) {

      await BackgroundLocationService.initializeService();

      debugPrint("STARTING SERVICE");

      final completer = Completer<void>();

      StreamSubscription? readySubscription;

      readySubscription =
          _service.on("serviceReady").listen((_) {

            debugPrint("======================");
            debugPrint("BACKGROUND SERVICE READY");
            debugPrint("======================");

            if (!completer.isCompleted) {
              completer.complete();
            }

            readySubscription?.cancel();
          });

      await _service.startService();

      debugPrint("WAITING FOR SERVICE READY");

      await completer.future;

      debugPrint("SERVICE STARTED");
    }

    final storage = SecureStorageManager();

    await storage.saveTrackingSession(
      userId: userId,
      trackingId: trackingId,
      accessToken: accessToken,
    );

    debugPrint("TRACKING SESSION SAVED");

    debugPrint(await storage.getTrackingUserId());
    debugPrint(await storage.getTrackingId());
    debugPrint((await storage.getTrackingAccessToken() != null).toString());

    debugPrint("==================");
    debugPrint("INVOKING START TRACKING");
    debugPrint("USER = $userId");
    debugPrint("TRACKING = $trackingId");
    debugPrint("==================");
    _service.invoke(
      'startTracking',
      {
        'userId': userId,
        'trackingId': trackingId,
        'accessToken': accessToken,
      },
    );

    debugPrint("START TRACKING EVENT SENT");

    await _serviceSubscription?.cancel();

    _serviceSubscription =
        _service.on('onLocationReceived').listen(

              (event) {

            if (event != null) {

              final data =
              Map<String, dynamic>.from(event);

              debugPrint("======================");
              debugPrint("STREAM PUSH");
              debugPrint("LAT = ${data['latitude']}");
              debugPrint("LON = ${data['longitude']}");
              debugPrint("======================");

              _locationStreamController?.add(data);

            }

          },

        );
  }


  Future<void> updateMode(String mode) async {
    if (await _service.isRunning()) {
      _service.invoke('updateTrackingMode', {'mode': mode});
    }
  }


  Future<void> stopTracking() async {

    await _serviceSubscription?.cancel();

    _serviceSubscription = null;

    if (await _service.isRunning()) {

      _service.invoke('stopTracking');

      _service.invoke('stopService');

    }

    _locationStreamController?.close();

    _locationStreamController = null;
  }

  Future<String> getCurrentLocationString() async {

    final hasPermission =
    await checkAndRequestPermissions();

    if (!hasPermission) {
      throw Exception(
        "Location permission denied",
      );
    }

    final position =
    await Geolocator.getCurrentPosition(
      desiredAccuracy:
      LocationAccuracy.high,
    );

    return
      "${position.latitude},${position.longitude}";
  }

  Future<Position> getCurrentLocation() async {
    final hasPermission = await checkAndRequestPermissions();

    if (!hasPermission) {
      throw Exception("Location permission denied");
    }

    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

}

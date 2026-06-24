import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
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

  Future<void> startTracking(String trackingId) async {

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

      await _service.startService();

      debugPrint("SERVICE STARTED");

      await Future.delayed(
        const Duration(seconds: 1),
      );
    }

    debugPrint("SERVICE STARTED");

    _service.invoke(
      'startTracking',
      {
        'sessionId': trackingId,
      },
    );

    await _serviceSubscription?.cancel();

    _serviceSubscription =
        _service.on('onLocationReceived').listen(

              (event) {

            if (event != null) {

              _locationStreamController?.add(
                Map<String, dynamic>.from(event),
              );

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

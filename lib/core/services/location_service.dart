import 'dart:async';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'background_location_service.dart';

class LocationService {
  final FlutterBackgroundService _service = FlutterBackgroundService();
  StreamController<Map<String, dynamic>>? _locationStreamController;

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

  Future<void> startTracking(String sessionId) async {
    final hasPermission = await checkAndRequestPermissions();
    if (!hasPermission) {
      throw Exception('GPS Permissions Denied');
    }

    final isRunning = await _service.isRunning();
    if (!isRunning) {
      await BackgroundLocationService.initializeService();
      await _service.startService();
    }

    // Wait slightly for service startup, then start tracking
    await Future.delayed(const Duration(milliseconds: 500));
    _service.invoke('startTracking', {'sessionId': sessionId});

    // Setup subscription to background service events
    _service.on('onLocationReceived').listen((event) {
      if (event != null && _locationStreamController != null && !_locationStreamController!.isClosed) {
        _locationStreamController!.add(Map<String, dynamic>.from(event));
      }
    });
  }

  Future<void> updateMode(String mode) async {
    if (await _service.isRunning()) {
      _service.invoke('updateTrackingMode', {'mode': mode});
    }
  }

  Future<void> stopTracking() async {
    if (await _service.isRunning()) {
      _service.invoke('stopTracking');
      _service.invoke('stopService');
    }
    _locationStreamController?.close();
    _locationStreamController = null;
  }
}

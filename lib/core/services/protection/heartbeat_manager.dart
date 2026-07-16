import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../secure_storage/secure_storage_manager.dart';
import '../location_service.dart';
import '../../../features/protection/domain/repositories/protection_repository.dart';

class HeartbeatManager {
  final ProtectionRepository _repository;
  final SecureStorageManager _storage;
  final LocationService _locationService;

  Timer? _heartbeatTimer;

  HeartbeatManager({
    required ProtectionRepository repository,
    required SecureStorageManager storage,
    required LocationService locationService,
  })  : _repository = repository,
        _storage = storage,
        _locationService = locationService;

  bool get isRunning => _heartbeatTimer?.isActive ?? false;

  Future<void> start() async {
    if (isRunning) {
      debugPrint("Heartbeat already running.");
      return;
    }

    debugPrint("=================================");
    debugPrint("HEARTBEAT MANAGER STARTED");
    debugPrint("=================================");

    // Send first heartbeat immediately.
    await _sendHeartbeat();

    _heartbeatTimer = Timer.periodic(
      const Duration(seconds: 30),
          (_) async {
        await _sendHeartbeat();
      },
    );
  }

  Future<void> stop() async {
    debugPrint("=================================");
    debugPrint("HEARTBEAT MANAGER STOPPED");
    debugPrint("=================================");

    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }

  Future<void> _sendHeartbeat() async {
    try {
      final userId = await _storage.getUserId();

      if (userId == null || userId.isEmpty) {
        debugPrint("Heartbeat skipped. User session not found.");
        return;
      }

      final position =
      await _locationService.getCurrentLocation();

      const battery = 100; // TODO: Replace later

      await _repository.sendHeartbeat(
        userId,
        battery,
        position.latitude,
        position.longitude,
      );

      debugPrint(
        "Heartbeat sent successfully "
            "(${position.latitude}, ${position.longitude})",
      );
    } catch (e) {
      debugPrint("Heartbeat failed: $e");
    }
  }
}
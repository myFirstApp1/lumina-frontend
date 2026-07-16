import 'package:flutter/foundation.dart';

import '../../secure_storage/secure_storage_manager.dart';
import '../../../features/protection/domain/repositories/protection_repository.dart';
import 'heartbeat_manager.dart';

class ProtectionService {
  final ProtectionRepository _repository;
  final SecureStorageManager _storage;
  final HeartbeatManager _heartbeatManager;

  ProtectionService({
    required ProtectionRepository repository,
    required SecureStorageManager storage,
    required HeartbeatManager heartbeatManager,
  })  : _repository = repository,
        _storage = storage,
        _heartbeatManager = heartbeatManager;

  Future<void> start() async {
    final userId = await _storage.getUserId();

    if (userId == null || userId.isEmpty) {
      debugPrint("No user session.");
      return;
    }

    if (_heartbeatManager.isRunning) {
      debugPrint("Protection already running.");
      return;
    }

    try {
      debugPrint("STARTING PROTECTION");

      await _repository.startProtection(userId);

      await _heartbeatManager.start();

      debugPrint("Protection started successfully.");

    } catch (e) {
      debugPrint("Protection start failed: $e");

      // Don't rethrow here.
      // Authentication has already succeeded.
    }
  }

  Future<void> stop() async {
    final userId = await _storage.getUserId();

    if (userId == null || userId.isEmpty) {
      return;
    }

    try {
      await _heartbeatManager.stop();
      await _repository.stopProtection(userId);
    } catch (e) {
      debugPrint("Stop protection failed: $e");
    }
    debugPrint("Protection stopped.");
  }

  Future<void> recover() async {
    final userId = await _storage.getUserId();

    if (userId == null || userId.isEmpty) {
      debugPrint("No logged in user.");
      return;
    }

    try {
      final status =
      await _repository.getProtectionStatus(
        userId,
      );

      if (status != "ACTIVE") {
        debugPrint(
          "Protection is not active.",
        );
        return;
      }

      if (_heartbeatManager.isRunning) {
        debugPrint(
          "Heartbeat already running.",
        );
        return;
      }

      await _heartbeatManager.start();

      debugPrint(
        "Protection recovered.",
      );

    } catch (e) {
      debugPrint(
        "Recovery failed: $e",
      );
    }
  }
}
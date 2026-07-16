import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/secure_storage/secure_storage_manager.dart';
import '../../domain/repositories/protection_repository.dart';
import 'protection_state.dart';

class ProtectionCubit extends Cubit<ProtectionState> {
  final ProtectionRepository _repository;
  final SecureStorageManager _storage;
  Timer? _heartbeatTimer;

  ProtectionCubit({
    required ProtectionRepository repository,
    required SecureStorageManager storage,
  })  : _repository = repository,
        _storage = storage,
        super(const ProtectionInitial());

  Future<void> startProtection() async {
    final userId = await _storage.getUserId();

    if (userId == null || userId.isEmpty) {
      emit(const ProtectionError('User session not found.'));
      return;
    }

    emit(const ProtectionLoading());

    try {
      await _repository.startProtection(userId);

      _startHeartbeatTimer(userId);

      emit(
        const ProtectionActive(
          status: 'Protected',
        ),
      );
    } catch (e) {
      emit(
        ProtectionError(
          e.toString(),
        ),
      );
    }
  }

  Future<void> stopProtection() async {
    final userId = await _storage.getUserId();

    if (userId == null || userId.isEmpty) {
      emit(const ProtectionError('User session not found.'));
      return;
    }

    try {
      debugPrint("===============");
      debugPrint("STOP PROTECTION");
      debugPrint("USER ID = $userId");
      debugPrint("===============");

      await _repository.stopProtection(userId);

      _stopHeartbeatTimer();

      emit(const ProtectionStopped());
    } catch (e) {
      emit(
        ProtectionError(
          e.toString(),
        ),
      );
    }
  }

  Future<void> pauseProtection(int minutes) async {

    final userId = await _storage.getUserId();

    if (userId == null || userId.isEmpty) {
      emit(const ProtectionError('User session not found.'));
      return;
    }
    try {
      await _repository.pauseProtection(
        userId,
        minutes,
      );

      _stopHeartbeatTimer();

      emit(
        ProtectionPaused(
          minutes: minutes,
        ),
      );
    } catch (e) {
      emit(
        ProtectionError(
          e.toString(),
        ),
      );
    }
  }

  Future<void> resumeProtection() async {
    final userId = await _storage.getUserId();

    if (userId == null || userId.isEmpty) {
      emit(const ProtectionError('User session not found.'));
      return;
    }
    try {
      await _repository.resumeProtection(userId);

      _startHeartbeatTimer(userId);

      emit(
        const ProtectionActive(
          status: 'Protected',
        ),
      );
    } catch (e) {
      emit(
        ProtectionError(
          e.toString(),
        ),
      );
    }
  }

  Future<void> confirmSafe() async {
    final userId = await _storage.getUserId();

    if (userId == null || userId.isEmpty) {
      emit(const ProtectionError('User session not found.'));
      return;
    }
    try {
      await _repository.confirmSafe(userId);

      _stopHeartbeatTimer();

      emit(
        const ProtectionStopped(),
      );
    } catch (e) {
      emit(
        ProtectionError(
          e.toString(),
        ),
      );
    }
  }

  Future<void> loadStatus() async {
    final userId = await _storage.getUserId();

    if (userId == null || userId.isEmpty) {
      emit(const ProtectionError('User session not found.'));
      return;
    }
    try {
      final status =
      await _repository.getProtectionStatus(userId);

      if (status == 'Protected') {

        emit(
          ProtectionActive(
            status: status,
          ),
        );

      } else {

        emit(
          const ProtectionStopped(),
        );

      }
    } catch (e) {
      emit(
        ProtectionError(
          e.toString(),
        ),
      );
    }
  }

  void _startHeartbeatTimer(String userId) {
    _heartbeatTimer?.cancel();

    _heartbeatTimer = Timer.periodic(
      const Duration(seconds: 30),
          (_) async {
        try {
          print("++++++++\nHEARTBEAT SENT\n++++++");
          await _repository.sendHeartbeat(
            userId,
            100,      // Temporary battery
            0.0,      // Temporary latitude
            0.0,      // Temporary longitude
          );
        } catch (_) {
          // Don't crash UI if heartbeat fails
        }
      },
    );
  }

  void _stopHeartbeatTimer() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }

  @override
  Future<void> close() {
    _heartbeatTimer?.cancel();
    return super.close();
  }
}
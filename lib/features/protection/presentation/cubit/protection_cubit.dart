import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/protection_repository.dart';
import 'protection_state.dart';

class ProtectionCubit extends Cubit<ProtectionState> {
  final ProtectionRepository _repository;

  Timer? _heartbeatTimer;

  ProtectionCubit({
    required ProtectionRepository repository,
  })  : _repository = repository,
        super(const ProtectionInitial());

  Future<void> startProtection(String userId) async {
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

  Future<void> stopProtection(String userId) async {
    try {
      await _repository.stopProtection(userId);

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

  Future<void> pauseProtection(
      String userId,
      int minutes,
      ) async {
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

  Future<void> resumeProtection(String userId) async {
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

  Future<void> confirmSafe(String userId) async {
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

  Future<void> loadStatus(String userId) async {
    try {
      final status =
      await _repository.getProtectionStatus(userId);

      emit(
        ProtectionActive(
          status: status,
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

  void _startHeartbeatTimer(String userId) {
    _heartbeatTimer?.cancel();

    _heartbeatTimer = Timer.periodic(
      const Duration(seconds: 30),
          (_) async {
        try {
          await _repository.sendHeartbeat(userId);
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
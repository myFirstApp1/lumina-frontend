import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../features/tracking/presentation/cubit/tracking_cubit.dart';
import '../../domain/repositories/sos_repository.dart';

abstract class SosState {
  const SosState();
}

class SosInitial extends SosState {
  const SosInitial();
}

class SosLoading extends SosState {
  const SosLoading();
}

class SosPreAlertActive extends SosState {
  final int countdownSeconds;
  const SosPreAlertActive(this.countdownSeconds);
}

class SosAlertActive extends SosState {
  final String sessionId;
  const SosAlertActive(this.sessionId);
}

class SosError extends SosState {
  final String message;
  const SosError(this.message);
}

class SosCubit extends Cubit<SosState> {
  final SosRepository _sosRepository;
  final TrackingCubit _trackingCubit;
  Timer? _countdownTimer;

  SosCubit({
    required SosRepository sosRepository,
    required TrackingCubit trackingCubit,
  })  : _sosRepository = sosRepository,
        _trackingCubit = trackingCubit,
        super(const SosInitial());

  Future<void> checkActiveSession() async {
    emit(const SosLoading());
    try {
      final session = await _sosRepository.getActiveSession();
      if (session != null) {
        final sessionId = session['id'] as String;
        emit(SosAlertActive(sessionId));
        await _trackingCubit.startTrackingSession(sessionId);
        await _trackingCubit.updateTrackingMode('SOS');
      } else {
        emit(const SosInitial());
      }
    } catch (e) {
      emit(SosError(e.toString()));
    }
  }

  void startPreAlert({int durationSeconds = 30}) {
    _countdownTimer?.cancel();
    emit(SosPreAlertActive(durationSeconds));
    
    // Trigger tracking initialization immediately in Pre-Alert mode
    _trackingCubit.startTrackingSession('TEMP_PRE_ALERT_SESSION');
    _trackingCubit.updateTrackingMode('PRE_ALERT');
    
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state is SosPreAlertActive) {
        final currentSeconds = (state as SosPreAlertActive).countdownSeconds;
        if (currentSeconds <= 1) {
          timer.cancel();
          triggerSos(latitude: 0.0, longitude: 0.0, triggerType: 'DEAD_MAN_TIMEOUT');
        } else {
          emit(SosPreAlertActive(currentSeconds - 1));
        }
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> triggerSos({
    required double latitude,
    required double longitude,
    required String triggerType,
  }) async {
    _countdownTimer?.cancel();
    emit(const SosLoading());
    try {
      final sessionId = await _sosRepository.triggerSos(
        latitude: latitude,
        longitude: longitude,
        triggerType: triggerType,
      );
      emit(SosAlertActive(sessionId));
      await _trackingCubit.startTrackingSession(sessionId);
      await _trackingCubit.updateTrackingMode('SOS');
    } catch (e) {
      emit(SosError(e.toString()));
    }
  }

  Future<void> cancelSos({
    required String verificationCode,
  }) async {
    if (state is SosAlertActive) {
      final sessionId = (state as SosAlertActive).sessionId;
      emit(const SosLoading());
      try {
        await _sosRepository.cancelSos(
          sessionId: sessionId,
          verificationCode: verificationCode,
        );
        await _trackingCubit.stopTrackingSession();
        emit(const SosInitial());
      } catch (e) {
        emit(SosError(e.toString()));
      }
    } else if (state is SosPreAlertActive) {
      _countdownTimer?.cancel();
      await _trackingCubit.stopTrackingSession();
      emit(const SosInitial());
    }
  }

  @override
  Future<void> close() {
    _countdownTimer?.cancel();
    return super.close();
  }
}

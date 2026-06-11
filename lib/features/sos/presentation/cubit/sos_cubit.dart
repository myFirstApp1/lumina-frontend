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
  const SosAlertActive();
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

  void startPreAlert({int durationSeconds = 30}) {

    _countdownTimer?.cancel();

    emit(
      SosPreAlertActive(durationSeconds),
    );

    _countdownTimer = Timer.periodic(
      const Duration(seconds: 1),
          (timer) {

        if (state is SosPreAlertActive) {

          final currentSeconds =
              (state as SosPreAlertActive)
                  .countdownSeconds;

          if (currentSeconds <= 1) {

            timer.cancel();
            //triggerSos(latitude: 0.0, longitude: 0.0, triggerType: 'DEAD_MAN_TIMEOUT');
          } else {

            emit(
              SosPreAlertActive(
                currentSeconds - 1,
              ),
            );

          }

        } else {

          timer.cancel();

        }
      },
    );
  }
  Future<void> triggerSos({
    required String userId,
    required String location,
  }) async {

    emit(const SosLoading());

    try {

      await _sosRepository.triggerSos(
        userId: userId,
        location: location,
      );

      emit(
        const SosAlertActive(),
      );

    } catch (e) {

      emit(
        SosError(
          e.toString(),
        ),
      );

    }
  }

  @override
  Future<void> close() {
    _countdownTimer?.cancel();
    return super.close();
  }
}

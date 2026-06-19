import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/secure_storage/secure_storage_manager.dart';
import '../../../../core/services/location_service.dart';
import '../../../../features/tracking/presentation/cubit/tracking_cubit.dart';
import '../../../tracking/domain/repositories/tracking_repository.dart';
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
  final SecureStorageManager _secureStorage;
  final LocationService _locationService;
  final TrackingRepository _trackingRepository;
  Timer? _countdownTimer;

  SosCubit({
    required SosRepository sosRepository,
    required TrackingCubit trackingCubit,
    required SecureStorageManager secureStorage,
    required LocationService locationService,
    required TrackingRepository trackingRepository,
  })  : _sosRepository = sosRepository,
        _trackingCubit = trackingCubit,
        _secureStorage = secureStorage,
        _locationService = locationService,
        _trackingRepository = trackingRepository,
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

  Future<void> triggerSos() async {

    emit(const SosLoading());

    debugPrint("SOS METHOD ENTERED");
    try {

      final userId =
      await _secureStorage.getUserId();

      debugPrint("========== SOS ==========");
      debugPrint("USER ID = $userId");

      final location =
      await _locationService.getCurrentLocationString();

      debugPrint("LOCATION = $location");

      await _sosRepository.triggerSos(
        userId: userId!,
        location: location,
      );

      final trackingId =
      await _trackingRepository.getTrackingId(
        userId,
      );

      await _trackingCubit.startTrackingSession(
        userId: userId,
        trackingId: trackingId,
      );
      debugPrint("SOS API SUCCESS");

      emit(const SosAlertActive());

    } catch (e) {

      debugPrint("SOS ERROR");
      debugPrint(e.toString());

      emit(SosError(e.toString()));
    }
  }

  Future<void> triggerEmergency(String userId) async {
    emit(const SosLoading());

    try {

      final position =
      await _locationService.getCurrentLocation();

      final location =
          "${position.latitude},${position.longitude}";

      await _sosRepository.triggerSos(
        userId: userId,
        location: location,
      );

      emit(const SosAlertActive());

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

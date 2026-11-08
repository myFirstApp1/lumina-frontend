import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/errors/failures.dart';
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

  final String trackingId;

  const SosAlertActive({
    required this.trackingId,
  });

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

  // =========================================================
  // TRIGGER SOS
  // =========================================================

  Future<void> triggerSos() async {

    // Ignore a second trigger while one is already being sent.
    if (state is SosLoading) {
      return;
    }

    emit(const SosLoading());

    try {

      final userId = await _secureStorage.getUserId();

      if (userId == null || userId.isEmpty) {
        throw ServerException('User session not found. Please log in again.');
      }

      // Location is best effort. A missing GPS fix must never block an SOS:
      // the backend falls back to the last known location.
      final position = await _bestEffortPosition();

      final result = await _sosRepository.triggerSos(
        userId: userId,
        latitude: position?.latitude,
        longitude: position?.longitude,
      );

      debugPrint("SOS ACCEPTED BY BACKEND ($result)");

      // From here on the SOS is active on the server. Nothing below may turn
      // it into an error on screen.
      final trackingId = await _loadTrackingId(userId);

      if (trackingId != null && trackingId.isNotEmpty) {
        try {
          await _trackingCubit.startTrackingSession(
            userId: userId,
            trackingId: trackingId,
          );
        } catch (e) {
          debugPrint("START TRACKING AFTER SOS FAILED: $e");
        }
      } else {
        debugPrint("SOS ACTIVE BUT NO TRACKING ID RETURNED");
      }

      emit(
        SosAlertActive(
          trackingId: trackingId ?? '',
        ),
      );

    } catch (e) {

      debugPrint("SOS ERROR: $e");

      emit(SosError(_messageOf(e, 'Could not send SOS. Please try again.')));
    }
  }

  Future<Position?> _bestEffortPosition() async {
    try {
      return await _locationService
          .getCurrentLocation()
          .timeout(const Duration(seconds: 5));
    } catch (e) {
      debugPrint("SOS LOCATION UNAVAILABLE: $e");
      return null;
    }
  }

  /// The backend creates the tracking id while handling the SOS event. Ask for
  /// it a few times in case the read races the write.
  Future<String?> _loadTrackingId(String userId) async {
    for (var attempt = 0; attempt < 3; attempt++) {
      final id = await _trackingRepository.getActiveTrackingId(userId);

      if (id != null && id.isNotEmpty) {
        return id;
      }

      await Future.delayed(const Duration(milliseconds: 500));
    }

    return null;
  }

  // =========================================================
  // RESTORE AFTER APP RESTART
  // =========================================================

  Future<void> restoreActiveSos() async {

    try {

      final userId =
      await _secureStorage.getUserId();

      if (userId == null) {

        debugPrint("RESTORE SOS -> NO USER");
        return;

      }

      final trackingId =
      await _trackingRepository.getActiveTrackingId(
        userId,
      );

      if (trackingId == null) {

        debugPrint("RESTORE SOS -> NO ACTIVE SESSION");
        return;

      }

      debugPrint("==========================");
      debugPrint("RESTORING SOS SESSION");
      debugPrint("TRACKING ID = $trackingId");
      debugPrint("==========================");

      emit(
        SosAlertActive(
          trackingId: trackingId,
        ),
      );

    } catch (e) {

      debugPrint("RESTORE SOS FAILED");
      debugPrint(e.toString());

    }

  }

  // =========================================================
  // STOP SOS (MARK SAFE)
  // =========================================================

  Future<void> stopSos() async {

    final previous = state;

    emit(const SosLoading());

    try {

      final userId = await _secureStorage.getUserId();

      if (userId == null || userId.isEmpty) {
        throw ServerException('User session not found. Please log in again.');
      }

      // The backend is the authority: this closes the incident, stops
      // tracking and puts the safety session back to ACTIVE.
      await _sosRepository.markSafe(userId: userId);

      await _trackingCubit.stopTrackingSession();

      debugPrint("SOS STOPPED");

      emit(const SosInitial());

    } catch (e) {

      debugPrint("STOP SOS FAILED: $e");

      emit(SosError(_messageOf(e, 'Could not stop SOS. Please try again.')));

      // The SOS is still active on the server: keep showing it.
      if (previous is SosAlertActive) {
        emit(previous);
      }

    }

  }

  String _messageOf(Object e, String fallback) {
    if (e is ServerException && e.message.isNotEmpty) {
      return e.message;
    }
    return fallback;
  }

  @override
  Future<void> close() {
    _countdownTimer?.cancel();
    return super.close();
  }
}

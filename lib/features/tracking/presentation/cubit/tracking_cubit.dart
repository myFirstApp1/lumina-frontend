import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/secure_storage/secure_storage_manager.dart';
import '../../../../core/services/location_service.dart';
import '../../domain/repositories/tracking_repository.dart';

abstract class TrackingState {
  const TrackingState();
}

class TrackingIdle extends TrackingState {
  const TrackingIdle();
}

class TrackingLoading extends TrackingState {
  const TrackingLoading();
}

class TrackingStreaming extends TrackingState {
  const TrackingStreaming();
}

class TrackingError extends TrackingState {
  final String message;
  const TrackingError(this.message);
}

class TrackingCubit extends Cubit<TrackingState> {
  final TrackingRepository _trackingRepository;
  final LocationService _locationService;
  final SecureStorageManager _secureStorage;
  String? _userId;
  String? _trackingId;
  StreamSubscription? _locationSubscription;

  TrackingCubit({
    required TrackingRepository trackingRepository,
    required LocationService locationService,
    required SecureStorageManager secureStorage,
  })  : _trackingRepository = trackingRepository,
        _locationService = locationService,
        _secureStorage = secureStorage,
        super(const TrackingIdle());

  Future<void> startTrackingSession({
    required String userId,
    required String trackingId,
  }) async {

    emit(const TrackingLoading());

    _userId = userId;
    _trackingId = trackingId;

    final token = await _secureStorage.getAccessToken();

    debugPrint("==========");
    debugPrint("TRACKING CUBIT TOKEN");
    debugPrint(token);
    debugPrint("==========");

    if (token == null) {
      throw Exception("Access token missing");
    }

    try {

      await _locationSubscription?.cancel();

      _locationSubscription =
          _locationService.locationStream.listen(

                (data) {

              debugPrint("====================");
              debugPrint("TRACKING STREAM EVENT");
              debugPrint("UI RECEIVED LOCATION");
              debugPrint(data.toString());
              debugPrint("====================");

              emit(const TrackingStreaming());

            },

            onError: (err) {

              emit(
                TrackingError(
                  err.toString(),
                ),
              );

            },

          );

      await _locationService.startTracking(
        userId,
        trackingId,
        token,
      );

      emit(const TrackingStreaming());

    } catch (e) {

      debugPrint("START TRACKING FAILED");
      debugPrint(e.toString());

      emit(
        TrackingError(
          e.toString(),
        ),
      );

    }

  }

  // Future<void> restoreTrackingIfNeeded() async {
  //
  //   try {
  //
  //     final userId = await _secureStorage.getUserId();
  //
  //     debugPrint("RESTORE USER = $userId");
  //
  //     if (userId == null) {
  //
  //       debugPrint("NO USER FOUND");
  //       return;
  //
  //     }
  //
  //     final trackingId =
  //     await _trackingRepository.getActiveTrackingId(userId);
  //
  //     debugPrint("TRACKING FROM SERVER = $trackingId");
  //
  //     if (trackingId == null) {
  //
  //       debugPrint("NO ACTIVE TRACKING");
  //       return;
  //
  //     }
  //
  //     debugPrint("RESTORING ACTIVE TRACKING");
  //     debugPrint("TRACKING ID = $trackingId");
  //
  //     await startTrackingSession(
  //       userId: userId,
  //       trackingId: trackingId,
  //     );
  //
  //   } catch (e) {
  //
  //     debugPrint("RESTORE TRACKING FAILED");
  //     debugPrint(e.toString());
  //
  //   }
  // }


  Future<void> restoreTrackingIfNeeded() async {
    debugPrint(">>>>>>>> restoreTrackingIfNeeded ENTERED <<<<<<<<");
    debugPrint("restoreTrackingIfNeeded ENTERED");
    try {

      final userId = await _secureStorage.getUserId();

      debugPrint("====================");
      debugPrint("RESTORE USER");
      debugPrint(userId);
      debugPrint("====================");

      if (userId == null) {
        debugPrint("NO USER FOUND");
        return;
      }

      final trackingId =
      await _trackingRepository.getActiveTrackingId(userId);

      debugPrint("====================");
      debugPrint("TRACKING FROM SERVER");
      debugPrint(trackingId);
      debugPrint("====================");

      if (trackingId == null) {
        debugPrint("NO ACTIVE TRACKING");
        return;
      }

      debugPrint("RESTORING TRACKING");

      await startTrackingSession(
        userId: userId,
        trackingId: trackingId,
      );

    } catch (e, s) {

      debugPrint("====================");
      debugPrint("RESTORE FAILED");
      debugPrint(e.toString());
      debugPrint(s.toString());
      debugPrint("====================");

    }
  }

  Future<void> updateTrackingMode(String mode) async {
    try {
      await _locationService.updateMode(mode);
    } catch (e) {
      // Log mode update failure, but don't crash
    }
  }

Future<void> sendLocationUpdate({
  required double latitude,
  required double longitude,
  required double accuracy,
  required double speed,
}) async {

  if (_userId == null || _trackingId == null) {
    return;
  }

  try {

    debugPrint("==========");
    debugPrint("TRACKING UPDATE");
    debugPrint("USER ID = $_userId");
    debugPrint("TRACKING ID = $_trackingId");
    debugPrint("LAT = $latitude");
    debugPrint("LON = $longitude");
    debugPrint("==========");

    await _trackingRepository.sendLocation(
      userId: _userId!,
      trackingId: _trackingId!,
      latitude: latitude,
      longitude: longitude,
      accuracyMeters: accuracy,
      speed: speed,
    );

    debugPrint("TRACKING SENT SUCCESSFULLY");

  } catch (e) {

    emit(TrackingError(e.toString()));

  }
}

  Future<void> stopTrackingSession() async {

    try {

      emit(const TrackingLoading());

      if (_trackingId != null) {

        debugPrint("====================");
        debugPrint("STOPPING TRACKING");
        debugPrint("TRACKING ID = $_trackingId");
        debugPrint("====================");

        await _trackingRepository.stopTracking(
          _trackingId!,
        );

      }

      await _locationSubscription?.cancel();
      _locationSubscription = null;

      await _locationService.stopTracking();

      await _secureStorage.clearTrackingSession();

      _userId = null;
      _trackingId = null;

      debugPrint("====================");
      debugPrint("TRACKING SESSION STOPPED");
      debugPrint("====================");

      emit(const TrackingIdle());

    } catch (e) {

      debugPrint("STOP TRACKING FAILED");
      debugPrint(e.toString());

      emit(
        TrackingError(
          e.toString(),
        ),
      );

    }

  }

  @override
  Future<void> close() {
    _locationSubscription?.cancel();
    return super.close();
  }
}

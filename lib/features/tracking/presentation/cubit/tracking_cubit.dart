import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  String? _userId;
  String? _trackingId;
  StreamSubscription? _locationSubscription;

  TrackingCubit({
    required TrackingRepository trackingRepository,
    required LocationService locationService,
  })  : _trackingRepository = trackingRepository,
        _locationService = locationService,
        super(const TrackingIdle());

  Future<void> startTrackingSession({
    required String userId,
    required String trackingId,
  }) async {

    emit(const TrackingLoading());

    _userId = userId;
    _trackingId = trackingId;

    try {

      await _locationService.startTracking(
        trackingId,
      );

      await _locationSubscription?.cancel();

      _locationSubscription =
          _locationService.locationStream.listen(
                (data) async {

              try {

                await sendLocationUpdate(

                  latitude: data['latitude'] as double,

                  longitude: data['longitude'] as double,

                  accuracy: data['accuracy'] as double,

                  speed: data['speed'] as double,

                );

                emit(
                  const TrackingStreaming(),
                );

              } catch (e) {

                emit(
                  TrackingError(
                    e.toString(),
                  ),
                );

              }

            },

            onError: (err) {

              emit(
                TrackingError(
                  err.toString(),
                ),
              );

            },

          );

      emit(
        const TrackingStreaming(),
      );

    } catch (e) {

      emit(
        TrackingError(
          e.toString(),
        ),
      );

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

  } catch (e) {

    emit(TrackingError(e.toString()));

  }
}

  Future<void> stopTrackingSession() async {

    _userId = null;
    _trackingId = null;

    await _locationSubscription?.cancel();

    _locationSubscription = null;

    await _locationService.stopTracking();

    emit(
      const TrackingIdle(),
    );
  }

  @override
  Future<void> close() {
    _locationSubscription?.cancel();
    return super.close();
  }
}

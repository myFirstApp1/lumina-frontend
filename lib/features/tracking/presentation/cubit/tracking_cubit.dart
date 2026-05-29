import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/location_service.dart';
import '../../data/models/heartbeat_response_model.dart';
import '../../data/models/tracking_response_model.dart';
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
  final TrackingResponseModel? lastLocation;
  final HeartbeatResponseModel? lastHeartbeat;
  const TrackingStreaming({this.lastLocation, this.lastHeartbeat});
}

class TrackingError extends TrackingState {
  final String message;
  const TrackingError(this.message);
}

class TrackingCubit extends Cubit<TrackingState> {
  final TrackingRepository _trackingRepository;
  final LocationService _locationService;
  String? _activeSessionId;
  StreamSubscription? _locationSubscription;

  TrackingCubit({
    required TrackingRepository trackingRepository,
    required LocationService locationService,
  })  : _trackingRepository = trackingRepository,
        _locationService = locationService,
        super(const TrackingIdle());

  Future<void> startTrackingSession(String sessionId) async {
    emit(const TrackingLoading());
    _activeSessionId = sessionId;
    
    try {
      _locationSubscription?.cancel();
      await _locationService.startTracking(sessionId);
      
      _locationSubscription = _locationService.locationStream.listen(
        (data) {
          final locationModel = TrackingResponseModel.fromJson(data);
          final currentState = state;
          HeartbeatResponseModel? lastHeartbeat;
          if (currentState is TrackingStreaming) {
            lastHeartbeat = currentState.lastHeartbeat;
          }
          emit(TrackingStreaming(
            lastLocation: locationModel,
            lastHeartbeat: lastHeartbeat,
          ));
        },
        onError: (err) {
          emit(TrackingError(err.toString()));
        },
      );
      
      emit(const TrackingStreaming());
    } catch (e) {
      emit(TrackingError(e.toString()));
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
    if (_activeSessionId == null) return;
    
    final currentState = state;
    HeartbeatResponseModel? lastHeartbeat;
    if (currentState is TrackingStreaming) {
      lastHeartbeat = currentState.lastHeartbeat;
    }

    try {
      final locationModel = await _trackingRepository.sendLocation(
        sessionId: _activeSessionId!,
        latitude: latitude,
        longitude: longitude,
        accuracy: accuracy,
        speed: speed,
      );
      emit(TrackingStreaming(
        lastLocation: locationModel,
        lastHeartbeat: lastHeartbeat,
      ));
    } catch (e) {
      emit(TrackingError(e.toString()));
    }
  }

  Future<void> sendHeartbeatPing({
    required String deviceId,
    required int batteryPercentage,
    required bool offBody,
    required bool anomalyDetected,
  }) async {
    final currentState = state;
    TrackingResponseModel? lastLocation;
    if (currentState is TrackingStreaming) {
      lastLocation = currentState.lastLocation;
    }

    try {
      final heartbeatModel = await _trackingRepository.sendHeartbeat(
        deviceId: deviceId,
        batteryPercentage: batteryPercentage,
        offBody: offBody,
        anomalyDetected: anomalyDetected,
      );
      
      if (currentState is TrackingStreaming) {
        emit(TrackingStreaming(
          lastLocation: lastLocation,
          lastHeartbeat: heartbeatModel,
        ));
      }
    } catch (e) {
      // Fail silently in background telemetry checks
    }
  }

  Future<void> stopTrackingSession() async {
    _activeSessionId = null;
    _locationSubscription?.cancel();
    _locationSubscription = null;
    await _locationService.stopTracking();
    emit(const TrackingIdle());
  }

  @override
  Future<void> close() {
    _locationSubscription?.cancel();
    return super.close();
  }
}

import '../../data/models/heartbeat_response_model.dart';
import '../../data/models/tracking_response_model.dart';

abstract class TrackingRepository {
  Future<TrackingResponseModel> sendLocation({
    required String sessionId,
    required double latitude,
    required double longitude,
    required double accuracy,
    required double speed,
  });

  Future<HeartbeatResponseModel> sendHeartbeat({
    required String deviceId,
    required int batteryPercentage,
    required bool offBody,
    required bool anomalyDetected,
  });
}

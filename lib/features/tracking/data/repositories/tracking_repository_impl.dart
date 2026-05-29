import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/models/heartbeat_response_model.dart';
import '../../data/models/tracking_response_model.dart';
import '../../domain/repositories/tracking_repository.dart';

class TrackingRepositoryImpl implements TrackingRepository {
  final DioClient _client;

  TrackingRepositoryImpl({required DioClient client}) : _client = client;

  @override
  Future<TrackingResponseModel> sendLocation({
    required String sessionId,
    required double latitude,
    required double longitude,
    required double accuracy,
    required double speed,
  }) async {
    try {
      final response = await _client.dio.post(
        '/api/v1/tracking/location',
        data: {
          'sessionId': sessionId,
          'latitude': latitude,
          'longitude': longitude,
          'accuracy': accuracy,
          'speed': speed,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      return TrackingResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data['message'] as String? ?? 'Failed to send location update',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<HeartbeatResponseModel> sendHeartbeat({
    required String deviceId,
    required int batteryPercentage,
    required bool offBody,
    required bool anomalyDetected,
  }) async {
    try {
      final response = await _client.dio.post(
        '/api/v1/tracking/heartbeat',
        data: {
          'deviceId': deviceId,
          'batteryPercentage': batteryPercentage,
          'offBody': offBody,
          'anomalyDetected': anomalyDetected,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      return HeartbeatResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data['message'] as String? ?? 'Failed to send device heartbeat',
        statusCode: e.response?.statusCode,
      );
    }
  }
}

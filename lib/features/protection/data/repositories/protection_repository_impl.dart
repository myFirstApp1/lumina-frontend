import 'package:dio/dio.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/repositories/protection_repository.dart';

class ProtectionRepositoryImpl
    implements ProtectionRepository {

  final DioClient _client;

  ProtectionRepositoryImpl({
    required DioClient client,
  }) : _client = client;

  @override
  Future<void> startProtection(
      String userId,
      ) async {
    try {
      await _client.dio.post(
        '/api/heartbeat/start',
        queryParameters: {
          'userId': userId,
        },
      );
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data['message'] ??
            'Failed to start protection',
      );
    }
  }

  @override
  Future<void> sendHeartbeat(
      String userId,
      ) async {
    try {
      await _client.dio.put(
        '/api/heartbeat/$userId',
      );
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data['message'] ??
            'Failed to send heartbeat',
      );
    }
  }

  @override
  Future<void> stopProtection(
      String userId,
      ) async {
    try {
      await _client.dio.post(
        '/api/heartbeat/stop',
        queryParameters: {
          'userId': userId,
        },
      );
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data['message'] ??
            'Failed to stop protection',
      );
    }
  }

  @override
  Future<void> pauseProtection(
      String userId,
      int minutes,
      ) async {
    try {
      await _client.dio.post(
        '/api/heartbeat/pause',
        queryParameters: {
          'userId': userId,
          'minutes': minutes,
        },
      );
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data['message'] ??
            'Failed to pause protection',
      );
    }
  }

  @override
  Future<void> resumeProtection(
      String userId,
      ) async {
    try {
      await _client.dio.post(
        '/api/heartbeat/resume',
        queryParameters: {
          'userId': userId,
        },
      );
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data['message'] ??
            'Failed to resume protection',
      );
    }
  }

  @override
  Future<void> confirmSafe(
      String userId,
      ) async {
    try {
      await _client.dio.post(
        '/api/heartbeat/confirm-safe',
        queryParameters: {
          'userId': userId,
        },
      );
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data['message'] ??
            'Failed to confirm safe',
      );
    }
  }

  @override
  Future<String> getProtectionStatus(
      String userId,
      ) async {
    try {
      final response = await _client.dio.get(
        '/api/heartbeat/status',
        queryParameters: {
          'userId': userId,
        },
      );

      return response.data.toString();
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data['message'] ??
            'Failed to get protection status',
      );
    }
  }
}
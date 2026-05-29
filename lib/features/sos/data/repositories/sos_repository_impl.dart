import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/repositories/sos_repository.dart';

class SosRepositoryImpl implements SosRepository {
  final DioClient _client;

  SosRepositoryImpl({required DioClient client}) : _client = client;

  @override
  Future<String> triggerSos({
    required double latitude,
    required double longitude,
    required String triggerType,
  }) async {
    try {
      final response = await _client.dio.post(
        '/api/v1/sos/trigger',
        data: {
          'latitude': latitude,
          'longitude': longitude,
          'triggerType': triggerType,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      final data = response.data;
      return data['sessionId'] as String? ?? '';
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data['message'] as String? ?? 'Failed to trigger SOS emergency',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<void> cancelSos({
    required String sessionId,
    required String verificationCode,
  }) async {
    try {
      await _client.dio.post(
        '/api/v1/sos/cancel',
        data: {
          'sessionId': sessionId,
          'verificationCode': verificationCode,
        },
      );
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data['message'] as String? ?? 'Failed to cancel SOS session',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<Map<String, dynamic>?> getActiveSession() async {
    try {
      final response = await _client.dio.get('/api/v1/sos/active-session');
      if (response.data == null) return null;
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      // If no active session found, return null instead of throwing
      if (e.response?.statusCode == 404) {
        return null;
      }
      throw ServerException(
        e.response?.data['message'] as String? ?? 'Failed to query active session status',
        statusCode: e.response?.statusCode,
      );
    }
  }
}

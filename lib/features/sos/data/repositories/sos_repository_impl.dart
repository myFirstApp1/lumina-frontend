import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/repositories/sos_repository.dart';

class SosRepositoryImpl implements SosRepository {
  final DioClient _client;

  SosRepositoryImpl({required DioClient client}) : _client = client;

  @override
  Future<void> triggerSos({
    required String userId,
    required String location,
  }) async {
    debugPrint("SOS METHOD ENTERED");
    try {
      debugPrint("CALLING SOS API");
      debugPrint("USER = $userId");
      debugPrint("LOCATION = $location");

      final response =
      await _client.dio.post(
        '/api/sos/trigger/$userId',
        queryParameters: {
          'location': location,
        },
      );

      debugPrint(
        "SOS RESPONSE = ${response.statusCode}",

      );

    } on DioException catch (e) {

      throw ServerException(
        e.response?.data['message'] ??
            'Failed to trigger SOS',
      );

    }

  }

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

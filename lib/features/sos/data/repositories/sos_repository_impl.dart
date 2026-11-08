import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/repositories/sos_repository.dart';

class SosRepositoryImpl implements SosRepository {
  final DioClient _client;

  static const String _eventPath = '/api/sos/event';
  static const int _maxAttempts = 3;

  SosRepositoryImpl({required DioClient client}) : _client = client;

  @override
  Future<SosTriggerResult> triggerSos({
    required String userId,
    double? latitude,
    double? longitude,
  }) async {
    final response = await _sendEvent(
      userId: userId,
      event: 'SOS_BUTTON_PRESSED',
      latitude: latitude,
      longitude: longitude,
      fallbackMessage: 'Failed to trigger SOS',
    );

    final body = response.data?.toString() ?? '';

    // Backend answers 200 "SOS already active - duplicate request ignored"
    // when an incident is already open. That is not an error for the app.
    if (body.toLowerCase().contains('already active')) {
      return SosTriggerResult.alreadyActive;
    }

    return SosTriggerResult.started;
  }

  @override
  Future<void> markSafe({required String userId}) async {
    await _sendEvent(
      userId: userId,
      event: 'MARK_SAFE',
      fallbackMessage: 'Failed to mark safe',
    );
  }

  /// POST /api/sos/event?userId=..&event=..[&lat=..&lng=..]
  ///
  /// Retries only when the request never reached the server (no connection or
  /// timeout). The backend ignores duplicate SOS requests, so retrying an SOS
  /// is safe, and a dropped request must not silently lose an emergency.
  Future<Response<dynamic>> _sendEvent({
    required String userId,
    required String event,
    double? latitude,
    double? longitude,
    required String fallbackMessage,
  }) async {
    DioException? lastError;

    for (var attempt = 1; attempt <= _maxAttempts; attempt++) {
      try {
        final response = await _client.dio.post(
          _eventPath,
          queryParameters: {
            'userId': userId,
            'event': event,
            if (latitude != null) 'lat': latitude,
            if (longitude != null) 'lng': longitude,
          },
        );

        debugPrint('SOS EVENT $event -> ${response.statusCode} '
            '${response.data}');

        return response;
      } on DioException catch (e) {
        lastError = e;

        debugPrint('SOS EVENT $event FAILED (attempt $attempt) '
            'status=${e.response?.statusCode} body=${e.response?.data}');

        if (!_isConnectivityError(e) || attempt == _maxAttempts) {
          break;
        }

        await Future.delayed(const Duration(seconds: 1));
      }
    }

    throw ServerException(
      _messageFor(lastError!, fallbackMessage),
      statusCode: lastError.response?.statusCode,
    );
  }

  bool _isConnectivityError(DioException e) {
    return e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout;
  }

  /// Backend errors are JSON: {timestamp, status, code, error}.
  String _messageFor(DioException e, String fallback) {
    if (_isConnectivityError(e)) {
      return 'Cannot reach the server. Check your internet connection.';
    }

    final data = e.response?.data;
    String? code;
    String? message;

    if (data is Map) {
      code = data['code']?.toString();
      message = (data['error'] ?? data['message'])?.toString();
    } else if (data is String && data.trim().isNotEmpty) {
      message = data.trim();
    }

    switch (code) {
      case 'NO_EMERGENCY_CONTACTS':
        return 'Add at least one emergency contact before using SOS.';
      case 'USER_SERVICE_UNAVAILABLE':
        return 'Could not verify your emergency contacts. Please try again.';
      case 'SESSION_NOT_FOUND':
        return 'No active safety session found. Please restart protection.';
    }

    if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
      return 'Your session has expired. Please log in again.';
    }

    return message ?? fallback;
  }
}

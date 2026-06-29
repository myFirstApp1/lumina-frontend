import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/repositories/tracking_repository.dart';

class TrackingRepositoryImpl implements TrackingRepository {
  final DioClient _client;

  TrackingRepositoryImpl({required DioClient client}) : _client = client;

  @override
  Future<void> sendLocation({
    required String userId,
    required String trackingId,
    required double latitude,
    required double longitude,
    required double accuracyMeters,
    required double speed,
  }) async {
    try {
      await _client.dio.post(

        '/api/tracking/update',

        data: {

          "userId": userId,
          "trackingId": trackingId,

          "latitude": latitude,
          "longitude": longitude,

          "accuracyMeters": accuracyMeters,
          "speed": speed,

        },

      );

      debugPrint("TRACKING SENT");
      debugPrint("USER ID = $userId");
      debugPrint("TRACKING ID = $trackingId");
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data['message'] ??
            'Failed to send location',
      );
    }
  }

  @override
  Future<String> getTrackingId(
      String userId,
      ) async {

    final response =
    await _client.dio.get(
      '/api/tracking/tracking-id/$userId',
    );

    return response.data['trackingId'];
  }


  @override
  Future<String?> getActiveTrackingId(String userId) async {
    try {
      debugPrint("GET ACTIVE TRACKING API CALLED");
      debugPrint("USER = $userId");

      final response = await _client.dio.get(
        "/api/tracking/active/$userId",
      );

      debugPrint("SERVER RESPONSE");
      debugPrint(response.data.toString());

      if (response.data["active"] == true) {
        return response.data["trackingId"];
      }

      return null;

    } on DioException catch (e) {

      debugPrint("ACTIVE TRACKING CHECK FAILED");
      debugPrint(e.message);

      return null;
    }
  }
}


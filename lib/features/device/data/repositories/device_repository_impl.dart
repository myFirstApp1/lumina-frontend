import 'package:dio/dio.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/repositories/device_repository.dart';

class DeviceRepositoryImpl implements DeviceRepository {

  final DioClient _client;

  DeviceRepositoryImpl({
    required DioClient client,
  }) : _client = client;

  @override
  Future<void> sendBluetoothPing({
    required String userId,
  }) async {

    try {

      await _client.dio.put(
        '/api/device/ping-bluetooth/$userId',
      );

    } on DioException catch (e) {

      throw ServerException(
        e.response?.data['message'] ??
            'Bluetooth ping failed',
      );

    }
  }

  @override
  Future<void> updateVitals({
    required String userId,
    required int heartRate,
    required int movementScore,
  }) async {

    try {

      await _client.dio.post(
        '/api/device/vitals/update',
        data: {
          'userId': userId,
          'heartRate': heartRate,
          'movementScore': movementScore,
        },
      );

    } on DioException catch (e) {

      throw ServerException(
        e.response?.data['message'] ??
            'Vitals update failed',
      );

    }
  }

  @override
  Future<void> markOffBody({
    required String userId,
  }) async {

    try {

      await _client.dio.post(
        '/api/device/off-body/$userId',
      );

    } on DioException catch (e) {

      throw ServerException(
        e.response?.data['message'] ??
            'Off-body update failed',
      );

    }
  }

  @override
  Future<void> sendHeartbeat({
    required String deviceId,
    required String firmwareVersion,
    required int heartRate,
    required int hrv,
    required int movementScore,
    required int batteryLevel,
    required bool deviceWorn,
    required bool bluetoothConnected,
    required double latitude,
    required double longitude,
    required int deviceTimestamp,
  }) async {

    try {

      await _client.dio.post(
        '/api/device/heartbeat',
        data: {
          'deviceId': deviceId,
          'firmwareVersion': firmwareVersion,
          'heartRate': heartRate,
          'hrv': hrv,
          'movementScore': movementScore,
          'batteryLevel': batteryLevel,
          'deviceWorn': deviceWorn,
          'bluetoothConnected': bluetoothConnected,
          'latitude': latitude,
          'longitude': longitude,
          'deviceTimestamp': deviceTimestamp,
        },
      );

    } on DioException catch (e) {

      throw ServerException(
        e.response?.data['message'] ??
            'Heartbeat failed',
      );

    }
  }
}
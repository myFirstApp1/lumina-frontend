import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/device_repository.dart';

abstract class DeviceState {
  const DeviceState();
}

class DeviceInitial extends DeviceState {
  const DeviceInitial();
}

class DeviceLoading extends DeviceState {
  const DeviceLoading();
}

class DeviceConnected extends DeviceState {
  const DeviceConnected();
}

class DeviceError extends DeviceState {
  final String message;

  const DeviceError(this.message);
}

class DeviceCubit extends Cubit<DeviceState> {
  final DeviceRepository _repository;

  DeviceCubit({
    required DeviceRepository repository,
  }) : _repository = repository,
        super(const DeviceInitial());

  Future<void> sendBluetoothPing(
      String userId,
      ) async {
    try {
      await _repository.sendBluetoothPing(
        userId: userId,
      );

      emit(
        const DeviceConnected(),
      );
    } catch (e) {
      emit(
        DeviceError(
          e.toString(),
        ),
      );
    }
  }

  Future<void> updateVitals({
    required String userId,
    required int heartRate,
    required int movementScore,
  }) async {
    try {
      await _repository.updateVitals(
        userId: userId,
        heartRate: heartRate,
        movementScore: movementScore,
      );
    } catch (e) {
      emit(
        DeviceError(
          e.toString(),
        ),
      );
    }
  }

  Future<void> markOffBody(
      String userId,
      ) async {
    try {
      await _repository.markOffBody(
        userId: userId,
      );
    } catch (e) {
      emit(
        DeviceError(
          e.toString(),
        ),
      );
    }
  }

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
      await _repository.sendHeartbeat(
        deviceId: deviceId,
        firmwareVersion: firmwareVersion,
        heartRate: heartRate,
        hrv: hrv,
        movementScore: movementScore,
        batteryLevel: batteryLevel,
        deviceWorn: deviceWorn,
        bluetoothConnected: bluetoothConnected,
        latitude: latitude,
        longitude: longitude,
        deviceTimestamp: deviceTimestamp,
      );
    } catch (e) {
      emit(
        DeviceError(
          e.toString(),
        ),
      );
    }
  }
}
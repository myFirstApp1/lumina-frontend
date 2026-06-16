abstract class DeviceRepository {

  Future<void> sendBluetoothPing({
    required String userId,
  });

  Future<void> updateVitals({
    required String userId,
    required int heartRate,
    required int movementScore,
  });

  Future<void> markOffBody({
    required String userId,
  });

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
  });
}
abstract class SosRepository {
  Future<String> triggerSos({
    required double latitude,
    required double longitude,
    required String triggerType,
  });

  Future<void> cancelSos({
    required String sessionId,
    required String verificationCode,
  });

  Future<Map<String, dynamic>?> getActiveSession();
}

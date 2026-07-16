abstract class ProtectionRepository {
  Future<void> startProtection(String userId);

  Future<void> sendHeartbeat(
      String userId,
      int battery,
      double latitude,
      double longitude,
      );

  Future<void> stopProtection(String userId);

  Future<void> pauseProtection(
      String userId,
      int minutes,
      );

  Future<void> resumeProtection(String userId);

  Future<void> confirmSafe(String userId);

  Future<String> getProtectionStatus(String userId);
}
/// Result of asking the backend to start an SOS.
enum SosTriggerResult {
  /// A new SOS incident was created.
  started,

  /// An SOS was already active for this user (backend ignored the duplicate).
  alreadyActive,
}

abstract class SosRepository {
  /// Starts an SOS through the Java backend (the authority for SOS state).
  Future<SosTriggerResult> triggerSos({
    required String userId,
    double? latitude,
    double? longitude,
  });

  /// Marks the user safe: resolves the incident and stops backend tracking.
  Future<void> markSafe({
    required String userId,
  });
}

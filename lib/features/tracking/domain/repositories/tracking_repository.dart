abstract class TrackingRepository {
  Future<void> sendLocation({
    required String userId,
    required String trackingId,
    required double latitude,
    required double longitude,
    required double accuracyMeters,
    required double speed,
  });

  Future<String> getTrackingId(
      String userId,
      );
}
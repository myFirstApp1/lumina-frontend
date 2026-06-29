import '../../features/tracking/domain/repositories/tracking_repository.dart';

class RecoveryService {

  final TrackingRepository _trackingRepository;

  RecoveryService({
    required TrackingRepository trackingRepository,
  }) : _trackingRepository = trackingRepository;

  Future<bool> hasActiveSos(String userId) async {

    final trackingId =
    await _trackingRepository.getActiveTrackingId(
      userId,
    );

    return trackingId != null;

  }

}
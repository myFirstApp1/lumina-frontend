// import '../../features/tracking/domain/repositories/tracking_repository.dart';
//
// class RecoveryService {
//
//   final TrackingRepository _trackingRepository;
//
//   RecoveryService({
//     required TrackingRepository trackingRepository,
//   }) : _trackingRepository = trackingRepository;
//
//   Future<bool> hasActiveSos(String userId) async {
//
//     final trackingId =
//     await _trackingRepository.getActiveTrackingId(
//       userId,
//     );
//
//     return trackingId != null;
//
//   }
//
// }


class RecoveryService {
  Future<bool> hasActiveSos(String userId) async {
    // An active tracking ID does not prove that an SOS is active.
    // TODO: Check the backend's actual active SOS/incident status.
    return false;
  }
}

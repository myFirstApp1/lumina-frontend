abstract class SosRepository {

  Future<void> triggerSos({
    required String userId,
    required String location,
  });

}

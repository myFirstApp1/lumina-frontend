import '../secure_storage/secure_storage_manager.dart';
import 'recovery_service.dart';

enum StartupRoute {
  onboarding,
  login,
  home,
  activeSos,
}

class StartupService {

  final SecureStorageManager _storage;
  final RecoveryService _recoveryService;

  StartupService({
    required SecureStorageManager storage,
    required RecoveryService recoveryService,
  })
      : _storage = storage,
        _recoveryService = recoveryService;

  Future<StartupRoute> getStartupRoute() async {
    final onboardingCompleted =
    await _storage.isOnboardingCompleted();

    if (!onboardingCompleted) {
      return StartupRoute.onboarding;
    }

    final token =
    await _storage.getAccessToken();

    if (token == null || token.isEmpty) {
      return StartupRoute.login;
    }

    final userId =
    await _storage.getUserId();

    if (userId != null) {
      final active =
      await _recoveryService.hasActiveSos(
        userId,
      );

      if (active) {
        return StartupRoute.activeSos;
      }
    }

    return StartupRoute.home;
  }
}
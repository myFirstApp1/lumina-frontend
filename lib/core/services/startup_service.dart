import '../secure_storage/secure_storage_manager.dart';

enum StartupRoute {
  onboarding,
  login,
  home,
}

class StartupService {
  final SecureStorageManager _storage;

  StartupService({
    required SecureStorageManager storage,
  }) : _storage = storage;

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

    return StartupRoute.home;
  }
}
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../routes/app_routes.dart';
import '../secure_storage/secure_storage_manager.dart';

class OnboardingHelper {

  static Future<void> skip(BuildContext context) async {

    final storage = SecureStorageManager();

    await storage.setOnboardingCompleted();

    if (context.mounted) {
      context.go(AppRoutes.login);
    }

  }

}
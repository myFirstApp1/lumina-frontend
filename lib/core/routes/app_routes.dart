import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/data/models/user_model.dart';
import '../../features/location/presentation/screens/location_initialization_screen.dart';
import '../../features/onboarding/presentation/screens/splash_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_step1_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_step2_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_step3_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_step4_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_account_screen.dart';
import '../../features/auth/presentation/screens/register_verify_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/home/presentation/screens/home_dashboard_screen.dart';
import '../../features/sos/presentation/screens/sos_active_screen.dart';
import '../../features/sos/presentation/screens/pre_alert_screen.dart';
import '../../features/tracking/presentation/screens/live_tracking_screen.dart';
import '../../features/contacts/presentation/screens/contacts_circle_screen.dart';
import '../../features/contacts/presentation/screens/add_contact_screen.dart';
import 'package:lumina_guardian/features/contacts/data/models/emergency_contact_model.dart' as contacts;
import '../../features/ai_companion/presentation/screens/ai_companion_screen.dart';
import '../../features/profile/presentation/screens/wearable_sync_screen.dart';
import '../../features/profile/presentation/screens/settings_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/profile/presentation/screens/update_photo_screen.dart';
import '../../features/profile/presentation/screens/help_center_screen.dart';
import '../../features/profile/presentation/screens/privacy_policy_screen.dart';
import '../../features/profile/presentation/screens/terms_of_service_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String onboardingStep1 = '/onboarding/step1';
  static const String onboardingStep2 = '/onboarding/step2';
  static const String onboardingStep3 = '/onboarding/step3';
  static const String onboardingStep4 = '/onboarding/step4';
  
  static const String login = '/login';
  static const String signup = '/signup';
  static const String signupVerify = '/signup/verify';
  static const String forgotPassword = '/forgot-password';
  static const String locationInit = '/location-init';
  static const String home = '/home';
  static const String sosActive = '/sos-active';
  static const String preAlert = '/pre-alert';
  static const String liveTracking = '/live-tracking';
  static const String contactsCircle = '/contacts';
  static const String addContact = '/contacts/add';
  static const String contactSuccess = '/contacts/success';
  static const String contactDetail = '/contact-detail';
  static const String contactUpdatePhoto = '/contacts/update-photo';
  static const String aiCompanion = '/ai-companion';
  static const String wearableSync = '/wearable-sync';
  static const String settings = '/settings';
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String updatePhoto = '/profile/update-photo';
  static const String helpCenter = '/help-center';
  static const String privacyPolicy = '/privacy-policy';
  static const String termsOfService = '/terms-of-service';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: <RouteBase>[
      GoRoute(
        path: splash,
        builder: (BuildContext context, GoRouterState state) => const SplashScreen(),
      ),
      GoRoute(
        path: onboardingStep1,
        builder: (BuildContext context, GoRouterState state) => const OnboardingStep1Screen(),
      ),
      GoRoute(
        path: onboardingStep2,
        builder: (BuildContext context, GoRouterState state) => const OnboardingStep2Screen(),
      ),
      GoRoute(
        path: onboardingStep3,
        builder: (BuildContext context, GoRouterState state) => const OnboardingStep3Screen(),
      ),
      GoRoute(
        path: onboardingStep4,
        builder: (BuildContext context, GoRouterState state) => const OnboardingStep4Screen(),
      ),
      GoRoute(
        path: login,
        builder: (BuildContext context, GoRouterState state) => const LoginScreen(),
      ),
      GoRoute(
        path: signup,
        builder: (BuildContext context, GoRouterState state) => const RegisterAccountScreen(),
      ),

      GoRoute(
        path: signupVerify,
        builder: (BuildContext context, GoRouterState state) {
          final extraData = state.extra as Map<String, dynamic>?;
          return RegisterVerifyScreen(
            email: extraData?['email'] as String?,
            txnId: extraData?['txnId'] as String?,
          );
        },
      ),
      GoRoute(
        path: forgotPassword,
        builder: (BuildContext context, GoRouterState state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: locationInit,
        builder: (context, state) => const LocationInitializationScreen(),
      ),
      GoRoute(
        path: home,
        builder: (BuildContext context, GoRouterState state) => const HomeDashboardScreen(),
      ),
      GoRoute(
        path: sosActive,
        builder: (BuildContext context, GoRouterState state) => const SosActiveScreen(),
      ),
      GoRoute(
        path: preAlert,
        builder: (BuildContext context, GoRouterState state) => const PreAlertScreen(),
      ),
      GoRoute(
        path: liveTracking,
        builder: (BuildContext context, GoRouterState state) => const LiveTrackingScreen(),
      ),
      GoRoute(
        path: contactsCircle,
        builder: (BuildContext context, GoRouterState state) => const ContactsCircleScreen(),
      ),
      GoRoute(
        path: addContact,
        builder: (BuildContext context, GoRouterState state) {
          final data = state.extra as Map<String, dynamic>?;

          return AddContactScreen(
            contact: data?["contact"],
            contactCount: data?["contactCount"] ?? 0,
          );
        },
      ),
      GoRoute(
        path: aiCompanion,
        builder: (BuildContext context, GoRouterState state) => const AiCompanionScreen(),
      ),
      GoRoute(
        path: wearableSync,
        builder: (BuildContext context, GoRouterState state) => const WearableSyncScreen(),
      ),
      GoRoute(
        path: settings,
        builder: (BuildContext context, GoRouterState state) => const SettingsScreen(),
      ),
      GoRoute(
        path: profile,
        builder: (BuildContext context, GoRouterState state) => const ProfileScreen(),
      ),
      GoRoute(
        path: editProfile,
        builder: (BuildContext context, GoRouterState state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: updatePhoto,
        builder: (BuildContext context, GoRouterState state) => const UpdatePhotoScreen(),
      ),
      GoRoute(
        path: helpCenter,
        builder: (BuildContext context, GoRouterState state) => const HelpCenterScreen(),
      ),
      GoRoute(
        path: privacyPolicy,
        builder: (BuildContext context, GoRouterState state) => const PrivacyPolicyScreen(),
      ),
      GoRoute(
        path: termsOfService,
        builder: (BuildContext context, GoRouterState state) => const TermsOfServiceScreen(),
      ),
    ],
  );
}

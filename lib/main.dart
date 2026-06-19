import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'core/network/dio_client.dart';
import 'core/secure_storage/secure_storage_manager.dart';
import 'core/services/location_service.dart';
import 'core/config/api_config.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/sos/data/repositories/sos_repository_impl.dart';
import 'features/sos/presentation/cubit/sos_cubit.dart';
import 'features/tracking/data/repositories/tracking_repository_impl.dart';
import 'features/tracking/presentation/cubit/tracking_cubit.dart';
import 'features/profile/presentation/cubit/wearable_cubit.dart';
import 'features/ai_companion1/presentation/cubit/ai_companion_cubit.dart';
import 'features/profile/data/repositories/profile_repository_impl.dart';
import 'features/profile/presentation/cubit/profile_cubit.dart';
import 'features/contacts/data/repositories/contacts_repository_impl.dart';
import 'features/contacts/presentation/cubit/contacts_cubit.dart';
import 'features/protection/data/repositories/protection_repository_impl.dart';
import 'features/protection/presentation/cubit/protection_cubit.dart';
import 'features/device/data/repositories/device_repository_impl.dart';
import 'features/device/presentation/cubit/device_cubit.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      debugPrint('Captured Flutter Error: ${details.exceptionAsString()}');
      debugPrint('Stack trace: ${details.stack}');
    };

    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      debugPrint('Captured Platform Error: $error');
      debugPrint('Stack trace: $stack');
      return true;
    };

    // Initialize secure storage manager
    final secureStorage = SecureStorageManager();

    // Initialize network client with base URL
    final authDioClient = DioClient(
      baseUrl: ApiConfig.authBaseUrl,
      secureStorage: secureStorage,
    );
    final safetyDioClient = DioClient(
      baseUrl: ApiConfig.safetyBaseUrl,
      secureStorage: secureStorage,
    );

    // User Service Dio client sharing same secure storage (interceptors)
    final userDioClient = DioClient(
      baseUrl: ApiConfig.userBaseUrl,
      secureStorage: secureStorage,
    );

    // Initialize location service
    final locationService = LocationService();

    // Initialize repositories
    final authRepository = AuthRepositoryImpl(
      client: authDioClient,
      secureStorage: secureStorage,
    );
    final trackingRepository = TrackingRepositoryImpl(
      client: safetyDioClient,
    );
    final sosRepository = SosRepositoryImpl(
      client: safetyDioClient,
    );
    final profileRepository = ProfileRepositoryImpl(
      client: userDioClient,
    );
    final contactsRepository = ContactsRepositoryImpl(
      client: userDioClient,
    );
    final protectionRepository = ProtectionRepositoryImpl(
      client: safetyDioClient,
    );
    final deviceRepository = DeviceRepositoryImpl(
      client: safetyDioClient,
    );

    // Initialize cubits
    final authCubit = AuthCubit(authRepository: authRepository);
    final trackingCubit = TrackingCubit(
      trackingRepository: trackingRepository,
      locationService: locationService,
    );
    final sosCubit = SosCubit(
      sosRepository: sosRepository,
      trackingCubit: trackingCubit,
      secureStorage: secureStorage,
      locationService: locationService,
      trackingRepository: trackingRepository,
    );
    final wearableCubit = WearableCubit();
    final aiCompanionCubit = AiCompanionCubit();
    final profileCubit = ProfileCubit(repository: profileRepository);
    final contactsCubit = ContactsCubit(repository: contactsRepository);
    final protectionCubit = ProtectionCubit(
      repository: protectionRepository,
    );
    final deviceCubit = DeviceCubit(
      repository: deviceRepository,
    );
    final ImagePicker picker = ImagePicker();
    
    // Check user authentication status on startup
    await authCubit.checkAuthStatus();
    await recoverLostData();

    runApp(LuminaGuardianApp(
      authCubit: authCubit,
      trackingCubit: trackingCubit,
      sosCubit: sosCubit,
      wearableCubit: wearableCubit,
      aiCompanionCubit: aiCompanionCubit,
      profileCubit: profileCubit,
      contactsCubit: contactsCubit,
      protectionCubit: protectionCubit,
      deviceCubit: deviceCubit,
    ));
  }, (Object error, StackTrace stack) {
    debugPrint('Captured Uncaught Zoned Error: $error');
    debugPrint('Stack trace: $stack');
  });
}


Future<void> recoverLostData() async {

  try {

    final ImagePicker picker =
    ImagePicker();

    final LostDataResponse response =
    await picker.retrieveLostData();

    debugPrint(
      "LOST DATA EMPTY = ${response.isEmpty}",
    );

    if (response.files != null &&
        response.files!.isNotEmpty) {

      debugPrint(
        "RECOVERED FILE = ${response.files!.first.path}",
      );
    }

  } catch (e, s) {

    debugPrint(
      "RECOVER LOST DATA ERROR",
    );

    debugPrint(
      e.toString(),
    );

    debugPrint(
      s.toString(),
    );
  }
}

class LuminaGuardianApp extends StatelessWidget {
  final AuthCubit authCubit;
  final TrackingCubit trackingCubit;
  final SosCubit sosCubit;
  final WearableCubit wearableCubit;
  final AiCompanionCubit aiCompanionCubit;
  final ProfileCubit profileCubit;
  final ContactsCubit contactsCubit;
  final ProtectionCubit protectionCubit;
  final DeviceCubit deviceCubit;

  const LuminaGuardianApp({
    Key? key,
    required this.authCubit,
    required this.trackingCubit,
    required this.sosCubit,
    required this.wearableCubit,
    required this.aiCompanionCubit,
    required this.profileCubit,
    required this.contactsCubit,
    required this.protectionCubit,
    required this.deviceCubit,
  }) : super(key: key);
    
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>.value(value: authCubit),
        BlocProvider<TrackingCubit>.value(value: trackingCubit),
        BlocProvider<SosCubit>.value(value: sosCubit),
        BlocProvider<WearableCubit>.value(value: wearableCubit),
        BlocProvider<AiCompanionCubit>.value(value: aiCompanionCubit),
        BlocProvider<ProfileCubit>.value(value: profileCubit),
        BlocProvider<ContactsCubit>.value(value: contactsCubit),
        BlocProvider<ProtectionCubit>.value(value: protectionCubit),
        BlocProvider<DeviceCubit>.value(value: deviceCubit),
      ],
      child: MaterialApp.router(
        title: 'Lumina Guardian',
        theme: AppTheme.lightTheme,
        routerConfig: AppRoutes.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

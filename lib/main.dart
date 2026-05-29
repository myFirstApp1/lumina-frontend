import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'core/network/dio_client.dart';
import 'core/secure_storage/secure_storage_manager.dart';
import 'core/services/location_service.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/sos/data/repositories/sos_repository_impl.dart';
import 'features/sos/presentation/cubit/sos_cubit.dart';
import 'features/tracking/data/repositories/tracking_repository_impl.dart';
import 'features/tracking/presentation/cubit/tracking_cubit.dart';
import 'features/profile/presentation/cubit/wearable_cubit.dart';
import 'features/ai_companion1/presentation/cubit/ai_companion_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize secure storage manager
  final secureStorage = SecureStorageManager();

  // Initialize network client with base URL
  final dioClient = DioClient(
    baseUrl: 'https://api.luminaguardian.com', // Base URL for the safety services backend
    secureStorage: secureStorage,
  );

  // Initialize location service
  final locationService = LocationService();

  // Initialize repositories
  final authRepository = AuthRepositoryImpl(
    client: dioClient,
    secureStorage: secureStorage,
  );
  final trackingRepository = TrackingRepositoryImpl(
    client: dioClient,
  );
  final sosRepository = SosRepositoryImpl(
    client: dioClient,
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
  );
  final wearableCubit = WearableCubit();
  final aiCompanionCubit = AiCompanionCubit();

  // Check user authentication status on startup
  await authCubit.checkAuthStatus();

  runApp(LuminaGuardianApp(
    authCubit: authCubit,
    trackingCubit: trackingCubit,
    sosCubit: sosCubit,
    wearableCubit: wearableCubit,
    aiCompanionCubit: aiCompanionCubit,
  ));
}

class LuminaGuardianApp extends StatelessWidget {
  final AuthCubit authCubit;
  final TrackingCubit trackingCubit;
  final SosCubit sosCubit;
  final WearableCubit wearableCubit;
  final AiCompanionCubit aiCompanionCubit;

  const LuminaGuardianApp({
    Key? key,
    required this.authCubit,
    required this.trackingCubit,
    required this.sosCubit,
    required this.wearableCubit,
    required this.aiCompanionCubit,
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

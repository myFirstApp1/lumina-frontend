import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';

import '../cubit/location_initialization_cubit.dart';
import '../cubit/location_initialization_state.dart';
import '../../../../core/routes/app_routes.dart';

class LocationInitializationScreen extends StatefulWidget {
  const LocationInitializationScreen({super.key});

  @override
  State<LocationInitializationScreen> createState() =>
      _LocationInitializationScreenState();
}

class _LocationInitializationScreenState
    extends State<LocationInitializationScreen>
    with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    context
        .read<LocationInitializationCubit>()
        .initialize();
  }

  @override
  void dispose() {

    WidgetsBinding.instance.removeObserver(this);

    super.dispose();

  }

  @override
  void didChangeAppLifecycleState(
      AppLifecycleState state) {

    if (state == AppLifecycleState.resumed) {

      context
          .read<LocationInitializationCubit>()
          .initialize();

    }
  }

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<
        LocationInitializationCubit,
        LocationInitializationState>(

      listener: (context, state) {

        if (state is LocationInitializationSuccess) {

          context.go(
            AppRoutes.home,
          );
        }
      },

      builder: (context, state) {

        if (state is LocationServiceDisabled) {

          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [

                  const Text(
                    "Please Enable GPS",
                  ),

                  ElevatedButton(
                    onPressed: () async {

                      await Geolocator.openLocationSettings();

                      await Future.delayed(
                        const Duration(seconds: 2),
                      );

                      context
                          .read<LocationInitializationCubit>()
                          .initialize();
                    },
                    child: const Text(
                      "Enable GPS",
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is LocationPermissionRequired) {

          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [

                  const Text(
                    "Location Permission Required",
                  ),

                  ElevatedButton(
                    onPressed: () {

                      context
                          .read<LocationInitializationCubit>()
                          .initialize();

                    },
                    child: const Text(
                      "Retry",
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
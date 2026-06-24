import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import 'location_initialization_state.dart';

class LocationInitializationCubit
    extends Cubit<LocationInitializationState> {

  LocationInitializationCubit()
      : super(LocationInitializationLoading());

  Future<void> initialize() async {

    emit(LocationInitializationLoading());

    bool serviceEnabled =
    await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {

      emit(LocationServiceDisabled());

      return;
    }

    LocationPermission permission =
    await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {

      permission =
      await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {

        emit(LocationPermissionRequired());

        return;
      }
    }

    if (permission ==
        LocationPermission.deniedForever) {

      emit(LocationPermissionRequired());

      return;
    }

    emit(LocationInitializationSuccess());
  }
}
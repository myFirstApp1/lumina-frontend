abstract class LocationInitializationState {}

class LocationInitializationLoading
    extends LocationInitializationState {}

class LocationInitializationSuccess
    extends LocationInitializationState {}

class LocationPermissionRequired
    extends LocationInitializationState {}

class LocationServiceDisabled
    extends LocationInitializationState {}

class LocationInitializationError
    extends LocationInitializationState {

  final String message;

  LocationInitializationError(this.message);
}
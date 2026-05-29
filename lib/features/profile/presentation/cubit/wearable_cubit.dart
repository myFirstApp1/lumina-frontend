import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class WearableState extends Equatable {
  const WearableState();
  @override
  List<Object?> get props => [];
}

class WearableDisconnected extends WearableState {}
class WearableScanning extends WearableState {}
class WearableConnected extends WearableState {
  final String deviceName;
  final int batteryLevel;
  final int currentHeartRate;
  
  const WearableConnected({
    required this.deviceName,
    required this.batteryLevel,
    required this.currentHeartRate,
  });

  @override
  List<Object?> get props => [deviceName, batteryLevel, currentHeartRate];
}
class WearableAnomalyDetected extends WearableState {
  final int bpm;
  const WearableAnomalyDetected(this.bpm);

  @override
  List<Object?> get props => [bpm];
}

class WearableCubit extends Cubit<WearableState> {
  WearableCubit() : super(WearableDisconnected());

  void startScanning() async {
    emit(WearableScanning());
    await Future.delayed(const Duration(milliseconds: 1500));
    emit(const WearableConnected(
      deviceName: "Lumina Ring Pro V2",
      batteryLevel: 88,
      currentHeartRate: 72,
    ));
  }

  void updateHeartRate(int bpm) {
    if (state is WearableConnected) {
      final current = state as WearableConnected;
      if (bpm > 120 || bpm < 50) {
        emit(WearableAnomalyDetected(bpm));
      } else {
        emit(WearableConnected(
          deviceName: current.deviceName,
          batteryLevel: current.batteryLevel,
          currentHeartRate: bpm,
        ));
      }
    }
  }

  void disconnectDevice() {
    emit(WearableDisconnected());
  }
}

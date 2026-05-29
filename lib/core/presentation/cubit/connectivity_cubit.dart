import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/connectivity_service.dart';

abstract class ConnectivityState {
  final ConnectionStatus status;
  const ConnectivityState(this.status);
}

class ConnectivityInitial extends ConnectivityState {
  const ConnectivityInitial() : super(ConnectionStatus.online);
}

class ConnectivityChanged extends ConnectivityState {
  const ConnectivityChanged(super.status);
}

class ConnectivityCubit extends Cubit<ConnectivityState> {
  final ConnectivityService _connectivityService;
  StreamSubscription? _subscription;

  ConnectivityCubit({required ConnectivityService connectivityService})
      : _connectivityService = connectivityService,
        super(const ConnectivityInitial()) {
    _monitorConnectivity();
  }

  void _monitorConnectivity() async {
    final current = await _connectivityService.currentStatus;
    emit(ConnectivityChanged(current));

    _subscription = _connectivityService.statusStream.listen((status) {
      emit(ConnectivityChanged(status));
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}

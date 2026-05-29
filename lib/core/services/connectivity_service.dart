import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

enum ConnectionStatus { online, offline }

class ConnectivityService {
  final Connectivity _connectivity;
  final StreamController<ConnectionStatus> _statusController = StreamController<ConnectionStatus>.broadcast();

  ConnectivityService({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity() {
    _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      _statusController.add(_mapResultsToStatus(results));
    });
  }

  Stream<ConnectionStatus> get statusStream => _statusController.stream;

  Future<ConnectionStatus> get currentStatus async {
    try {
      final results = await _connectivity.checkConnectivity();
      return _mapResultsToStatus(results);
    } catch (_) {
      return ConnectionStatus.offline;
    }
  }

  ConnectionStatus _mapResultsToStatus(List<ConnectivityResult> results) {
    if (results.isEmpty || results.contains(ConnectivityResult.none)) {
      return ConnectionStatus.offline;
    }
    return ConnectionStatus.online;
  }

  void dispose() {
    _statusController.close();
  }
}

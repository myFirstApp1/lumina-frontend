import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/repositories/incident_repository.dart';
import 'incident_state.dart';

class IncidentCubit extends Cubit<IncidentState> {
  final IncidentRepository _repository;

  IncidentCubit({
    required IncidentRepository repository,
  })  : _repository = repository,
        super(IncidentState.initial());

  /// Load all incidents for the current user.
  Future<void> loadIncidentHistory(
      String userId,
      ) async {
    emit(
      state.copyWith(
        isLoading: true,
        error: null,
      ),
    );

    try {
      final incidents =
      await _repository.getIncidentHistory(userId);

      emit(
        state.copyWith(
          isLoading: false,
          incidents: incidents,
        ),
      );
    } on ServerException catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: e.message,
        ),
      );
    }
  }

  /// Load one incident.
  Future<void> loadIncidentDetails(
      String incidentId,
      ) async {
    emit(
      state.copyWith(
        isLoading: true,
        error: null,
      ),
    );

    try {
      final incident =
      await _repository.getIncidentDetails(
        incidentId,
      );

      emit(
        state.copyWith(
          isLoading: false,
          selectedIncident: incident,
        ),
      );
    } on ServerException catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: e.message,
        ),
      );
    }
  }

  /// Load timeline.
  Future<void> loadTimeline(
      String incidentId,
      ) async {
    try {
      final timeline =
      await _repository.getTimeline(
        incidentId,
      );

      emit(
        state.copyWith(
          timeline: timeline,
        ),
      );
    } on ServerException catch (e) {
      emit(
        state.copyWith(
          error: e.message,
        ),
      );
    }
  }

  /// Load active emergency monitor.
  Future<void> loadEmergencyMonitor(
      String trackingId,
      ) async {
    emit(
      state.copyWith(
        isLoading: true,
        error: null,
      ),
    );

    try {
      final monitor =
      await _repository.getEmergencyMonitor(
        trackingId,
      );

      emit(
        state.copyWith(
          isLoading: false,
          emergencyMonitor: monitor,
        ),
      );
    } on ServerException catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: e.message,
        ),
      );
    }
  }

  void clearError() {
    emit(
      state.copyWith(
        error: null,
      ),
    );
  }
}
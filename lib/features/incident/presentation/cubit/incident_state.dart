import '../../data/models/emergency_monitor_model.dart';
import '../../data/models/incident_model.dart';
import '../../data/models/timeline_event_model.dart';

class IncidentState {
  final bool isLoading;

  final List<IncidentModel> incidents;

  final IncidentModel? selectedIncident;

  final List<TimelineEventModel> timeline;

  final EmergencyMonitorModel? emergencyMonitor;

  final String? error;

  const IncidentState({
    this.isLoading = false,
    this.incidents = const [],
    this.selectedIncident,
    this.timeline = const [],
    this.emergencyMonitor,
    this.error,
  });

  IncidentState copyWith({
    bool? isLoading,
    List<IncidentModel>? incidents,
    IncidentModel? selectedIncident,
    List<TimelineEventModel>? timeline,
    EmergencyMonitorModel? emergencyMonitor,
    String? error,
  }) {
    return IncidentState(
      isLoading: isLoading ?? this.isLoading,
      incidents: incidents ?? this.incidents,
      selectedIncident:
      selectedIncident ?? this.selectedIncident,
      timeline: timeline ?? this.timeline,
      emergencyMonitor:
      emergencyMonitor ?? this.emergencyMonitor,
      error: error,
    );
  }

  factory IncidentState.initial() {
    return const IncidentState();
  }
}
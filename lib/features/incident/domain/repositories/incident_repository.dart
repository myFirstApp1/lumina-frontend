import '../../data/models/emergency_monitor_model.dart';
import '../../data/models/incident_model.dart';
import '../../data/models/timeline_event_model.dart';

abstract class IncidentRepository {
  /// Load all incidents for the logged-in user.
  Future<List<IncidentModel>> getIncidentHistory(
      String userId,
      );

  /// Load a single incident.
  Future<IncidentModel> getIncidentDetails(
      String incidentId,
      );

  /// Load timeline events.
  Future<List<TimelineEventModel>> getTimeline(
      String incidentId,
      );

  /// Load the active emergency monitor.
  Future<EmergencyMonitorModel> getEmergencyMonitor(
      String trackingId,
      );
}
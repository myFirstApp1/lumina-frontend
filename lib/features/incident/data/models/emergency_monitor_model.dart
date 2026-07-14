import 'timeline_event_model.dart';

class EmergencyMonitorModel {
  final String trackingId;
  final String status;
  final int riskScore;

  final double? latitude;
  final double? longitude;

  final DateTime? lastPingTime;

  final List<TimelineEventModel> timeline;

  const EmergencyMonitorModel({
    required this.trackingId,
    required this.status,
    required this.riskScore,
    required this.latitude,
    required this.longitude,
    required this.lastPingTime,
    required this.timeline,
  });

  factory EmergencyMonitorModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return EmergencyMonitorModel(
      trackingId: json['trackingId'] ?? '',
      status: json['status'] ?? '',
      riskScore: json['riskScore'] ?? 0,

      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),

      lastPingTime: json['lastPingTime'] != null
          ? DateTime.parse(json['lastPingTime'])
          : null,

      timeline: (json['timeline'] as List<dynamic>? ?? [])
          .map(
            (e) => TimelineEventModel.fromJson(
          e as Map<String, dynamic>,
        ),
      )
          .toList(),
    );
  }
}
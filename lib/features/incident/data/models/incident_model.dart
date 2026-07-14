class IncidentModel {
  final String incidentId;
  final String userId;
  final String trackingId;

  final String triggerType;
  final String status;

  final int riskScore;

  final double? latitude;
  final double? longitude;

  final String incidentSource;

  final DateTime createdAt;
  final DateTime? warningAt;
  final DateTime? dangerAt;
  final DateTime? trackingStartedAt;
  final DateTime? resolvedAt;
  final DateTime? closedAt;

  const IncidentModel({
    required this.incidentId,
    required this.userId,
    required this.trackingId,
    required this.triggerType,
    required this.status,
    required this.riskScore,
    required this.latitude,
    required this.longitude,
    required this.incidentSource,
    required this.createdAt,
    this.warningAt,
    this.dangerAt,
    this.trackingStartedAt,
    this.resolvedAt,
    this.closedAt,
  });

  factory IncidentModel.fromJson(Map<String, dynamic> json) {
    return IncidentModel(
      incidentId: json['incidentId'].toString(),
      userId: json['userId'].toString(),
      trackingId: json['trackingId'] ?? '',

      triggerType: json['triggerType'] ?? '',
      status: json['status'] ?? '',

      riskScore: json['riskScore'] ?? 0,

      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),

      incidentSource: json['incidentSource'] ?? '',

      createdAt: DateTime.parse(json['createdAt']),

      warningAt: json['warningAt'] != null
          ? DateTime.parse(json['warningAt'])
          : null,

      dangerAt: json['dangerAt'] != null
          ? DateTime.parse(json['dangerAt'])
          : null,

      trackingStartedAt: json['trackingStartedAt'] != null
          ? DateTime.parse(json['trackingStartedAt'])
          : null,

      resolvedAt: json['resolvedAt'] != null
          ? DateTime.parse(json['resolvedAt'])
          : null,

      closedAt: json['closedAt'] != null
          ? DateTime.parse(json['closedAt'])
          : null,
    );
  }
}
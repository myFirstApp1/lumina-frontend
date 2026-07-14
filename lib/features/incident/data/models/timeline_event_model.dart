class TimelineEventModel {
  final String eventType;
  final String eventData;
  final DateTime createdAt;

  const TimelineEventModel({
    required this.eventType,
    required this.eventData,
    required this.createdAt,
  });

  factory TimelineEventModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return TimelineEventModel(
      eventType: json['eventType'] ?? '',
      eventData: json['eventData'] ?? '',
      createdAt: DateTime.parse(
        json['createdAt'],
      ),
    );
  }
}
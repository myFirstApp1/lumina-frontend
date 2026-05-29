class TrackingResponseModel {
  final String sessionId;
  final double latitude;
  final double longitude;
  final double accuracy;
  final double speed;
  final DateTime timestamp;

  TrackingResponseModel({
    required this.sessionId,
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.speed,
    required this.timestamp,
  });

  factory TrackingResponseModel.fromJson(Map<String, dynamic> json) {
    return TrackingResponseModel(
      sessionId: json['sessionId'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      accuracy: (json['accuracy'] as num? ?? 0.0).toDouble(),
      speed: (json['speed'] as num? ?? 0.0).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'latitude': latitude,
      'longitude': longitude,
      'accuracy': accuracy,
      'speed': speed,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

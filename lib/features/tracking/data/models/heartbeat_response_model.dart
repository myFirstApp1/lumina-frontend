class HeartbeatResponseModel {
  final String deviceId;
  final String status;
  final DateTime lastSeen;
  final int batteryPercentage;
  final bool offBody;
  final bool anomalyDetected;

  HeartbeatResponseModel({
    required this.deviceId,
    required this.status,
    required this.lastSeen,
    required this.batteryPercentage,
    required this.offBody,
    required this.anomalyDetected,
  });

  factory HeartbeatResponseModel.fromJson(Map<String, dynamic> json) {
    return HeartbeatResponseModel(
      deviceId: json['deviceId'] as String,
      status: json['status'] as String,
      lastSeen: DateTime.parse(json['lastSeen'] as String),
      batteryPercentage: json['batteryPercentage'] as int,
      offBody: json['offBody'] as bool? ?? false,
      anomalyDetected: json['anomalyDetected'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deviceId': deviceId,
      'status': status,
      'lastSeen': lastSeen.toIso8601String(),
      'batteryPercentage': batteryPercentage,
      'offBody': offBody,
      'anomalyDetected': anomalyDetected,
    };
  }
}

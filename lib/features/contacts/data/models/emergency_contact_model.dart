import 'package:equatable/equatable.dart';

class EmergencyContactModel extends Equatable {
  final String id;
  final String name;
  final String phoneNumber;
  final String relation;

  const EmergencyContactModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.relation,
  });

  factory EmergencyContactModel.fromJson(Map<String, dynamic> json) {
    return EmergencyContactModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      relation: json['relation'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'relation': relation,
    };
  }

  EmergencyContactModel copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? relation,
  }) {
    return EmergencyContactModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      relation: relation ?? this.relation,
    );
  }

  @override
  List<Object?> get props => [id, name, phoneNumber, relation];
}

class EmergencyContactRequestModel extends Equatable {
  final String name;
  final String phoneNumber;
  final String relation;

  const EmergencyContactRequestModel({
    required this.name,
    required this.phoneNumber,
    required this.relation,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'relation': relation,
    };
  }

  @override
  List<Object?> get props => [name, phoneNumber, relation];
}

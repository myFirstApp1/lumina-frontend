class UserModel {
  final String userId;   // From Auth Service
  final String profileId;    // From User Service
  final String name;
  final String email;
  final String? phone;

  final List<EmergencyContactModel> emergencyContacts;


  UserModel({
    required this.userId,
    required this.profileId,
    required this.name,
    required this.email,
    this.phone,
    required this.emergencyContacts,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'] ?? '',
      profileId: json['profileId'] ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString(),
      emergencyContacts:
      (json['emergencyContacts'] as List?)
          ?.map((e) =>
          EmergencyContactModel.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': profileId,
      'name': name,
      'email': email,
      'phone': phone,
      'emergencyContacts':
      emergencyContacts.map((e) => e.toJson()).toList(),
    };
  }
}

class EmergencyContactModel {
  final String id;
  final String name;
  final String phone;
  final String relation;

  EmergencyContactModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.relation,
  });

  factory EmergencyContactModel.fromJson(Map<String, dynamic> json) {
    return EmergencyContactModel(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      relation: json['relation'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'relation': relation,
    };
  }

}

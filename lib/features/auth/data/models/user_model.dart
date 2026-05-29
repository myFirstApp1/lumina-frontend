class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final List<EmergencyContactModel> emergencyContacts;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.emergencyContacts,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      emergencyContacts: (json['emergencyContacts'] as List<dynamic>?)
              ?.map((e) => EmergencyContactModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'emergencyContacts': emergencyContacts.map((e) => e.toJson()).toList(),
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

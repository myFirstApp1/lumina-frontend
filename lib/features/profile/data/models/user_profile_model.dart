import 'package:equatable/equatable.dart';

class UserProfileModel extends Equatable {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String address;

  const UserProfileModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.address,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      address: json['address'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'address': address,
    };
  }

  UserProfileModel copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phone,
    String? address,
  }) {
    return UserProfileModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
    );
  }

  @override
  List<Object?> get props => [id, fullName, email, phone, address];
}

class UserProfileResponseModel extends Equatable {
  final UserProfileModel profile;
  
  const UserProfileResponseModel({
    required this.profile,
  });

  factory UserProfileResponseModel.fromJson(Map<String, dynamic> json) {
    // If the response is flat, we parse it directly. 
    // Usually a wrapper DTO might have fields like 'userProfile'
    // I will try to parse it safely.
    return UserProfileResponseModel(
      profile: UserProfileModel.fromJson(json['profile'] ?? json),
    );
  }

  @override
  List<Object?> get props => [profile];
}

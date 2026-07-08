import 'package:equatable/equatable.dart';

class UserProfileModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String avatar;
  final String address;

  const UserProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.avatar,
    required this.address,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      avatar: json["avatar"]as String? ?? '',
      address: json['address'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      "avatar": avatar,
      'address': address,
    };
  }

  UserProfileModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? avatar,
    String? address,
  }) {
    return UserProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      address: address ?? this.address,
    );
  }

  @override
  List<Object?> get props => [id, name, email, phone, avatar, address];
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

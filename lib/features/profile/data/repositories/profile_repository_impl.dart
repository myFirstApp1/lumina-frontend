import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/repositories/profile_repository.dart';
import '../models/user_profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final DioClient client;

  ProfileRepositoryImpl({required this.client});

  @override
  Future<UserProfileModel> getUserProfile(String userId) async {
    try {
      debugPrint("================================");
      debugPrint("PROFILE API START");
      debugPrint("REQUEST USER ID = $userId");

      final response = await client.dio.get('/api/users/$userId');

      debugPrint("PROFILE RESPONSE RAW:");
      debugPrint(response.data.toString());

      final profile = UserProfileModel.fromJson(
        response.data as Map<String, dynamic>,
      );

      debugPrint("PROFILE PARSED SUCCESS");
      debugPrint("PROFILE ID    = ${profile.id}");
      debugPrint("PROFILE NAME  = ${profile.name}");
      debugPrint("PROFILE EMAIL = ${profile.email}");

      debugPrint("================================");

      return profile;
    } catch (e, stack) {
      debugPrint("================================");
      debugPrint("PROFILE REPOSITORY ERROR");
      debugPrint(e.toString());
      debugPrint(stack.toString());
      debugPrint("================================");

      rethrow;
    }
  }
  @override
  Future<UserProfileModel> updateProfile(String userId, UserProfileModel profile) async {
    try {
      final response = await client.dio.put(
        '/api/users/$userId',
        data: profile.toJson(),
      );
      return UserProfileModel.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.response?.data?['message'] ?? 'Failed to update profile');
      }
      throw Exception('An unexpected error occurred');
    }
  }
}

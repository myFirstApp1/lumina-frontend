import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/repositories/profile_repository.dart';
import '../models/user_profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final DioClient client;

  ProfileRepositoryImpl({required this.client});

  @override
  Future<UserProfileModel> getUserProfile(String userId) async {
    try {
      final response = await client.dio.get('/api/users/$userId');
      final responseModel = UserProfileResponseModel.fromJson(response.data);
      return responseModel.profile;
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.response?.data?['message'] ?? 'Failed to load profile');
      }
      throw Exception('An unexpected error occurred');
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

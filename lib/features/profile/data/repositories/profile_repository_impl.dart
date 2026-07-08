import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
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
    debugPrint("========== UPDATE REQUEST ==========");
    debugPrint("USER ID = $userId");
    debugPrint(profile.toJson().toString());

    try {
      debugPrint(profile.toJson().toString());
      final response = await client.dio.put(
        '/api/users/$userId',
        data: profile.toJson(),
      );
      debugPrint("========== UPDATE RESPONSE ==========");
      debugPrint(response.data.toString());
      return UserProfileModel.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.response?.data?['message'] ?? 'Failed to update profile');
      }
      throw Exception('An unexpected error occurred');
    }
  }

  @override
  Future<void> uploadProfilePicture(
      String userId,
      String filePath,
      ) async {

    debugPrint("========== UPLOAD START ==========");
    debugPrint("USER ID = $userId");
    debugPrint("FILE PATH = $filePath");

    FormData formData = FormData.fromMap({
      'userId': userId,
      'file': await MultipartFile.fromFile(
        filePath,
      ),
    });

    try {

      debugPrint("CALLING PROFILE UPLOAD API");

      final response = await client.dio.post(
        '/api/users/profile-picture',
        data: formData,
      );

      debugPrint("UPLOAD SUCCESS");
      debugPrint("STATUS = ${response.statusCode}");
      debugPrint("RESPONSE = ${response.data}");

    } on DioException catch (e) {

      debugPrint("UPLOAD FAILED");
      debugPrint("STATUS = ${e.response?.statusCode}");
      debugPrint("BODY = ${e.response?.data}");
      debugPrint("ERROR = ${e.message}");

      rethrow;
    } catch (e) {

      debugPrint("UNEXPECTED ERROR");
      debugPrint(e.toString());

      rethrow;
    }
  }

  // @override
  // Future<void> uploadProfilePicture(
  //     String userId,
  //     String filePath,
  //     ) async {
  //
  //   debugPrint("STEP-1");
  //
  //   final picker = ImagePicker();
  //
  //   debugPrint("STEP-2");
  //
  //   final image = await picker.pickImage(
  //     source: ImageSource.gallery,
  //   );
  //
  //   debugPrint("STEP-3");
  //
  //   if (image == null) {
  //     debugPrint("IMAGE NULL");
  //     return;
  //   }
  //
  //   debugPrint("IMAGE PATH = ${image.path}");
  //
  // }

}

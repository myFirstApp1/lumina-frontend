import '../../data/models/user_profile_model.dart';

abstract class ProfileRepository {
  Future<UserProfileModel> getUserProfile(String userId);
  Future<UserProfileModel> updateProfile(String userId, UserProfileModel profile);
}

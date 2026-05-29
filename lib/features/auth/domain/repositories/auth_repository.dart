import '../../data/models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel> login(String email, String password);
  Future<void> register(String name, String email, String password, String phone);
  Future<void> verifyOtp(String email, String otp);
  Future<UserModel> getCurrentUser();
  Future<void> logout();
}

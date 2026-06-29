import '../../data/models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel> login(String email, String password);
  Future<String> register(String username, String email, String password);
  Future<void> verifyOtp(String txnId, String code);
  Future<bool> hasValidSession();
  Future<void> logout();
}

import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/secure_storage/secure_storage_manager.dart';
import '../../data/models/user_model.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final DioClient _client;
  final SecureStorageManager _secureStorage;

  AuthRepositoryImpl({
    required DioClient client,
    required SecureStorageManager secureStorage,
  })  : _client = client,
        _secureStorage = secureStorage;

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await _client.dio.post(
        '/api/v1/auth/login',
        data: {'email': email, 'password': password},
      );

      final data = response.data;
      final accessToken = data['accessToken'] as String?;
      final refreshToken = data['refreshToken'] as String?;
      final userJson = data['user'] as Map<String, dynamic>?;

      if (accessToken != null) {
        await _secureStorage.saveAccessToken(accessToken);
      }
      if (refreshToken != null) {
        await _secureStorage.saveRefreshToken(refreshToken);
      }

      if (userJson != null) {
        return UserModel.fromJson(userJson);
      } else {
        throw ServerException('Invalid login payload');
      }
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data['message'] as String? ?? 'Login failed',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<void> register(String name, String email, String password, String phone) async {
    try {
      await _client.dio.post(
        '/api/v1/auth/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
          'phone': phone,
        },
      );
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data['message'] as String? ?? 'Registration failed',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<void> verifyOtp(String email, String otp) async {
    try {
      final response = await _client.dio.post(
        '/api/v1/auth/verify-otp',
        data: {'email': email, 'otp': otp},
      );
      final data = response.data;
      final accessToken = data['accessToken'] as String?;
      final refreshToken = data['refreshToken'] as String?;

      if (accessToken != null) {
        await _secureStorage.saveAccessToken(accessToken);
      }
      if (refreshToken != null) {
        await _secureStorage.saveRefreshToken(refreshToken);
      }
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data['message'] as String? ?? 'OTP validation failed',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _client.dio.get('/api/v1/user/profile');
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data['message'] as String? ?? 'Failed to get user profile',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _client.dio.post('/api/v1/auth/logout');
    } catch (_) {
      // Best effort remote logout
    } finally {
      await _secureStorage.deleteTokens();
    }
  }
}

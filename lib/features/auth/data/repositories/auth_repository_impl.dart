import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/secure_storage/secure_storage_manager.dart';
import 'package:flutter/foundation.dart';
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
  Future<UserModel> login(String username, String password) async {
    try {
      // Step 1: Login via Auth Service
      final response = await _client.dio.post(
        '/api/auth/login',
        data: {
          'username': username,
          'password': password,
        },
      );

      debugPrint("LOGIN RESPONSE:");
      debugPrint(response.data.toString());

      final loginData = response.data['data']?['data'];

      if (loginData == null) {
        throw ServerException('Login response data missing');
      }

      final token = loginData['token'] as String?;
      final userId = loginData['userId'] as String?;

      if (token == null) {
        throw ServerException('Token missing in login response');
      }

      if (userId == null) {
        throw ServerException('UserId missing in login response');
      }

      // Step 2: Save JWT
      await _secureStorage.saveAuthUserId(userId);

      debugPrint("TOKEN SAVED");
      debugPrint("USER ID: $userId");

      // Step 3: Fetch Profile from User Service
      final profileResponse = await _client.dio.get(
        'http://192.168.1.6:8082/api/users/$userId',
      );

      debugPrint("PROFILE RESPONSE:");
      debugPrint(profileResponse.data.toString());

      await _secureStorage.saveProfileId(
        profileResponse.data['id'],
      );
      // Step 4: Return actual user profile
      final profile =
      profileResponse.data as Map<String, dynamic>;

      return UserModel(
        authUserId: userId,
        profileId: profileResponse.data['id'],

        name: profileResponse.data['name'] ?? '',
        email: profileResponse.data['email'] ?? '',
        phone: profileResponse.data['phone'],

        emergencyContacts: [],
      );
    } on DioException catch (e) {
      debugPrint("LOGIN ERROR: ${e.response?.data}");

      throw ServerException(
        e.response?.data?['message'] as String? ?? 'Login failed',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<String> register(
      String username,
      String email,
      String password,
      ) async {
    try {
      debugPrint("======================================");
      debugPrint("REGISTER API CALLED");
      debugPrint("BASE URL: ${_client.dio.options.baseUrl}");
      debugPrint("ENDPOINT: /api/auth/register");

      debugPrint("REQUEST PAYLOAD:");
      debugPrint("username = $username");
      debugPrint("email    = $email");
      debugPrint("password = $password");

      final response = await _client.dio.post(
        '/api/auth/register',
        data: {
          'username': username,
          'email': email,
          'password': password,
        },
      );

      debugPrint("======================================");
      debugPrint("REGISTER SUCCESS");
      debugPrint("STATUS CODE: ${response.statusCode}");
      debugPrint("FULL RESPONSE:");
      debugPrint(response.data.toString());

      final txnId = response.data?['data']?['data']?['txnId'];

      debugPrint("TXN ID: $txnId");

      if (txnId == null) {
        debugPrint("ERROR: txnId is NULL");
        throw Exception('txnId missing from register response');
      }

      return txnId.toString();

    } on DioException catch (e, stack) {

      debugPrint("======================================");
      debugPrint("REGISTER FAILED");

      debugPrint("ERROR TYPE:");
      debugPrint(e.type.toString());

      debugPrint("ERROR MESSAGE:");
      debugPrint(e.message);

      debugPrint("REQUEST URL:");
      debugPrint(
        "${_client.dio.options.baseUrl}/api/auth/register",
      );

      debugPrint("STATUS CODE:");
      debugPrint(
        e.response?.statusCode?.toString() ?? "NULL",
      );

      debugPrint("RESPONSE BODY:");
      debugPrint(
        e.response?.data.toString() ?? "NULL",
      );

      debugPrint("HEADERS:");
      debugPrint(
        e.response?.headers.toString() ?? "NULL",
      );

      debugPrint("STACK TRACE:");
      debugPrint(stack.toString());

      debugPrint("======================================");

      rethrow;
    } catch (e, stack) {

      debugPrint("======================================");
      debugPrint("NON-DIO ERROR");
      debugPrint(e.toString());
      debugPrint(stack.toString());
      debugPrint("======================================");

      rethrow;
    }
  }

  @override
  Future<void> verifyOtp(String txnId, String code) async {
    try {
      await _client.dio.post(
        '/api/auth/otp/verify',
        data: {'txnId': txnId, 'code': code},
      );
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

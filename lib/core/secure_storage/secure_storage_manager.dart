import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageManager {
  final FlutterSecureStorage _storage;

  SecureStorageManager({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage(
          aOptions: AndroidOptions(encryptedSharedPreferences: true),
        );

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _dbKey = 'db_encryption_key';

  // permanent storage while Restart phone
  static const String _trackingUserId = 'tracking_user_id';
  static const String _trackingId = 'tracking_id';
  static const String _trackingToken = 'tracking_token';

  // App start flow
  static const String _onboardingCompleted =
      'onboarding_completed';

  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _accessTokenKey, value: token);
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  Future<void> deleteTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }

  Future<void> saveDatabaseKey(String key) async {
    await _storage.write(key: _dbKey, value: key);
  }

  Future<String?> getDatabaseKey() async {
    return await _storage.read(key: _dbKey);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  Future<void> saveUserId(String id) async {
    await _storage.write(
      key: 'auth_user_id',
      value: id,
    );
  }

  Future<String?> getUserId() async {
    return await _storage.read(
      key: 'auth_user_id',
    );
  }

  Future<void> saveProfileId(String id) async {
    await _storage.write(
      key: 'profile_id',
      value: id,
    );
  }

  Future<String?> getProfileId() async {
    return await _storage.read(
      key: 'profile_id',
    );
  }

  Future<void> saveTrackingSession({
    required String userId,
    required String trackingId,
    required String accessToken,
  }) async {

    await _storage.write(
      key: _trackingUserId,
      value: userId,
    );

    await _storage.write(
      key: _trackingId,
      value: trackingId,
    );

    await _storage.write(
      key: _trackingToken,
      value: accessToken,
    );
  }

  /// permanent storage while Restart phone
  Future<String?> getTrackingUserId() async {
    return await _storage.read(key: _trackingUserId);
  }

  Future<String?> getTrackingId() async {
    return await _storage.read(key: _trackingId);
  }

  Future<String?> getTrackingAccessToken() async {
    return await _storage.read(key: _trackingToken);
  }

  Future<void> clearTrackingSession() async {

    await _storage.delete(key: _trackingUserId);
    await _storage.delete(key: _trackingId);
    await _storage.delete(key: _trackingToken);

  }

  Future<void> clearUserSession() async {

    await deleteTokens();

    await clearTrackingSession();

    await _storage.delete(key: 'auth_user_id');

    await _storage.delete(key: 'profile_id');

  }

  /// app start flow
  Future<void> setOnboardingCompleted() async {

    await _storage.write(
      key: _onboardingCompleted,
      value: "true",
    );

  }

  Future<bool> isOnboardingCompleted() async {

    return await _storage.read(
      key: _onboardingCompleted,
    ) ==
        "true";

  }
}

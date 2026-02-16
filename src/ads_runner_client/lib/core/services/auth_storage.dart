import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStorage {
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _idTokenKey = 'id_token';

  final FlutterSecureStorage _storage;

  AuthStorage({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  Future<void> saveAccessToken(String token) =>
      _storage.write(key: _accessTokenKey, value: token);

  Future<String?> getAccessToken() =>
      _storage.read(key: _accessTokenKey);

  Future<void> saveRefreshToken(String token) =>
      _storage.write(key: _refreshTokenKey, value: token);

  Future<String?> getRefreshToken() =>
      _storage.read(key: _refreshTokenKey);

  Future<void> saveIdToken(String token) =>
      _storage.write(key: _idTokenKey, value: token);

  Future<String?> getIdToken() =>
      _storage.read(key: _idTokenKey);

  Future<void> clearTokens() => _storage.deleteAll();

  Future<bool> get hasValidToken async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}

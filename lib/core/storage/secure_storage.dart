import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> writeToken(String token) async {
    await _storage.write(
        key: 'auth_token', value: token, aOptions: _getAndroidOptions());
  }

  Future<String?> readToken() async {
    return await _storage.read(
        key: 'auth_token', aOptions: _getAndroidOptions());
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: 'auth_token', aOptions: _getAndroidOptions());
  }

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
}

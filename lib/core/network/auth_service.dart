import 'package:dio/dio.dart';
import 'package:klontong_flutter_app/core/storage/secure_storage.dart';
import 'package:klontong_flutter_app/core/utils/app_constants.dart';
import 'package:klontong_flutter_app/data/models/user/user_model.dart';

import '../utils/logger.dart';
import '../utils/error_handler.dart';

class AuthService {
  final Dio _dio;
  final SecureStorage _secureStorage;

  AuthService(this._dio, this._secureStorage);

  Future<bool> login(String email, String password) async {
    try {
      Logger.logMessage("Attempting login for $email...");

      final response = await _dio.get('${AppConstants.baseUrl}/auth');

      if (response.statusCode == 200) {
        List<dynamic> usersJson = response.data;
        List<UserModel> users =
            usersJson.map((user) => UserModel.fromJson(user)).toList();

        UserModel? user = users.firstWhere(
          (user) =>
              user.email.trim() == email.trim() &&
              user.password.trim() == password.trim(),
          orElse: () => UserModel(id: '', email: '', password: ''),
        );

        if (user.id == '') {
          Logger.logMessage("Login failed, user not found.");
          return false;
        } else {
          await _secureStorage.writeToken(user.id.toString());
          Logger.logMessage("Login successful, token saved.");
          return true;
        }
      }

      return false;
    } catch (e) {
      Logger.logMessage("Login error: $e", level: LogLevel.error);
      throw Exception(ErrorHandler.handleApiError(e));
    }
  }

  Future<bool> register(String email, String password) async {
    try {
      Logger.logMessage("Attempting register for $email...");

      final response = await _dio.post(
        '${AppConstants.baseUrl}/auth',
        data: {"email": email, "password": password},
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        Logger.logMessage("Register successful.");
        return true;
      }

      return false;
    } catch (e) {
      Logger.logMessage("Register error: $e", level: LogLevel.error);
      throw Exception(ErrorHandler.handleApiError(e));
    }
  }

  Future<void> logout() async {
    Logger.logMessage("Logging out...");
    await _secureStorage.deleteToken();
  }

  Future<bool> isAuthenticated() async {
    String? token = await _secureStorage.readToken();
    return token != null;
  }
}

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:klontong_flutter_app/core/network/auth_service.dart';
import 'package:klontong_flutter_app/core/storage/secure_storage.dart';
import 'package:klontong_flutter_app/core/utils/app_constants.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_service_test.mocks.dart';

@GenerateMocks([Dio, SecureStorage])
void main() {
  late MockDio mockDio;
  late MockSecureStorage mockSecureStorage;
  late AuthService authService;

  setUp(() {
    mockDio = MockDio();
    mockSecureStorage = MockSecureStorage();
    authService = AuthService(mockDio, mockSecureStorage);
  });

  group('AuthService', () {
    test('login should return true when credentials are correct', () async {
      const email = 'test@example.com';
      const password = 'password123';
      final mockResponse = Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 200,
        data: [
          {'id': '1', 'email': email, 'password': password}
        ],
      );

      when(mockDio.get('${AppConstants.baseUrl}/auth'))
          .thenAnswer((_) async => mockResponse);
      when(mockSecureStorage.writeToken('1')).thenAnswer((_) async {});

      final result = await authService.login(email, password);

      expect(result, true);
      verify(mockSecureStorage.writeToken('1')).called(1);
    });

    test('login should return false when credentials are incorrect', () async {
      const email = 'test@example.com';
      const password = 'wrongpassword';
      final mockResponse = Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 200,
        data: [
          {'id': '1', 'email': 'test@example.com', 'password': 'password123'}
        ],
      );

      when(mockDio.get('${AppConstants.baseUrl}/auth'))
          .thenAnswer((_) async => mockResponse);

      final result = await authService.login(email, password);

      expect(result, false);
      verifyNever(mockSecureStorage.writeToken(any));
    });

    test('register should return true when registration is successful',
        () async {
      const email = 'newuser@example.com';
      const password = 'password123';
      final mockResponse = Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 201,
      );

      when(mockDio.post('${AppConstants.baseUrl}/auth',
              data: {'email': email, 'password': password}))
          .thenAnswer((_) async => mockResponse);

      final result = await authService.register(email, password);

      expect(result, true);
    });

    test('register should return false when registration fails', () async {
      const email = 'newuser@example.com';
      const password = 'password123';
      final mockResponse = Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 400,
      );

      when(mockDio.post('${AppConstants.baseUrl}/auth',
              data: {'email': email, 'password': password}))
          .thenAnswer((_) async => mockResponse);

      final result = await authService.register(email, password);

      expect(result, false);
    });

    test('logout should delete token from secure storage', () async {
      when(mockSecureStorage.deleteToken()).thenAnswer((_) async {});

      await authService.logout();

      verify(mockSecureStorage.deleteToken()).called(1);
    });

    test('isAuthenticated should return true when token exists', () async {
      when(mockSecureStorage.readToken()).thenAnswer((_) async => 'token');

      final result = await authService.isAuthenticated();

      expect(result, true);
    });

    test('isAuthenticated should return false when token does not exist',
        () async {
      when(mockSecureStorage.readToken()).thenAnswer((_) async => null);

      final result = await authService.isAuthenticated();

      expect(result, false);
    });
  });
}

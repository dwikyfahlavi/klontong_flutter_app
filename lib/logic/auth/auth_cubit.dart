import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klontong_flutter_app/core/network/auth_service.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService authService;

  AuthCubit(this.authService) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      bool success = await authService.login(email, password);
      if (success) {
        emit(Authenticated());
      } else {
        emit(Unauthenticated());
      }
    } catch (_) {
      emit(Unauthenticated());
    }
  }

  Future<void> register(String email, String password) async {
    emit(AuthLoading());
    try {
      bool success = await authService.register(email, password);
      if (success) {
        emit(Authenticated());
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> logout() async {
    await authService.logout();
    emit(AuthLogout());
  }

  Future<void> checkAuthStatus() async {
    try {
      bool isAuthenticated = await authService.isAuthenticated();
      emit(isAuthenticated ? Authenticated() : Unauthenticated());
    } catch (e) {
      emit(AuthError("Failed to check authentication status."));
    }
  }
}

// ignore_for_file: use_build_context_synchronously

import 'package:elegan/blocs/auth/auth_event.dart';
import 'package:elegan/blocs/auth/auth_state.dart';
import 'package:elegan/services/auth_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;
  AuthBloc(this._authService) : super(AuthInitial()) {
    on<LoginEvent>(_login);
    on<RegisterEvent>(_register);
    on<CheckLoginEvent>(_checkingLogin);
    on<LogOutEvent>(_logout);
  }

  Future<void> _login(LoginEvent event, Emitter<AuthState> emit) async {
    emit(LoadingAuthState());
    try {
      final response = await _authService.login(
        context: event.context,
        email: event.email,
        password: event.password,
      );
      if (response.isSuccess == true) {
        emit(SuccessAuthState(user: response.user!));
      } else {
        emit(FailureAuthState(error: response.error ?? 'Login failed'));
      }
    } catch (e) {
      emit(FailureAuthState(error: e.toString()));
    }
  }

  Future<void> _register(RegisterEvent event, Emitter<AuthState> emit) async {
    try {} catch (e) {
      emit(FailureAuthState(error: e.toString()));
    }
  }

  Future<void> _checkingLogin(
      CheckLoginEvent event, Emitter<AuthState> emit) async {
    try {} catch (e) {
      emit(FailureAuthState(error: e.toString()));
    }
  }

  Future<void> _logout(LogOutEvent event, Emitter<AuthState> emit) async {
    try {} catch (e) {
      emit(FailureAuthState(error: e.toString()));
    }
  }
}

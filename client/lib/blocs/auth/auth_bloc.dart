// ignore_for_file: use_build_context_synchronously

import 'package:elegan/blocs/auth/auth_event.dart';
import 'package:elegan/blocs/auth/auth_state.dart';
import 'package:elegan/core/common/bottom_bar.dart';
import 'package:elegan/services/auth_services.dart';
import 'package:flutter/material.dart';
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
    emit(AuthLoading());
    try {
      final response = await _authService.login(
        context: event.context,
        email: event.email,
        password: event.password,
      );

      if (response.isSuccess == true) {
        if (response.user != null) {
          await _authService.saveUserData(response.token!, response.user!);
          emit(Authenticated(user: response.user!));
          Navigator.pushReplacementNamed(
              event.context, BottomBarScreen.routeName);
        } else {
          emit(NotAuthenticated(
              errorMessage: response.error ?? 'Login Failed!'));
        }
      } else {
        emit(AuthError(error: 'User data is null'));
      }
    } catch (e) {
      emit(AuthError(error: e.toString()));
    }
  }

  Future<void> _register(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final res = await _authService.register(
        context: event.context,
        firstName: event.firstName,
        lastName: event.lastName,
        email: event.email,
        password: event.password,
        mobile: event.mobile,
      );
      if (res.isSuccess == true) {
        if (res.user != null) {
          emit(Authenticated(user: res.user!));
          Navigator.pushReplacementNamed(
              event.context, BottomBarScreen.routeName);
        } else {
          emit(NotAuthenticated(errorMessage: res.error ?? 'Register Failed'));
        }
      } else {
        emit(AuthError(error: 'User data is null'));
      }
    } catch (e) {
      emit(AuthError(error: e.toString()));
    }
  }

  Future<void> _checkingLogin(
      CheckLoginEvent event, Emitter<AuthState> emit) async {
    try {} catch (e) {
      emit(AuthError(error: e.toString()));
    }
  }

  Future<void> _logout(LogOutEvent event, Emitter<AuthState> emit) async {
    try {
      //await _authService.logout(event.context);
      //emit(LogOutState());
      // Navigator.pushReplacementNamed(event.context, LoginScreen.routeName);
    } catch (e) {
      emit(AuthError(error: e.toString()));
    }
  }
}

// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:elegan/blocs/auth/auth_event.dart';
import 'package:elegan/blocs/auth/auth_state.dart';
import 'package:elegan/core/common/bottom_bar.dart';
import 'package:elegan/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../models/user.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;
  AuthBloc(this._authService) : super(AuthInitial()) {
    on<LoginEvent>(_login);
    on<RegisterEvent>(_register);
    on<CheckLoginEvent>(_checkingLogin);
    on<LogoutEvent>(_logout);
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
          await _authService.saveUserData(
              response.token!, response.refreshToken!, response.user!);
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
    emit(AuthLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('x-auth-token');

      if (token != null && token.isNotEmpty) {
        // Eğer token varsa, kullanıcının verilerini SharedPreferences'dan yükle
        final userJson = prefs.getString('user-data');
        if (userJson != null) {
          final user = User.fromJson(jsonDecode(userJson));
          emit(Authenticated(user: user));
        } else {
          emit(NotAuthenticated(errorMessage: 'User data not found'));
        }

        // Token yenileme işlemini gerçekleştir
        final response = await _authService.refreshToken(event.context);
        if (response.isSuccess == true) {
          emit(Authenticated(user: response.user!));
        } else {
          emit(LogoutState());
        }
      } else {
        emit(NotAuthenticated(errorMessage: 'User is not logged in'));
      }
    } catch (e) {
      emit(AuthError(error: e.toString()));
    }
  }

  Future<void> _logout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _authService.logout(event.context);
      emit(LogoutState());
      Navigator.pushReplacementNamed(event.context, LoginScreen.routeName);
    } catch (e) {
      emit(AuthError(error: e.toString()));
    }
  }
}

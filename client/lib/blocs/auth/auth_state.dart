// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:elegan/models/user.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class LogOutState extends AuthState {}

class Authenticated extends AuthState {
  final User user;

  Authenticated({required this.user});
}

class NotAuthenticated extends AuthState {
  final String? errorMessage;

  NotAuthenticated({this.errorMessage});
}

class AuthError extends AuthState {
  final String error;

  AuthError({required this.error});
}

class RefreshTokenLoadingState extends AuthState {}

class RefreshTokenSuccessState extends AuthState {
  final String newToken;

  RefreshTokenSuccessState({required this.newToken});
}

class RefreshTokenFailureState extends AuthState {
  final String error;

  RefreshTokenFailureState({required this.error});
}

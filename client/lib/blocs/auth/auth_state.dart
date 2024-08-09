// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:elegan/models/user.dart';

abstract class AuthState {
  AuthState();
}

class AuthInitial extends AuthState {}

class LogOutState extends AuthState {}

class SuccessAuthState extends AuthState {
  final User user;

  SuccessAuthState({required this.user});
}

class LoadingAuthState extends AuthState {}

class FailureAuthState extends AuthState {
  final String error;

  FailureAuthState({required this.error});
}

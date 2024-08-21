import 'package:flutter/material.dart';

abstract class AuthEvent {}

class RegisterEvent extends AuthEvent {
  final BuildContext context;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String mobile;

  RegisterEvent({
    required this.mobile,
    required this.context,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  });
}

class LoginEvent extends AuthEvent {
  final BuildContext context;
  final String email;
  final String password;

  LoginEvent({
    required this.context,
    required this.email,
    required this.password,
  });
}

class LogOutEvent extends AuthEvent {}

class CheckLoginEvent extends AuthEvent {}

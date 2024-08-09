import 'package:elegan/models/user.dart';

class AuthResponse {
  final User? user;
  final String? error;

  AuthResponse.success({required this.user}) : error = null;
  AuthResponse.failure({required this.error}) : user = null;

  bool get isSuccess => error == null;
}

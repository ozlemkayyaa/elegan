import 'package:elegan/models/user.dart';

class AuthResponse {
  final String? refreshToken;
  final String? token;
  final User? user;
  final String? error;

  AuthResponse.success({this.user, this.token, this.refreshToken})
      : error = null;

  AuthResponse.failure({required this.error})
      : user = null,
        refreshToken = null,
        token = null;

  bool get isSuccess => error == null;
}

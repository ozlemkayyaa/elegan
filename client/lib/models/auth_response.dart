import 'package:elegan/models/user.dart';

class AuthResponse {
  final String? token;
  final User? user;
  final String? error;

  AuthResponse.success({required this.user, this.token}) : error = null;
  AuthResponse.failure({required this.error})
      : user = null,
        token = null;

  bool get isSuccess => error == null;
}

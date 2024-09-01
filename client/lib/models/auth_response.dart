import 'package:elegan/models/user.dart';

class AuthResponse {
  final String? refreshToken;
  final String? token;
  final User? user;
  final String? error;

  // Başarılı durum için yapılandırıcı
  AuthResponse.success({this.user, this.token, this.refreshToken})
      : error = null;

  // Başarısız durum için yapılandırıcı
  AuthResponse.failure({required this.error})
      : user = null,
        refreshToken = null,
        token = null;

  // Başarı durumunu kontrol eden getter
  bool get isSuccess => error == null;
}

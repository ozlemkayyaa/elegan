import 'dart:convert';
import 'package:elegan/core/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:elegan/models/auth_response.dart';

Future<AuthResponse> httpErrorHandle({
  required http.Response response,
  required BuildContext context,
  required Future<AuthResponse> Function() onSuccess,
}) async {
  switch (response.statusCode) {
    case 200:
      // Başarılı durumda, onSuccess fonksiyonu çağrılıyor.
      return await onSuccess();
    case 400:
      final message = jsonDecode(response.body)['msg'];
      showSnackBar(context, message);
      return AuthResponse.failure(error: message);
    case 500:
      final message = jsonDecode(response.body)['error'];
      showSnackBar(context, message);
      return AuthResponse.failure(error: message);
    default:
      final message = response.body;
      showSnackBar(context, message);
      return AuthResponse.failure(error: message);
  }
}

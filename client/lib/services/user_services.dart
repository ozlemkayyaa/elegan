// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:elegan/core/env/env.dart';
import 'package:elegan/core/error/error.dart';
import 'package:elegan/core/helpers/helper_functions.dart';
import 'package:elegan/models/auth_response.dart';
import 'package:elegan/models/user.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserService {
  Future<User> getUserData(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        prefs.setString('x-auth-token', '');
        throw Exception('No token found.');
      }

      var tokenResponse = await http.post(
        Uri.parse('${Environment.baseUrl}user/getUser'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token
        },
      );

      var authResponse = await httpErrorHandle(
        response: tokenResponse,
        context: context,
        onSuccess: () async {
          // Kullanıcı verilerini almak için HTTP GET isteği gönder.
          http.Response userRes = await http.get(
            Uri.parse(Environment.baseUrl),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'x-auth-token': token
            },
          );

          // Kullanıcı verilerini JSON'dan ayrıştır ve User nesnesine çevir.
          return AuthResponse.success(
            user: User.fromJson(jsonDecode(userRes.body)),
          );
        },
      );

      // AuthResponse'tan User nesnesini al ve geri döndür.
      return authResponse.user!;
    } catch (e) {
      showSnackBar(context, 'An error occurred. Please try again.');
      throw Exception('Failed to load user data.');
    }
  }
}

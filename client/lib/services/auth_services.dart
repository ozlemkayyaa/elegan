// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:async';
import 'dart:convert';
import 'package:elegan/core/error/error.dart';
import 'package:elegan/core/helpers/helper_functions.dart';
import 'package:elegan/models/auth_response.dart';
import 'package:elegan/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:elegan/core/env/env.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Login
  Future<AuthResponse> login({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('${Environment.baseUrl}user/login'),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      return httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          final Map<String, dynamic> responseJson = jsonDecode(res.body);
          final String? token = responseJson['token'];
          if (token == null) {
            showSnackBar(context, 'Token is null');
            return AuthResponse.failure(error: 'Token is null');
          }
          print('Token: $token'); // Debug print
          print('Response body: ${res.body}'); // Debug print

          // Ensure that 'user' exists and is of the correct type
          final Map<String, dynamic> userJson = responseJson;

          if (userJson.isEmpty) {
            showSnackBar(context, 'User data is null');
            return AuthResponse.failure(error: 'User data is null');
          }

          await prefs.setString('x-auth-token', token);
          // final User user = User.fromJson(responseJson['user']);
          // await prefs.setString('user-data', jsonEncode(user.toJson()));
          final User user = User.fromMap(userJson);

          // Başarılı durumda, AuthResponse.success döndürülüyor.
          return AuthResponse.success(user: user);
        },
      );
    } catch (e) {
      showSnackBar(context, 'An error occurred. Please try again.');
      return AuthResponse.failure(
          error: 'An error occurred. Please try again.');
    }
  }

  // Register
  Future<AuthResponse> register({
    required BuildContext context,
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String mobile,
  }) async {
    try {
      User user = User(
        id: '',
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        mobile: mobile,
        role: 'user',
        address: [],
        wishlist: [],
        isBlocked: false,
        cart: [],
      );

      http.Response res = await http.post(
        Uri.parse('${Environment.baseUrl}user/register'),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      return httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          showSnackBar(
              context, 'Account created! Login with the same credentials!');
          return AuthResponse.success(user: user);
        },
      );
    } catch (e) {
      showSnackBar(context, 'An error occurred. Please try again.');
      return AuthResponse.failure(
          error: 'An error occurred. Please try again.');
    }
  }

  // Logout
  // Future<void> logout(BuildContext context) async {
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     await prefs.remove('x-auth-token');
  //     // Çıkış yapıldıktan sonra gerekli yönlendirmeleri yapabilirsin.
  //   } catch (e) {
  //     showSnackBar(context, 'An error occurred during logout.');
  //   }
  // }
}

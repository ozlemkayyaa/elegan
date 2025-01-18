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
        Uri.parse('${Environment.baseUrl}/login'),
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
          final Map<String, dynamic> responseJson = jsonDecode(res.body);
          final String? token = responseJson['token'];
          final String refToken = responseJson['refreshtoken'];
          if (token == null || token.isEmpty) {
            showSnackBar(context, 'Token is null');
            return AuthResponse.failure(error: 'Token is null');
          }

          // Ensure that 'user' exists and is of the correct type
          final Map<String, dynamic> userJson = responseJson;

          if (userJson.isEmpty) {
            showSnackBar(context, 'User data is null');
            return AuthResponse.failure(error: 'User data is null');
          }

          final User user = User.fromMap(userJson);
          await saveUserData(token, refToken, user);
          return AuthResponse.success(user: user, token: token);
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
        Uri.parse('${Environment.baseUrl}/register'),
        body: jsonEncode({
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'password': password,
          'mobile': mobile,
        }),
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
  Future<AuthResponse> logout(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString('refreshToken');

      final res = await http.get(
        Uri.parse('${Environment.baseUrl}/logout'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Cookie': 'refreshToken=$refreshToken',
        },
      );

      print("Logout response status: ${res.statusCode}");
      print("Logout response body: ${res.body}");

      if (res.statusCode == 204) {
        // Remove user data from SharedPreferences
        await prefs.remove('x-auth-token');
        await prefs.remove('user-data');
        await prefs.remove('refreshToken');
        showSnackBar(context, 'Logout Successful!');
        return AuthResponse.success(
            user: null); // User is null because they are logged out
      } else {
        return AuthResponse.failure(error: 'Failed to log out');
      }
    } catch (e) {
      showSnackBar(context, 'An error occurred during logout.');
      return AuthResponse.failure(error: e.toString());
    }
  }

  // Save User Data
  Future<void> saveUserData(String token, String refToken, User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('x-auth-token', token);
    await prefs.setString('refreshToken', refToken);
    await prefs.setString('user-data', jsonEncode(user.toJson()));
  }

  // Refresh Token
  Future<AuthResponse> refreshToken(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString('x-auth-token');

      print("Gönderilen Yenileme Token'ı: $refreshToken");

      final res = await http.get(
        Uri.parse('${Environment.baseUrl}/refresh-token'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Cookie': 'refreshToken=$refreshToken',
        },
      );

      print("REFRESH TOKEN RESPONSE: ${res.statusCode}");
      print("REFRESH TOKEN BODY: ${res.body}");

      if (res.statusCode == 200) {
        final Map<String, dynamic> responseJson = jsonDecode(res.body);
        final String? newToken = responseJson['accessToken'];
        if (newToken != null) {
          await prefs.setString('x-auth-token', newToken);
          showSnackBar(context, 'Token refreshed successfully');
          return AuthResponse.success(token: newToken);
        } else {
          throw Exception('New token is null');
        }
      } else if (res.statusCode == 500) {
        showSnackBar(
            context, 'Sunucu hatası: Yenileme token geçersiz veya bulunamadı.');
        return AuthResponse.failure(
            error: 'Yenileme token geçersiz veya bulunamadı.');
      } else {
        return AuthResponse.failure(error: 'Token yenileme işlemi başarısız');
      }
    } catch (e) {
      showSnackBar(context, 'An error occurred while refreshing the token.');
      return AuthResponse.failure(error: e.toString());
    }
  }
}

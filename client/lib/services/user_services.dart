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

      if (token == null || token.isEmpty) {
        prefs.setString('x-auth-token', '');
        showSnackBar(context, 'No token found.');
        throw Exception('No token found.');
      }

      http.Response res = await http.get(
        Uri.parse('${Environment.baseUrl}user/getUser'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token
        },
      );

      AuthResponse authResponse = await httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          User user = User.fromJson(jsonDecode(res.body));
          await saveUserData(user);
          return AuthResponse.success(user: user, token: token);
        },
      );
      if (authResponse.isSuccess && authResponse.user != null) {
        return authResponse.user!;
      } else {
        throw Exception('Failed to load user data.');
      }
    } catch (e) {
      showSnackBar(context, 'An error occurred. Please try again.');
      throw Exception('Failed to load user data.');
    }
  }

  Future<void> saveUserData(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user-data', jsonEncode(user.toJson()));
  }
}

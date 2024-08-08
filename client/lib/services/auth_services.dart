// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:elegan/core/env/env.dart';
import 'package:elegan/core/error/error.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  void login({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    final currentContext = context;

    try {
      http.Response res = await http.post(
        Uri.parse('${Environment.urlApi}/login'),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () async {
            SharedPreferences pref = await SharedPreferences.getInstance();
          });
    } catch (e) {
      print(e);
    }
  }
}

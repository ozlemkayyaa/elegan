import 'package:elegan/core/common/bottom_bar.dart';
import 'package:elegan/features/auth/screens/auth_screen.dart';
import 'package:elegan/features/auth/screens/forgot_password.dart';
import 'package:elegan/features/auth/screens/login_screen.dart';
import 'package:elegan/features/auth/screens/register_screen.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AuthScreen(),
      );
    case LoginScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const LoginScreen(),
      );
    case RegisterScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const RegisterScreen(),
      );
    case ForgotPassword.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const ForgotPassword(),
      );
    case BottomBarScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const BottomBarScreen(),
      );

    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
          body: Center(
            child: Text("Screen does not exist!"),
          ),
        ),
      );
  }
}

import 'package:elegan/core/routers/router.dart';
import 'package:elegan/core/theme/theme.dart';
import 'package:elegan/features/auth/screens/auth_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Auth Servisi ekler

  @override
  void initState() {
    super.initState();
    // Auth servisten kullanıcı verilerini al
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elegan',
      theme: EleganAppTheme.eleganAppTheme,
      home: const AuthScreen(),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings) => (generateRoute(settings)),
    );
  }
}

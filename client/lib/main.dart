import 'package:elegan/blocs/auth/auth_bloc.dart';
import 'package:elegan/core/routers/router.dart';
import 'package:elegan/core/theme/theme.dart';
import 'package:elegan/features/auth/screens/login_screen.dart';
import 'package:elegan/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(AuthService()),
        ),
      ],
      child: MaterialApp(
        title: 'Elegan',
        theme: EleganAppTheme.eleganAppTheme,
        home: const LoginScreen(),
        debugShowCheckedModeBanner: false,
        onGenerateRoute: (settings) => (generateRoute(settings)),
      ),
    );
  }
}

import 'package:elegan/blocs/auth/auth_bloc.dart';
import 'package:elegan/blocs/auth/auth_event.dart';
import 'package:elegan/blocs/user/user_bloc.dart';
import 'package:elegan/blocs/user/user_state.dart';
import 'package:elegan/core/routers/router.dart';
import 'package:elegan/core/theme/theme.dart';
import 'package:elegan/features/auth/screens/login_screen.dart';
import 'package:elegan/services/auth_services.dart';
import 'package:elegan/services/user_services.dart';
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
  final UserService userService = UserService();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => AuthBloc(AuthService())
              ..add(CheckLoginEvent(context: context))),
        BlocProvider(
          create: (context) => UserBloc(UserService()),
        ),
      ],
      child: MaterialApp(
        title: 'Elegan',
        theme: EleganAppTheme.eleganAppTheme,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: (settings) => (generateRoute(settings)),
        home: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserSuccessState) {
              return const LoginScreen();
            } else if (state is UserErrorState) {
              return Center(child: Text('Error: ${state.error}'));
            } else {
              return const LoginScreen();
            }
          },
        ),
      ),
    );
  }
}

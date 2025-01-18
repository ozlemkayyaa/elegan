// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'package:elegan/blocs/auth/auth_bloc.dart';
import 'package:elegan/blocs/auth/auth_event.dart';
import 'package:elegan/blocs/auth/auth_state.dart';
import 'package:elegan/core/common/bottom_bar.dart';
import 'package:elegan/core/common/custom_button.dart';
import 'package:elegan/core/common/custom_textfield.dart';
import 'package:elegan/core/constants/sizes.dart';
import 'package:elegan/core/constants/texts.dart';
import 'package:elegan/core/helpers/helper_functions.dart';
import 'package:elegan/features/auth/screens/forgot_password.dart';
import 'package:elegan/features/auth/screens/register_screen.dart';
import 'package:elegan/features/auth/widgets/top_message.dart';
import 'package:elegan/features/auth/widgets/sub_message.dart';
import 'package:elegan/services/auth_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "/login";
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService authService = AuthService();

  final _loginFormKey = GlobalKey<FormState>();

  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.clear();
    _emailController.dispose();
    _passwordController.clear();
    _passwordController.dispose();
    super.dispose();
  }

  void loginUser(BuildContext context) {
    if (_loginFormKey.currentState!.validate()) {
      BlocProvider.of<AuthBloc>(context).add(
        LoginEvent(
          context: context,
          email: _emailController.text,
          password: _passwordController.text,
        ),
      );
    }
  }

  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            showSnackBar(context, state.error);
          } else if (state is Authenticated) {
            Navigator.pushReplacementNamed(context, BottomBarScreen.routeName,
                arguments: "Login Successful!");
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(EleganSizes.margin),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),
                  const TopMessage(
                    welcomeText: EleganTexts.welcome,
                    messageText: EleganTexts.loginMessage,
                  ),
                  const SizedBox(height: 30),
                  loginForm(context),
                  const SizedBox(height: 330),
                  const SubMessage(
                    account: EleganTexts.dontAccount,
                    buttonText: EleganTexts.register,
                    routeName: RegisterScreen.routeName,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Form loginForm(BuildContext context) {
    return Form(
      key: _loginFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Email address field
          CustomTextField(
            controller: _emailController,
            hintText: EleganTexts.email,
            prefixIcon: const Icon(CupertinoIcons.mail),
          ),
          const SizedBox(height: 20),

          // Password field
          CustomTextField(
            controller: _passwordController,
            hintText: EleganTexts.password,
            obscureText: _obscurePassword,
            prefixIcon: const Icon(CupertinoIcons.lock),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
          ),
          const SizedBox(height: 10),

          // Forgot Password
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, ForgotPassword.routeName);
              },
              child: Text(
                EleganTexts.forgotPassword,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Login Button
          CustomButton(
            text: EleganTexts.loginButton,
            onPressed: () {
              if (_loginFormKey.currentState!.validate()) {
                loginUser(context);
              }
            },
          ),
        ],
      ),
    );
  }
}

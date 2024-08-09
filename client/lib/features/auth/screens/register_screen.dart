// ignore_for_file: library_private_types_in_public_api

import 'package:elegan/blocs/auth/auth_bloc.dart';
import 'package:elegan/blocs/auth/auth_state.dart';
import 'package:elegan/core/common/bottom_bar.dart';
import 'package:elegan/core/common/custom_button.dart';
import 'package:elegan/core/common/custom_textfield.dart';
import 'package:elegan/core/constants/sizes.dart';
import 'package:elegan/core/constants/texts.dart';
import 'package:elegan/features/auth/screens/login_screen.dart';
import 'package:elegan/features/auth/widgets/sub_message.dart';
import 'package:elegan/features/auth/widgets/top_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = "/register";
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _registerFormKey = GlobalKey<FormState>();

  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _mobileController;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _mobileController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.clear();
    _emailController.dispose();
    _passwordController.clear();
    _passwordController.dispose();
    _confirmPasswordController.clear();
    _confirmPasswordController.dispose();
    _firstNameController.clear();
    _firstNameController.dispose();
    _lastNameController.clear();
    _lastNameController.dispose();
    _mobileController.clear();
    _mobileController.dispose();
    super.dispose();
  }

  void registerUser() {}

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is SuccessAuthState) {
            return const BottomBarScreen();
          } else {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(EleganSizes.margin),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 50),
                      const TopMessage(
                        welcomeText: EleganTexts.join,
                        messageText: EleganTexts.personalInfo,
                      ),
                      const SizedBox(height: 30),
                      registerForm(context),
                      const SizedBox(height: 150),
                      const SubMessage(
                        account: EleganTexts.account,
                        buttonText: EleganTexts.signin,
                        routeName: LoginScreen.routeName,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Form registerForm(BuildContext context) {
    return Form(
      key: _registerFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ad alanı
          Row(
            children: [
              SizedBox(
                width: 192,
                child: CustomTextField(
                  controller: _firstNameController,
                  hintText: EleganTexts.firstName,
                  prefixIcon: const Icon(CupertinoIcons.person),
                ),
              ),
              const SizedBox(width: 20),
              SizedBox(
                width: 192,
                child: CustomTextField(
                  controller: _lastNameController,
                  hintText: EleganTexts.lastName,
                  prefixIcon: const Icon(CupertinoIcons.person),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // E-posta alanı
          CustomTextField(
            controller: _emailController,
            hintText: EleganTexts.email,
            prefixIcon: const Icon(CupertinoIcons.mail),
          ),
          const SizedBox(height: 20),

          // Mobile
          CustomTextField(
            controller: _mobileController,
            hintText: EleganTexts.mobile,
            prefixIcon: const Icon(CupertinoIcons.phone),
          ),
          const SizedBox(height: 20),

          // Şifre alanı
          CustomTextField(
            controller: _passwordController,
            hintText: EleganTexts.password,
            obscureText: _obscurePassword,
            prefixIcon: const Icon(CupertinoIcons.lock),
            suffixIcon: IconButton(
              icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
          ),
          const SizedBox(height: 20),

          // ConfirmPassword alanı
          CustomTextField(
            controller: _confirmPasswordController,
            hintText: EleganTexts.confirmPassword,
            obscureText: _obscureConfirmPassword,
            prefixIcon: const Icon(CupertinoIcons.lock),
            suffixIcon: IconButton(
              icon: Icon(_obscureConfirmPassword
                  ? Icons.visibility
                  : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
            ),
          ),
          const SizedBox(height: 20),
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              EleganTexts.passwordMessage,
              textAlign: TextAlign.end,
            ),
          ),
          const SizedBox(height: 20),

          // Kayıt butonu
          CustomButton(
            text: EleganTexts.registerButton,
            onPressed: () {
              if (_registerFormKey.currentState!.validate()) {
                registerUser();
                Navigator.pushNamed(context, BottomBarScreen.routeName);
              }
            },
          ),
        ],
      ),
    );
  }
}

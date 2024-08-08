// ignore_for_file: library_private_types_in_public_api

import 'package:elegan/core/common/custom_button.dart';
import 'package:elegan/core/common/custom_textfield.dart';
import 'package:elegan/core/constants/colors.dart';
import 'package:elegan/core/constants/sizes.dart';
import 'package:elegan/core/constants/texts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum Auth {
  signin,
  signup,
  forgotPassword,
}

class AuthScreen extends StatefulWidget {
  static const String routeName = "/auth-screen";
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // Kullanıcı kayıt ve giriş durumunu tutan enum değişkeni
  Auth _auth = Auth.signin;

  final _signUpFormKey = GlobalKey<FormState>();
  final _signInFormKey = GlobalKey<FormState>();
  final _forgotPasswordKey = GlobalKey<FormState>();

  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  late final TextEditingController _nameController;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _nameController = TextEditingController();
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
    _nameController.clear();
    _nameController.dispose();
    super.dispose();
  }

  void signInUser() {}

  void signUpUser() {}

  void resetPasswordUser() {}

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EleganColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(EleganSizes.margin),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 80,
                ),
                // Login sayfasındaysa Welcome yazısı register sayfasındaysa Join yazısı gelir
                _auth == Auth.signin
                    ? Text(
                        EleganTexts.welcome,
                        style: Theme.of(context).textTheme.headlineLarge,
                      )
                    : _auth == Auth.signup
                        ? Text(
                            EleganTexts.join,
                            style: Theme.of(context).textTheme.headlineLarge,
                          )
                        : Text(
                            EleganTexts.resetPassword,
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                const SizedBox(height: 10),

                // Top Message
                _auth == Auth.signin
                    ? Text(
                        EleganTexts.loginMessage,
                        style: Theme.of(context).textTheme.titleSmall,
                      )
                    : _auth == Auth.signup
                        ? Text(
                            EleganTexts.personalInfo,
                            style: Theme.of(context).textTheme.titleSmall,
                          )
                        : Text(
                            EleganTexts.resetMessage,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                const SizedBox(height: 30),

                // Giriş sayfasındaysa signInForm Kayıt sayfasındaysa singUpForm gösterilir.
                if (_auth == Auth.signin)
                  signInForm(context)
                else if (_auth == Auth.signup)
                  singUpForm()
                else
                  forgotPasswordForm(),
                _auth == Auth.signin
                    ? const SizedBox(height: 330)
                    : const SizedBox(height: 180),

                // Bottom Message
                _auth == Auth.forgotPassword
                    ? Container()
                    : Container(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Alttaki mesaj ve buton Giriş ve Kayıt sayfasına göre değişir
                            Text(
                              _auth == Auth.signin
                                  ? EleganTexts.dontAccount
                                  : EleganTexts.account,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),

                            // Butona tıklanınca Auth değişkenin değeri değiştirilir
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _auth = _auth == Auth.signin
                                      ? Auth.signup
                                      : Auth.signin;
                                });
                              },
                              child: Text(
                                _auth == Auth.signin
                                    ? EleganTexts.register
                                    : EleganTexts.signin,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(color: EleganColors.red),
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

// Parolamı Unuttum Formu
  Form forgotPasswordForm() {
    return Form(
      key: _forgotPasswordKey,
      child: Column(
        children: [
          CustomTextField(
            controller: _emailController,
            hintText: EleganTexts.email,
            prefixIcon: const Icon(CupertinoIcons.mail),
          ),
          const SizedBox(height: 20),
          CustomButton(
              text: EleganTexts.sendResetLink,
              onPressed: () {
                if (_forgotPasswordKey.currentState!.validate()) {
                  resetPasswordUser();
                }
                setState(() {
                  _auth = Auth.signin;
                });
              }),
        ],
      ),
    );
  }

// Kayıt Olma Formu
  Form singUpForm() {
    return Form(
      key: _signUpFormKey,
      child: Column(
        children: [
          // Ad alanı
          CustomTextField(
            controller: _nameController,
            hintText: EleganTexts.name,
            prefixIcon: const Icon(CupertinoIcons.person),
          ),
          const SizedBox(height: 20),

          // E-posta alanı
          CustomTextField(
            controller: _emailController,
            hintText: EleganTexts.email,
            prefixIcon: const Icon(CupertinoIcons.mail),
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
              if (_signUpFormKey.currentState!.validate()) {
                signUpUser();
              }
            },
          ),
        ],
      ),
    );
  }

// Giriş Yapma Formu
  Form signInForm(BuildContext context) {
    return Form(
      key: _signInFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // E-posta alanı
          CustomTextField(
            controller: _emailController,
            hintText: EleganTexts.email,
            prefixIcon: const Icon(CupertinoIcons.mail),
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

          // Şifre unuttum butonu
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                setState(() {
                  _auth = Auth.forgotPassword;
                });
              },
              child: Text(
                EleganTexts.forgotPassword,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Giriş butonu
          CustomButton(
            text: EleganTexts.loginButton,
            onPressed: () {
              if (_signInFormKey.currentState!.validate()) {
                signInUser();
              }
            },
          ),
        ],
      ),
    );
  }
}

// ignore_for_file: library_private_types_in_public_api

import 'package:elegan/blocs/auth/auth_bloc.dart';
import 'package:elegan/blocs/auth/auth_state.dart';
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

class ForgotPassword extends StatefulWidget {
  static const String routeName = "/forgotPassword";
  const ForgotPassword({super.key});

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _forgotPasswordKey = GlobalKey<FormState>();

  late final TextEditingController _emailController;

  @override
  void initState() {
    _emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.clear();
    _emailController.dispose();
    super.dispose();
  }

  void resetPasswordUser() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is Authenticated) {
            return const LoginScreen();
          } else {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(EleganSizes.margin),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 80),
                      const TopMessage(
                        welcomeText: EleganTexts.resetPassword,
                        messageText: EleganTexts.resetMessage,
                      ),
                      const SizedBox(height: 30),
                      forgotPasswordForm(context),
                      const SizedBox(height: 330),
                      const SubMessage(
                        account: '',
                        buttonText: '',
                        routeName: '',
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

  Form forgotPasswordForm(BuildContext context) {
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
                  Navigator.pushNamed(context, LoginScreen.routeName);
                });
              }),
        ],
      ),
    );
  }
}

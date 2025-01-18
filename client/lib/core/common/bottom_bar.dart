// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:elegan/blocs/auth/auth_bloc.dart';
import 'package:elegan/blocs/auth/auth_event.dart';
import 'package:elegan/core/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomBarScreen extends StatefulWidget {
  static const String routeName = "/bottom-bar";
  const BottomBarScreen({super.key});

  @override
  _BottomBarScreenState createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  Future<void> _handleLogout(BuildContext context) async {
    // After the token refresh completes, add the LogoutEvent
    BlocProvider.of<AuthBloc>(context).add(LogoutEvent(context: context));

    // Add the RefreshTokenEvent first
    BlocProvider.of<AuthBloc>(context).add(CheckLoginEvent(context: context));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final message = ModalRoute.of(context)?.settings.arguments as String?;
    if (message != null && message.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showSnackBar(context, message);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Center(child: Text("Bottom Bar")),
          ElevatedButton(
              onPressed: () => _handleLogout(context),
              child: const Text("Logout!"))
        ],
      ),
    );
  }
}

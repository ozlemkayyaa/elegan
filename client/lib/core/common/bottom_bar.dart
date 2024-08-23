// ignore_for_file: library_private_types_in_public_api

import 'package:elegan/core/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class BottomBarScreen extends StatefulWidget {
  static const String routeName = "/bottom-bar";
  const BottomBarScreen({super.key});

  @override
  _BottomBarScreenState createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
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

  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Bottom Bar")),
    );
  }
}

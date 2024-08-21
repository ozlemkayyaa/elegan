// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class BottomBarScreen extends StatefulWidget {
  static const String routeName = "/bottom-bar";
  const BottomBarScreen({super.key});

  @override
  _BottomBarScreenState createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Bottom Bar")),
    );
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class TopMessage extends StatelessWidget {
  final String welcomeText;
  final String messageText;
  const TopMessage({
    super.key,
    required this.welcomeText,
    required this.messageText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          welcomeText,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 10),
        Text(
          messageText,
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ],
    );
  }
}

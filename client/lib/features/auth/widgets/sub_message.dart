// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:elegan/core/constants/colors.dart';

class SubMessage extends StatelessWidget {
  final String account;
  final String buttonText;
  final String routeName;
  const SubMessage({
    super.key,
    required this.account,
    required this.buttonText,
    required this.routeName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            account,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, routeName);
            },
            child: Text(
              buttonText,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: EleganColors.red),
            ),
          ),
        ],
      ),
    );
  }
}

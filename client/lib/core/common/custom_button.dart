import 'package:elegan/core/constants/colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final Color? textColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = EleganColors.darkGrey,
    this.textColor = Colors.white,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: widget.color,
          minimumSize: const Size(double.infinity, 50)),
      onPressed: widget.onPressed,
      child: Text(
        widget.text,
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(color: widget.textColor),
      ),
    );
  }
}

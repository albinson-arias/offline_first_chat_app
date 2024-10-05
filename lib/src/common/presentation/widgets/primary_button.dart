import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.title,
    required this.onTap,
    this.backgroundColor = Colors.blue,
    this.foregroundColor = Colors.white,
    this.width = double.infinity,
    super.key,
  });
  final String title;
  final Color backgroundColor;
  final Color foregroundColor;
  final double width;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
      ),
      child: Text(
        title,
      ),
    );
  }
}

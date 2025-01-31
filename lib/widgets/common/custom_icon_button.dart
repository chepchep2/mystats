import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final Color? backgroundColor;
  final Color? textColor;
  final double height;

  const CustomIconButton({
    super.key,
    this.onPressed,
    required this.icon,
    this.backgroundColor,
    this.textColor,
    this.height = 40,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: height,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: IconButton(
          padding: EdgeInsets.zero,
          onPressed: onPressed,
          icon: Icon(
            icon,
            color: textColor ?? (onPressed == null ? Colors.grey : null),
          ),
        ),
      ),
    );
  }
}

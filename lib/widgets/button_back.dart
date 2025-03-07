import 'package:flutter/material.dart';
import 'dart:math' as math;

class ButtonBack extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const ButtonBack({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(60),
        ),
      ),
      onPressed: onPressed,
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            transform: GradientRotation(80.12 * math.pi / 180),
            colors: const [
              Color(0xFF2253F6),
              Color(0xFF9DB4FF),
            ],
          ),
          borderRadius: BorderRadius.circular(60),
        ),
        child: Container(
          alignment: Alignment.center,
          width: 218,
          height: 62,
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              height: 1.4,
              color: Color(0xFFF2F5F7),
            ),
          ),
        ),
      ),
    );
  }
}

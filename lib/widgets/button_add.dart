import 'package:flutter/material.dart';

class ButtonAdd extends StatelessWidget {
  final VoidCallback onPressed;

  const ButtonAdd({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2253F6),
            Color(0xFF9DB4FF),
          ],
        ),
      ),
      child: FloatingActionButton(
        backgroundColor: Colors.transparent,
        elevation: 0,
        onPressed: onPressed,
        child: const Icon(
          Icons.add,
          color: Color(0xFFF2F5F7),
        ),
      ),
    );
  }
}

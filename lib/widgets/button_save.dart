import 'package:flutter/material.dart';

class ButtonSave extends StatelessWidget {
  final VoidCallback onPressed;

  const ButtonSave({
    super.key,
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
            colors: [
              Color(0xFF2253F6),
              Color(0xFF9DB4FF),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight
          ),
          borderRadius: BorderRadius.circular(60),
        ),
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(20),
          width: double.infinity,
          child: Text(
            'Сохранить',
            style: TextStyle(
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

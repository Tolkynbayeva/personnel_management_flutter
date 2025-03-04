import 'package:flutter/material.dart';

class Empty extends StatelessWidget {
  final String description;
  final VoidCallback? onPressed;

  const Empty({
    super.key,
    required this.description,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/empty.png'),
              const SizedBox(height: 24),
              Text(
                'Тут пока пусто',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  height: 1.1,
                  color: Color(0xFF252525),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: 219,
                child: Text(
                  description,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.4,
                    color: Color(0xFF818181),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          right: 4,
          child: Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF2253F6), Color(0xFF9DB4FF)],
              ),
            ),
            child: FloatingActionButton(
              backgroundColor: Colors.transparent,
              elevation: 0,
              onPressed: onPressed,
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        )
      ],
    );
  }
}

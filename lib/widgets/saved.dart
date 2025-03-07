import 'package:flutter/material.dart';

import 'package:personnel_management_flutter/widgets/button_back.dart';

class Saved extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const Saved({
    super.key,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/saved.png'),
          const SizedBox(height: 24),
          Text(
            'Сохранено!',
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
              'Параметры успешно сохранены.',
              style: const TextStyle(
                fontSize: 16,
                height: 1.4,
                color: Color(0xFF818181),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 31),
          ButtonBack(
            title: 'К сотрудникам',
            onPressed: onPressed,
          )
        ],
      ),
    );
  }
}

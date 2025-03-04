import 'package:flutter/material.dart';
import 'package:personnel_management_flutter/widgets/empty.dart';

class FinanceScreen extends StatelessWidget {
  const FinanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 16),
      child: Empty(
        description: 'Добавьте данные о финансовых операциях.',
      ),
    );
  }
}

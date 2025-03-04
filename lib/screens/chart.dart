import 'package:flutter/material.dart';
import 'package:personnel_management_flutter/widgets/empty.dart';

class ChartScreen extends StatelessWidget {
  const ChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 16),
      child: Empty(description: 'Добавьте график сотрудников.'),
    );
  }
}

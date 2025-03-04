import 'package:flutter/material.dart';
import 'package:personnel_management_flutter/widgets/empty.dart';

class EmployeesScreen extends StatelessWidget {
  const EmployeesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 32,
        horizontal: 16,
      ),
      child: Empty(
        description:
            'Добавьте сотрудников, чтобы обеспечить более удобный учет.',
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:personnel_management_flutter/models/employee/employee.dart';
import 'package:personnel_management_flutter/screens/employee/employee_add.dart';
import 'package:personnel_management_flutter/screens/employee/employee_list.dart';
import 'package:personnel_management_flutter/widgets/empty.dart';

class EmployeesScreen extends StatelessWidget {
  const EmployeesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<Employee>>(
      valueListenable: Hive.box<Employee>('employees').listenable(),
      builder: (context, box, _) {
        if (box.isEmpty) {
          return Empty(
            description:
                'Добавьте сотрудников, чтобы обеспечить более удобный учет.',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const EmployeeAddScreen(),
                ),
              );
            },
          );
        } else {
          return const EmployeeListScreen();
        }
      },
    );
  }
}

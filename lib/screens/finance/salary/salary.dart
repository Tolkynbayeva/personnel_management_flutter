import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:personnel_management_flutter/models/employee/employee.dart';
import 'package:personnel_management_flutter/screens/finance/salary/salary_list.dart';

class SalaryScreen extends StatelessWidget {
  const SalaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<Employee>>(
      valueListenable: Hive.box<Employee>('employees').listenable(),
      builder: (context, box, _) {
        if (box.isEmpty) {
          return Center(
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
                    'Данных о зарплатах пока нет.',
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
          );
        } else {
          return SalaryListScreen();
        }
      },
    );
  }
}

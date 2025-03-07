import 'package:flutter/material.dart';
import 'package:personnel_management_flutter/models/employee.dart';
import 'package:personnel_management_flutter/widgets/button_save.dart';

class EmployeeEditScreen extends StatefulWidget {
  final Employee employee;

  const EmployeeEditScreen({
    super.key,
    required this.employee,
  });

  @override
  State<EmployeeEditScreen> createState() => _EmployeeEditScreenState();
}

class _EmployeeEditScreenState extends State<EmployeeEditScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Редактировать данные',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 17,
            height: 1.3,
            color: Color(0xFF252525),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          vertical: 24,
          horizontal: 16,
        ),
        child: Column(
          children: [
            ButtonSave(onPressed: () {}),
          ],
        ),
      ),
    );
  }
}

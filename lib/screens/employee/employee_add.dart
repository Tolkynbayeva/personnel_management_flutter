import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:personnel_management_flutter/models/employee.dart';
import 'package:personnel_management_flutter/screens/employee/employee_save.dart';
import 'package:personnel_management_flutter/widgets/button_save.dart';
import 'package:personnel_management_flutter/widgets/text_field.dart';

class EmployeeAddScreen extends StatefulWidget {
  const EmployeeAddScreen({super.key});

  @override
  State<EmployeeAddScreen> createState() => _EmployeeAddScreenState();
}

class _EmployeeAddScreenState extends State<EmployeeAddScreen> {
  final _formKey = GlobalKey<FormState>();

  final _fullName = TextEditingController();
  final _position = TextEditingController();
  final _salary = TextEditingController();
  final _phone = TextEditingController();
  final _comment = TextEditingController();

  DateTime? _hireDate;

  void _saveEmployee() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final employee = Employee(
        fullName: _fullName.text.trim(),
        position: _position.text.trim(),
        salary: double.tryParse(_salary.text) ?? 0,
        phone: _phone.text.trim(),
        hireDate: _hireDate!,
        comment: _comment.text.trim(),
      );

      final box = Hive.box<Employee>('employees');
      box.add(employee);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => EmployeeSavedScreen()),
      );
    }
  }

  @override
  void dispose() {
    _fullName.dispose();
    _position.dispose();
    _salary.dispose();
    _phone.dispose();
    _comment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Добавить сотрудника',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 17,
            height: 1.3,
            color: Color(0xFF252525),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              FullNameField(controller: _fullName),
              PositionField(controller: _position),
              SizedBox(height: 24),
              ButtonSave(onPressed: _saveEmployee),
            ],
          ),
        ),
      ),
    );
  }
}

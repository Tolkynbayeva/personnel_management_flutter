import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:personnel_management_flutter/models/employee/employee.dart';
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
  final _hireDate = TextEditingController();
  DateTime? _hireDateValue;

  final phoneMask = MaskTextInputFormatter(
    mask: '+# (###) ###-##-##',
    filter: {"#": RegExp(r'\d')},
  );

  final dateMask = MaskTextInputFormatter(
    mask: '##.##.####',
    filter: {"#": RegExp(r'\d')},
  );

  void _saveEmployee() {
    if (_formKey.currentState!.validate()) {
      final rawDate = _hireDate.text.trim();
      if (rawDate.isNotEmpty && rawDate.length == 10) {
        try {
          _hireDateValue = DateFormat('dd.MM.yyyy').parse(rawDate);
        } catch (e) {
          //
        }
      }

      if (_hireDateValue != null) {
        final employee = Employee(
          fullName: toTitleCase(_fullName.text.trim()),
          position: _position.text.trim(),
          salary:
              double.tryParse(_salary.text.replaceAll(RegExp(r'\D'), '')) ?? 0,
          phone: _phone.text.trim(),
          hireDate: _hireDateValue!,
          comment: _comment.text.trim(),
        );
        Hive.box<Employee>('employees').add(employee);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const EmployeeSavedScreen()),
        );
      }
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

  String toTitleCase(String text) {
    return text.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
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
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      ErrorTextFormField(
                        controller: _fullName,
                        hintText: 'ФИО',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ошибка';
                          }
                          return null;
                        },
                      ),
                      ErrorTextFormField(
                        controller: _position,
                        hintText: 'Должность',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ошибка';
                          }
                          return null;
                        },
                      ),
                      ErrorTextFormField(
                        controller: _salary,
                        hintText: 'Заработная плата',
                        keyboardType: TextInputType.number,
                        inputFormatters: [SalaryFormatter()],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ошибка';
                          }
                          return null;
                        },
                      ),
                      ErrorTextFormField(
                        controller: _phone,
                        hintText: 'Номер телефона',
                        keyboardType: TextInputType.phone,
                        inputFormatters: [phoneMask],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ошибка';
                          }
                          return null;
                        },
                      ),
                      ErrorTextFormField(
                        controller: _hireDate,
                        hintText: 'Дата оформления',
                        keyboardType: TextInputType.number,
                        inputFormatters: [dateMask],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ошибка';
                          }
                          return null;
                        },
                      ),
                      ErrorTextFormField(
                        controller: _comment,
                        hintText: 'Комментарий',
                        maxLines: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ButtonSave(onPressed: _saveEmployee),
          ],
        ),
      ),
    );
  }
}

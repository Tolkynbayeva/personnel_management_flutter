import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:personnel_management_flutter/models/employee/employee.dart';
import 'package:personnel_management_flutter/widgets/button_save.dart';
import 'package:personnel_management_flutter/screens/employee/employee_save.dart';
import 'package:personnel_management_flutter/widgets/text_field.dart';

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
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _fullName;
  late final TextEditingController _position;
  late final TextEditingController _salary;
  late final TextEditingController _phone;
  late final TextEditingController _comment;
  late final TextEditingController _hireDate;
  DateTime? _hireDateValue;

  final phoneMask = MaskTextInputFormatter(
    mask: '+# (###) ###-##-##',
    filter: {"#": RegExp(r'\d')},
  );

  final dateMask = MaskTextInputFormatter(
    mask: '##.##.####',
    filter: {"#": RegExp(r'\d')},
  );

  @override
  void initState() {
    super.initState();
    _fullName = TextEditingController(text: widget.employee.fullName);
    _position = TextEditingController(text: widget.employee.position);
    final salaryFormatted =
        NumberFormat.decimalPattern('ru_RU').format(widget.employee.salary);
    _salary = TextEditingController(text: '$salaryFormatted ₽');
    _phone = TextEditingController(text: widget.employee.phone);
    _hireDateValue = widget.employee.hireDate;
    final dateStr = DateFormat('dd.MM.yyyy').format(_hireDateValue!);
    _hireDate = TextEditingController(text: dateStr);
    _comment = TextEditingController(text: widget.employee.comment);
  }

  @override
  void dispose() {
    _fullName.dispose();
    _position.dispose();
    _salary.dispose();
    _phone.dispose();
    _hireDate.dispose();
    _comment.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      try {
        _hireDateValue = DateFormat('dd.MM.yyyy').parse(_hireDate.text.trim());
      } catch (e) {
        //
      }
      widget.employee
        ..fullName = _fullName.text.trim()
        ..position = _position.text.trim()
        ..salary = double.tryParse(
              _salary.text.replaceAll(RegExp(r'[^\d]'), ''),
            ) ??
            0
        ..phone = _phone.text.trim()
        ..hireDate = _hireDateValue ?? widget.employee.hireDate
        ..comment = _comment.text.trim();
      widget.employee.save();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const EmployeeSavedScreen()),
      );
    }
  }

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
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          children: [
            Expanded(
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
                ],
              ),
            ),
            ButtonSave(onPressed: _saveChanges),
          ],
        ),
      ),
    );
  }
}

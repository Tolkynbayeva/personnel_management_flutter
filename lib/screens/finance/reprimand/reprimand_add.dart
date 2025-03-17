import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:personnel_management_flutter/models/employee/employee.dart';
import 'package:personnel_management_flutter/models/finance/reprimand.dart';
import 'package:personnel_management_flutter/screens/finance/reprimand/reprimand_save.dart';
import 'package:personnel_management_flutter/widgets/button_save.dart';
import 'package:personnel_management_flutter/widgets/date_picker_card.dart';
import 'package:personnel_management_flutter/widgets/employee_autocomplete.dart';
import 'package:personnel_management_flutter/widgets/text_field.dart';

class ReprimandAddScreen extends StatefulWidget {
  const ReprimandAddScreen({super.key});

  @override
  State<ReprimandAddScreen> createState() => _ReprimandAddScreenState();
}

class _ReprimandAddScreenState extends State<ReprimandAddScreen> {
  final _formKey = GlobalKey<FormState>();

  final _employeeController = TextEditingController();
  final _infoController = TextEditingController();
  late final TextEditingController _rebukeController;
  final _sumController = TextEditingController();
  final _commentController = TextEditingController();

  DateTime? _rebukeDate;

  late Box<Employee> _employeeBox;
  late Box<Reprimand> _reprimandBox;

  @override
  void initState() {
    super.initState();
    _employeeBox = Hive.box<Employee>('employees');
    _reprimandBox = Hive.box<Reprimand>('reprimands');
    _rebukeController = TextEditingController(text: 'Выговор');
  }

  @override
  void dispose() {
    _employeeController.dispose();
    _infoController.dispose();
    _rebukeController.dispose();
    _sumController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _saveReprimand() {
    if (_formKey.currentState!.validate() && _rebukeDate != null) {
      final String employeeName = _employeeController.text.trim();
      final String info = _infoController.text.trim();
      final String infoCapitalized =
          info.isNotEmpty ? info[0].toUpperCase() + info.substring(1) : info;
      final String rebuke = _rebukeController.text.trim();
      final DateTime date = _rebukeDate!;
      final double sum = double.tryParse(
            _sumController.text.replaceAll(RegExp(r'[^\d]'), ''),
          ) ??
          0;
      final String comment = _commentController.text.trim();

      final newReprimand = Reprimand(
        employeeName: employeeName,
        info: infoCapitalized,
        rebuke: rebuke,
        date: date,
        sum: sum,
        comment: comment,
      );

      _reprimandBox.add(newReprimand);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ReprimandSaveScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Добавить выговор',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 17,
            height: 1.3,
            color: Color(0xFF252525),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      EmployeeTypeAheadField(
                        controller: _employeeController,
                        onSelected: (Employee selected) {
                          _employeeController.text = selected.fullName;
                        },
                      ),
                      SizedBox(height: 16),
                      ErrorTextFormField(
                        controller: _infoController,
                        hintText: 'Данные о выговоре',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ошибка';
                          }
                          return null;
                        },
                      ),
                      ErrorTextFormField(
                        controller: _rebukeController,
                        hintText: 'Выговор',
                        readOnly: true,
                      ),
                      DatePickerCard(
                        onDateSelected: (data) {
                          _rebukeDate = data;
                        },
                      ),
                      ErrorTextFormField(
                        controller: _sumController,
                        hintText: 'Сумма',
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
                        controller: _commentController,
                        hintText: 'Комментарий',
                        maxLines: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ButtonSave(onPressed: _saveReprimand)
          ],
        ),
      ),
    );
  }
}

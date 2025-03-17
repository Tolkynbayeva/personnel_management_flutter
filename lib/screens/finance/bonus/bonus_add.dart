import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:personnel_management_flutter/models/employee/employee.dart';
import 'package:personnel_management_flutter/models/finance/bonus.dart';
import 'package:personnel_management_flutter/screens/finance/bonus/bonus_save.dart';
import 'package:personnel_management_flutter/widgets/button_save.dart';
import 'package:personnel_management_flutter/widgets/date_picker_card.dart';
import 'package:personnel_management_flutter/widgets/employee_autocomplete.dart';
import 'package:personnel_management_flutter/widgets/text_field.dart';

class BonusAddScreen extends StatefulWidget {
  const BonusAddScreen({super.key});

  @override
  State<BonusAddScreen> createState() => _BonusAddScreenState();
}

class _BonusAddScreenState extends State<BonusAddScreen> {
  final _formKey = GlobalKey<FormState>();

  final _employeeController = TextEditingController();
  final _infoController = TextEditingController();
  late final TextEditingController _bonusController;
  final _sumController = TextEditingController();
  final _commentController = TextEditingController();

  DateTime? _bonusDate;

  late Box<Employee> _employeeBox;
  late Box<Bonus> _bonusBox;

  @override
  void initState() {
    super.initState();
    _employeeBox = Hive.box<Employee>('employees');
    _bonusBox = Hive.box<Bonus>('bonuses');
    _bonusController = TextEditingController(text: 'Премия');
  }

  @override
  void dispose() {
    super.dispose();
    _employeeController.dispose();
    _infoController.dispose();
    _bonusController.dispose();
    _sumController.dispose();
    _commentController.dispose();
  }

  void _saveBonus() {
    if (_formKey.currentState!.validate() && _bonusDate != null) {
      final String employeeName = _employeeController.text.trim();
      final String info = _infoController.text.trim();
      final String infoCapitalized =
          info.isNotEmpty ? info[0].toUpperCase() + info.substring(1) : info;
      final String bonus = _bonusController.text.trim();
      final DateTime date = _bonusDate!;
      final double sum = double.tryParse(
            _sumController.text.replaceAll(RegExp(r'[^\d]'), ''),
          ) ??
          0;
      final String comment = _commentController.text.trim();

      final newBonus = Bonus(
        employeeName: employeeName,
        info: infoCapitalized,
        bonus: bonus,
        date: date,
        sum: sum,
        comment: comment,
      );

      _bonusBox.add(newBonus);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => BonusSaveScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Добавить премию',
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
                        hintText: 'Данные о премии',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ошибка';
                          }
                          return null;
                        },
                      ),
                      ErrorTextFormField(
                        controller: _bonusController,
                        hintText: 'Премия',
                        readOnly: true,
                      ),
                      DatePickerCard(
                        onDateSelected: (data) {
                          _bonusDate = data;
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
            ButtonSave(onPressed: _saveBonus)
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personnel_management_flutter/models/employee/employee.dart';
import 'package:personnel_management_flutter/models/finance/bonus.dart';
import 'package:personnel_management_flutter/screens/finance/bonus/bonus_save.dart';
import 'package:personnel_management_flutter/widgets/button_save.dart';
import 'package:personnel_management_flutter/widgets/date_picker_card.dart';
import 'package:personnel_management_flutter/widgets/employee_autocomplete.dart';
import 'package:personnel_management_flutter/widgets/text_field.dart';

class BonusEditScreen extends StatefulWidget {
  final Bonus bonus;

  const BonusEditScreen({
    super.key,
    required this.bonus,
  });

  @override
  State<BonusEditScreen> createState() => _BonusEditScreenState();
}

class _BonusEditScreenState extends State<BonusEditScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _employeeController;
  late final TextEditingController _infoController;
  late final TextEditingController _bonusController;
  late final TextEditingController _sumController;
  late final TextEditingController _commentController;

  DateTime? _bonusDate;

  @override
  void initState() {
    super.initState();
    _employeeController =
        TextEditingController(text: widget.bonus.employeeName);
    _infoController = TextEditingController(text: widget.bonus.info);
    _bonusController = TextEditingController(text: 'Премия');
    _bonusDate = widget.bonus.date;
    final sumFormatted =
        NumberFormat.decimalPattern('ru_RU').format(widget.bonus.sum);
    _sumController = TextEditingController(text: '$sumFormatted ₽');
    _commentController = TextEditingController(text: widget.bonus.comment);
  }

  @override
  void dispose() {
    _employeeController.dispose();
    _infoController.dispose();
    _bonusController.dispose();
    _sumController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate() && _bonusDate != null) {
      final updatedReprimand = Bonus(
        employeeName: _employeeController.text.trim(),
        info: _infoController.text.trim(),
        bonus: _bonusController.text.trim(),
        date: _bonusDate!,
        sum: double.tryParse(
              _sumController.text.replaceAll(RegExp(r'[^\d]'), ''),
            ) ??
            0,
        comment: _commentController.text.trim(),
      );

      widget.bonus.box?.put(widget.bonus.key, updatedReprimand);

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
        title: const Text(
          'Редактировать премию',
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
                        initialDate: _bonusDate,
                        onDateSelected: (data) {
                          setState(
                            () {
                              _bonusDate = data;
                            },
                          );
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
            ButtonSave(onPressed: _saveChanges)
          ],
        ),
      ),
    );
  }
}

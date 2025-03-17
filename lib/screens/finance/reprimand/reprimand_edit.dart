import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personnel_management_flutter/models/employee/employee.dart';
import 'package:personnel_management_flutter/models/finance/reprimand.dart';
import 'package:personnel_management_flutter/screens/finance/reprimand/reprimand_save.dart';
import 'package:personnel_management_flutter/widgets/button_save.dart';
import 'package:personnel_management_flutter/widgets/date_picker_card.dart';
import 'package:personnel_management_flutter/widgets/employee_autocomplete.dart';
import 'package:personnel_management_flutter/widgets/text_field.dart';

class ReprimandEditScreen extends StatefulWidget {
  final Reprimand reprimand;

  const ReprimandEditScreen({
    super.key,
    required this.reprimand,
  });

  @override
  State<ReprimandEditScreen> createState() => _ReprimandEditScreenState();
}

class _ReprimandEditScreenState extends State<ReprimandEditScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _employeeController;
  late final TextEditingController _infoController;
  late final TextEditingController _rebukeController;
  late final TextEditingController _sumController;
  late final TextEditingController _commentController;

  DateTime? _rebukeDate;

  @override
  void initState() {
    super.initState();
    _employeeController =
        TextEditingController(text: widget.reprimand.employeeName);
    _infoController = TextEditingController(text: widget.reprimand.info);
    _rebukeController = TextEditingController(text: 'Выговор');
    _rebukeDate = widget.reprimand.date;
    final sumFormatted =
        NumberFormat.decimalPattern('ru_RU').format(widget.reprimand.sum);
    _sumController = TextEditingController(text: '$sumFormatted ₽');
    _commentController = TextEditingController(text: widget.reprimand.comment);
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

  void _saveChanges() {
    if (_formKey.currentState!.validate() && _rebukeDate != null) {
      final updatedReprimand = Reprimand(
        employeeName: _employeeController.text.trim(),
        info: _infoController.text.trim(),
        rebuke: _rebukeController.text.trim(),
        date: _rebukeDate!,
        sum: double.tryParse(
              _sumController.text.replaceAll(RegExp(r'[^\d]'), ''),
            ) ??
            0,
        comment: _commentController.text.trim(),
      );

      widget.reprimand.box?.put(widget.reprimand.key, updatedReprimand);

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
        title: const Text(
          'Редактировать выговор',
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
                      const SizedBox(height: 16),
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
                        initialDate: _rebukeDate,
                        onDateSelected: (data) {
                          setState(() {
                            _rebukeDate = data;
                          });
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

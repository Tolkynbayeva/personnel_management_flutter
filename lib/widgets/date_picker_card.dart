import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'custom_calendar_dialog.dart'; // <-- Импортируйте ваш диалог

class DatePickerCard extends StatefulWidget {
  final DateTime? initialDate;
  final void Function(DateTime) onDateSelected;

  const DatePickerCard({
    super.key,
    this.initialDate,
    required this.onDateSelected,
  });

  @override
  State<DatePickerCard> createState() => _DatePickerCardState();
}

class _DatePickerCardState extends State<DatePickerCard> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  Future<void> _pickDate() async {
    final result = await showDialog<DateTime>(
      context: context,
      builder: (context) => CustomCalendarDialog(
        initialDate: _selectedDate,
      ),
    );

    if (result != null) {
      setState(() {
        _selectedDate = result;
      });
      widget.onDateSelected(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayText = _selectedDate == null
        ? 'Дата'
        : DateFormat('dd.MM.yyyy').format(_selectedDate!);

    return InkWell(
      onTap: _pickDate,
      borderRadius: BorderRadius.circular(13),
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
        color: Color(0xFFF2F5F7),
          borderRadius: BorderRadius.circular(13),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D000000),
              offset: Offset(0, 2),
              blurRadius: 6,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                displayText,
                style: TextStyle(
                  fontSize: 16,
                  color: _selectedDate == null
                      ? const Color(0xFF818181)
                      : const Color(0xFF252525),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: Color(0xFF818181),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

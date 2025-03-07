import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'custom_calendar_dialog.dart';

class DatePickerFormField extends FormField<DateTime> {
  DatePickerFormField({
    super.key,
    DateTime? initialValue,
    required this.placeholder,
    DateTime? firstDate,
    DateTime? lastDate,
    FormFieldSetter<DateTime>? onSaved,
    FormFieldValidator<DateTime>? validator,
    ValueChanged<DateTime>? onChanged,
    AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
  })  : firstDate = firstDate ?? DateTime(2000),
        lastDate = lastDate ?? DateTime(2100),
        super(
          initialValue: initialValue,
          onSaved: onSaved,
          validator: validator,
          autovalidateMode: autovalidateMode,
          builder: (FormFieldState<DateTime> field) {
            final _DatePickerFormFieldState state =
                field as _DatePickerFormFieldState;
            final hasError = field.hasError;
            final errorText = field.errorText;
            final value = field.value;
            final text = (value == null)
                ? placeholder
                : DateFormat('dd.MM.yyyy').format(value);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: state._openCalendar,
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 4),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F5F7),
                      borderRadius: BorderRadius.circular(13),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          offset: const Offset(0, 2),
                          blurRadius: 6,
                        ),
                      ],
                      border: hasError
                          ? Border.all(color: Color(0xFFBA0000), width: 1)
                          : null,
                    ),
                    child: Text(
                      text,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.4,
                        color: (value == null)
                            ? const Color(0xFF818181)
                            : const Color(0xFF252525),
                      ),
                    ),
                  ),
                ),
                if (hasError)
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(
                      errorText ?? '',
                      style: const TextStyle(
                        color: Color(0xFFBA0000),
                        fontSize: 13,
                      ),
                    ),
                  ),
              ],
            );
          },
        );

  final String placeholder;
  final DateTime firstDate;
  final DateTime lastDate;

  @override
  FormFieldState<DateTime> createState() => _DatePickerFormFieldState();
}

class _DatePickerFormFieldState extends FormFieldState<DateTime> {
  @override
  DatePickerFormField get widget => super.widget as DatePickerFormField;

  Future<void> _openCalendar() async {
    final picked = await showDialog<DateTime>(
      context: context,
      builder: (_) => CustomCalendarDialog(
        initialDate: value,
        firstDate: widget.firstDate,
        lastDate: widget.lastDate,
      ),
    );
    if (picked != null) {
      didChange(picked);
    }
  }
}

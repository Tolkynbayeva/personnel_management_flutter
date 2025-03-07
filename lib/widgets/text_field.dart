import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:personnel_management_flutter/widgets/date_picker_field.dart';

class FullNameField extends StatefulWidget {
  final TextEditingController controller;
  const FullNameField({super.key, required this.controller});

  @override
  _FullNameFieldState createState() => _FullNameFieldState();
}

class _FullNameFieldState extends State<FullNameField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
          color: const Color(0xFFF2F5F7),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: TextFormField(
              controller: widget.controller,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.trim().isEmpty) return 'Введите ФИО';
                if (value.trim().split(RegExp(r'\s+')).length < 3) {
                  return 'Введите фамилию, имя и отчество';
                }
                return null;
              },
              onChanged: (value) {
                final cursorPosition = widget.controller.selection.baseOffset;
                final newValue = _capitalizeFullName(value);

                widget.controller.value = TextEditingValue(
                  text: newValue,
                  selection: TextSelection.collapsed(
                    offset: newValue.length < cursorPosition
                        ? newValue.length
                        : cursorPosition,
                  ),
                );
              },
              decoration: InputDecoration(
                fillColor: const Color(0xFFF2F5F7),
                filled: true,
                labelText: 'ФИО',
                floatingLabelBehavior: FloatingLabelBehavior.never,
                labelStyle: const TextStyle(
                  fontSize: 16,
                  height: 1.4,
                  color: Color(0xFF818181),
                ),
                contentPadding: const EdgeInsets.all(16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: BorderSide.none,
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide:
                      const BorderSide(color: Color(0xFFFF3B30), width: 1),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide:
                      const BorderSide(color: Color(0xFFFF3B30), width: 1),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Преобразует ФИО в формат "Первая Буква Заглавная"
  String _capitalizeFullName(String value) {
    return value
        .split(RegExp(r'(\s+)')) // Разделяем слова + пробелы
        .map((word) {
      if (word.trim().isEmpty) return word; // Сохраняем пробелы
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(''); // Собираем обратно с пробелами
  }
}

// 📌 Поле должности

class PositionField extends StatelessWidget {
  final TextEditingController controller;
  const PositionField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return _buildTextField(
      controller: controller,
      label: 'Должность',
      validator: (value) =>
          value == null || value.trim().isEmpty ? 'Введите должность' : null,
    );
  }
}

// 📌 Поле заработной платы (формат "100 000 ₽")
class SalaryField extends StatefulWidget {
  final TextEditingController controller;
  const SalaryField({super.key, required this.controller});

  @override
  _SalaryFieldState createState() => _SalaryFieldState();
}

class _SalaryFieldState extends State<SalaryField> {
  @override
  Widget build(BuildContext context) {
    return _buildTextField(
      controller: widget.controller,
      label: 'Заработная плата',
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      suffixText: '₽',
      validator: (value) =>
          value == null || value.trim().isEmpty ? 'Введите сумму' : null,
      onChanged: (value) {
        final formattedValue = _formatCurrency(value);
        widget.controller.value = TextEditingValue(
          text: formattedValue,
          selection: TextSelection.collapsed(offset: formattedValue.length),
        );
      },
    );
  }

  String _formatCurrency(String value) {
    if (value.isEmpty) return '';
    final formatter = NumberFormat("#,##0", "ru_RU");
    return formatter.format(int.tryParse(value.replaceAll(' ', '')) ?? 0);
  }
}

// 📌 Поле номера телефона (формат "+7 (909) 987-65-45")
class PhoneField extends StatefulWidget {
  final TextEditingController controller;
  const PhoneField({super.key, required this.controller});

  @override
  _PhoneFieldState createState() => _PhoneFieldState();
}

class _PhoneFieldState extends State<PhoneField> {
  @override
  Widget build(BuildContext context) {
    return _buildTextField(
      controller: widget.controller,
      label: 'Номер телефона',
      keyboardType: TextInputType.phone,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (value) =>
          value == null || value.trim().isEmpty ? 'Введите номер' : null,
      onChanged: (value) {
        final formattedValue = _formatPhoneNumber(value);
        widget.controller.value = TextEditingValue(
          text: formattedValue,
          selection: TextSelection.collapsed(offset: formattedValue.length),
        );
      },
    );
  }

  String _formatPhoneNumber(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return '';

    final buffer = StringBuffer();
    if (digits.length > 0) buffer.write('+7 ');
    if (digits.length > 1) buffer.write('(${digits.substring(1, 4)}) ');
    if (digits.length > 4) buffer.write('${digits.substring(4, 7)}-');
    if (digits.length > 7) buffer.write('${digits.substring(7, 9)}-');
    if (digits.length > 9) buffer.write(digits.substring(9, 11));

    return buffer.toString();
  }
}

// 📌 Поле даты регистрации (формат "24.01.2020")
class RegistrationDateField extends StatelessWidget {
  final DateTime? initialValue;
  final Function(DateTime?) onSaved;
  const RegistrationDateField(
      {super.key, required this.initialValue, required this.onSaved});

  @override
  Widget build(BuildContext context) {
    return DatePickerFormField(
      placeholder: 'Дата регистрации',
      initialValue: initialValue,
      validator: (value) => value == null ? 'Выберите дату' : null,
      onSaved: onSaved,
    );
  }
}

// 📌 Поле комментария (необязательное, высота 163)
class CommentField extends StatelessWidget {
  final TextEditingController controller;
  const CommentField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return _buildTextField(
      controller: controller,
      label: 'Комментарий',
      fieldHeight: 163,
      keyboardType: TextInputType.multiline,
      maxLines: null,
    );
  }
}

/// 📌 Универсальный метод для полей (в `Card`)
Widget _buildTextField({
  required TextEditingController controller,
  required String label,
  TextInputType? keyboardType,
  List<TextInputFormatter>? inputFormatters,
  double? fieldHeight,
  int? maxLines = 1,
  String? suffixText,
  Function(String)? onChanged,
  TextCapitalization textCapitalization = TextCapitalization.none,
  String? Function(String?)? validator, // ✅ Добавлен параметр `validator`
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
        color: const Color(0xFFF2F5F7),
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          onChanged: onChanged,
          textCapitalization: textCapitalization,
          validator: validator, // ✅ Теперь validator поддерживается
          decoration: InputDecoration(
            fillColor: const Color(0xFFF2F5F7),
            filled: true,
            labelText: label,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            labelStyle: const TextStyle(
                fontSize: 16, height: 1.4, color: Color(0xFF818181)),
            contentPadding: const EdgeInsets.all(16),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: BorderSide.none),
            suffixText: suffixText,
            suffixStyle:
                const TextStyle(fontSize: 16, color: Color(0xFF252525)),
          ),
        ),
      ),
      const SizedBox(height: 16),
    ],
  );
}

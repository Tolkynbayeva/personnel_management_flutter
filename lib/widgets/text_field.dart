import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class ErrorTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final int maxLines;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final bool readOnly;

  const ErrorTextFormField({
    super.key,
    this.controller,
    required this.hintText,
    this.maxLines = 1,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(13);

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            offset: Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        validator: validator,
        readOnly: readOnly,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFF2F5F7),
          hintText: hintText,
          hintStyle: const TextStyle(
            fontSize: 16,
            height: 1.4,
            color: Color(0xFF818181),
          ),
          contentPadding: const EdgeInsets.all(16),
          border: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide.none,
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: const BorderSide(color: Color(0xFFBA0000)),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: const BorderSide(color: Color(0xFFBA0000)),
          ),
        ),
      ),
    );
  }
}

class SalaryFormatter extends TextInputFormatter {
  final NumberFormat _numberFormat = NumberFormat('###,###', 'ru_RU');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    final number = int.parse(digitsOnly);
    final formattedNumber = _numberFormat.format(number);
    final newText = '$formattedNumber ₽';
    final cursorPos = newText.length - 2;
    final selection = TextSelection.collapsed(
      offset: cursorPos < 0 ? 0 : cursorPos,
    );

    return TextEditingValue(
      text: newText,
      selection: selection,
    );
  }
}

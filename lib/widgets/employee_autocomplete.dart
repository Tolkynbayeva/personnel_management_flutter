import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:personnel_management_flutter/models/employee/employee.dart';

class EmployeeTypeAheadField extends StatefulWidget {
  final TextEditingController controller;
  final void Function(Employee) onSelected;
  final String hintText;

  const EmployeeTypeAheadField({
    super.key,
    required this.controller,
    required this.onSelected,
    this.hintText = 'Сотрудник',
  });

  @override
  State<EmployeeTypeAheadField> createState() => _EmployeeTypeAheadFieldState();
}

class _EmployeeTypeAheadFieldState extends State<EmployeeTypeAheadField> {
  late final Box<Employee> _employeeBox;
  

  @override
  void initState() {
    super.initState();
    _employeeBox = Hive.box<Employee>('employees');
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<Employee>(
      suggestionsCallback: (String pattern) {
        final matches = _employeeBox.values.where((emp) =>
            emp.fullName.toLowerCase().contains(pattern.toLowerCase()));
        return matches.toList();
      },
      builder: (BuildContext context, TextEditingController textController,
          FocusNode focusNode) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0D000000),
                offset: Offset(0, 2),
                blurRadius: 6,
              ),
            ],
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: focusNode,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(16),
              filled: true,
              fillColor: const Color(0xFFF2F5F7),
              hintText: widget.hintText,
              hintStyle: const TextStyle(
                fontSize: 16,
                height: 1.4,
                color: Color(0xFF818181),
              ),
              suffixIcon: const Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: Color(0xFF818181),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: BorderSide.none,
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: const BorderSide(color: Color(0xFFBA0000)),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: const BorderSide(color: Color(0xFFBA0000)),
              ),
            ),
          ),
        );
      },
      itemBuilder: (BuildContext context, Employee suggestion) {
        return Padding(
          padding: const EdgeInsets.only(top: 8, right: 16, left: 16, bottom: 8),
          child: Column(
            children: [
              Row(
                children: [
                  SvgPicture.asset('assets/svg/person.fill.svg'),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      suggestion.fullName,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        height: 1.3,
                        color: Color(0xFF252525),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  SvgPicture.asset('assets/svg/ellipse.svg'),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      suggestion.position,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.6,
                        color: Color(0xFF818181),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
      onSelected: (Employee selected) {
        widget.controller.text = selected.fullName;
        widget.onSelected(selected);
      },
      decorationBuilder: (context, suggestionsBox) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            color: const Color(0xFFF2F5F7),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                offset: Offset(0, 2),
                blurRadius: 6,
              ),
            ],
          ),
          child: suggestionsBox,
        );
      },
    );
  }
}


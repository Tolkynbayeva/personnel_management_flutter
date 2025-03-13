import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:personnel_management_flutter/models/employee/employee.dart';

class EmployeeAutocompleteField extends StatefulWidget {
  final List<Employee> employees;
  final ValueChanged<Employee> onEmployeeSelected;
  final Employee? initialEmployee;

  const EmployeeAutocompleteField({
    super.key,
    required this.employees,
    required this.onEmployeeSelected,
    this.initialEmployee,
  });

  @override
  State<EmployeeAutocompleteField> createState() =>
      _EmployeeAutocompleteFieldState();
}

class _EmployeeAutocompleteFieldState extends State<EmployeeAutocompleteField> {
  @override
  Widget build(BuildContext context) {
    return Autocomplete<Employee>(
      displayStringForOption: (emp) => emp.fullName,
      optionsBuilder: (TextEditingValue textEditingValue) {
        final query = textEditingValue.text.toLowerCase();
        if (query.isEmpty) {
          return widget.employees;
        }
        return widget.employees.where((emp) {
          return emp.fullName.toLowerCase().contains(query) ||
              emp.position.toLowerCase().contains(query);
        });
      },
      onSelected: (emp) {
        widget.onEmployeeSelected(emp);
      },
      fieldViewBuilder: (
        BuildContext context,
        TextEditingController textController,
        FocusNode focusNode,
        VoidCallback onFieldSubmitted,
      ) {
        if (widget.initialEmployee != null) {
          textController.text = widget.initialEmployee!.fullName;
        }

        return Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
          color: const Color(0xFFF2F5F7),
          margin: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: textController,
                  focusNode: focusNode,
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    hintText: 'Сотрудник',
                    border: InputBorder.none,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: Icon(
                  Icons.chevron_right,
                  size: 30,
                  color: Color(0xFF818181),
                ),
              ),
            ],
          ),
        );
      },
      optionsViewBuilder: (
        BuildContext context,
        AutocompleteOnSelected<Employee> onSelected,
        Iterable<Employee> options,
      ) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            color: Color(0xFFF2F5F7),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width - 32,
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  final emp = options.elementAt(index);
                  return InkWell(
                    onTap: () => onSelected(emp),
                    child: Card(
                      color: Color(0xFFF2F5F7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset('assets/svg/person.fill.svg'),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    emp.fullName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
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
                                Text(
                                  emp.position,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF818181),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

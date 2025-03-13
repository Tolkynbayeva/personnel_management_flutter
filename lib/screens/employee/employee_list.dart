import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:personnel_management_flutter/models/employee/employee.dart';
import 'package:personnel_management_flutter/screens/employee/employee_add.dart';
import 'package:personnel_management_flutter/screens/employee/employee_details.dart';
import 'package:personnel_management_flutter/widgets/button_add.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  late Box<Employee> _employeeBox;

  @override
  void initState() {
    super.initState();
    _employeeBox = Hive.box<Employee>('employees');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!Hive.isBoxOpen('employees')) {
      return const Center(child: CircularProgressIndicator());
    }
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
          child: ListView.builder(
            itemCount: _employeeBox.length,
            itemBuilder: (context, index) {
              final employee = _employeeBox.getAt(index);
              if (employee == null) return const SizedBox();
              final salaryFormatted =
                  NumberFormat.decimalPattern('ru_RU').format(employee.salary);
                  
              return InkWell(
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EmployeeDetailsScreen(employee: employee),
                    ),
                  );

                  if (result == true) {
                    setState(() {});
                  }
                },
                child: Card(
                  margin: EdgeInsets.only(bottom: 16),
                  color: Color(0xFFF2F5F7),
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset('assets/svg/person.fill.svg'),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                employee.fullName,
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset('assets/svg/ellipse.svg'),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    employee.position,
                                    style: TextStyle(
                                      fontSize: 14,
                                      height: 1.6,
                                      color: Color(0xFF818181),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                SvgPicture.asset('assets/svg/ellipse.svg'),
                                SizedBox(width: 8),
                                Text(
                                  '$salaryFormatted ₽',
                                  style: TextStyle(
                                    fontSize: 14,
                                    height: 1.6,
                                    color: Color(0xFF818181),
                                  ),
                                ),
                              ],
                            )
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
        Positioned(
          bottom: 20,
          right: 20,
          child: ButtonAdd(onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const EmployeeAddScreen(),
              ),
            );
          }),
        )
      ],
    );
  }
}

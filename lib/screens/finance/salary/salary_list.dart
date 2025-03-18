import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:personnel_management_flutter/models/employee/employee.dart';
import 'package:personnel_management_flutter/models/finance/bonus.dart';
import 'package:personnel_management_flutter/models/finance/reprimand.dart';
import 'package:personnel_management_flutter/screens/finance/salary/salary_details.dart';

class SalaryListScreen extends StatefulWidget {
  const SalaryListScreen({super.key});

  @override
  State<SalaryListScreen> createState() => _SalaryListScreenState();
}

class _SalaryListScreenState extends State<SalaryListScreen> {
  late Box<Employee> _employeeBox;

  @override
  void initState() {
    super.initState();
    _employeeBox = Hive.box<Employee>('employees');
  }

  @override
  Widget build(BuildContext context) {
    if (!Hive.isBoxOpen('employees')) {
      return Center(child: CircularProgressIndicator());
    }
    return Padding(
      padding: EdgeInsets.only(top: 32),
      child: ListView.builder(
          itemCount: _employeeBox.length,
          itemBuilder: (context, index) {
            final employee = _employeeBox.getAt(index);
            if (employee == null) return SizedBox();

            final bonusBox = Hive.box<Bonus>('bonuses');
            final reprimandBox = Hive.box<Reprimand>('reprimands');
            final employeeBonusList = bonusBox.values
                .where((b) => b.employeeName == employee.fullName)
                .toList();
            final employeeFinesList = reprimandBox.values
                .where((r) => r.employeeName == employee.fullName)
                .toList();
            final bonusSum =
                employeeBonusList.isNotEmpty ? employeeBonusList.first.sum : 0;
            final finesSum =
                employeeFinesList.isNotEmpty ? employeeFinesList.first.sum : 0;
            final finalSalary = employee.salary + bonusSum - finesSum;
            final finalSalaryFormatted =
                NumberFormat.decimalPattern('ru_RU').format(finalSalary);

            return InkWell(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SalaryDetailsScreen(employee: employee),
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
                              Expanded(
                                child: Text(
                                  DateFormat("d MMMM y", "ru_RU")
                                      .format(employee.hireDate),
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
                                '$finalSalaryFormatted ₽',
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
          }),
    );
  }
}

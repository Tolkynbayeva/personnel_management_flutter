import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:personnel_management_flutter/models/employee.dart';
import 'package:personnel_management_flutter/screens/employee/employee_edit.dart';

class EmployeeDetailsScreen extends StatelessWidget {
  final Employee employee;
  const EmployeeDetailsScreen({
    super.key,
    required this.employee,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Данные сотрудника',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 17,
            height: 1.3,
            color: Color(0xFF252525),
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            color: Color(0xFFF2F5F7),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            icon: SvgPicture.asset('assets/svg/edit-icon.svg'),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    SvgPicture.asset('assets/svg/edit-icon.svg', width: 16),
                    const SizedBox(width: 18),
                    const Text(
                      'Редактировать',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.4,
                        color: Color(0xFF252525),
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    SvgPicture.asset('assets/svg/trash.svg'),
                    const SizedBox(width: 12),
                    const Text(
                      'Удалить',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.4,
                        color: Color(0xFFFF3B30),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'edit') {
                _editEmployee(context);
              } else if (value == 'delete') {
                _confirmDelete(context);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        child: ListView(
          children: [
            _buildDetailCard(title: 'ФИО', value: employee.fullName),
            _buildDetailCard(title: 'Должность', value: employee.position),
            _buildDetailCard(
              title: 'Заработная плата',
              value: '${employee.salary.toStringAsFixed(0)} ₽',
            ),
            _buildDetailCard(title: 'Номер телефона', value: employee.phone),
            _buildDetailCard(
              title: 'Дата регистрации',
              value: DateFormat('dd.MM.yyyy').format(employee.hireDate),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard({required String title, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            height: 1.6,
            color: Color(0xFF818181),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
          color: const Color(0xFFF2F5F7),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                height: 1.4,
                color: Color(0xFF252525),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  void _editEmployee(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmployeeEditScreen(employee: employee),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFFF2F5F7),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text('Удалить сотрудника?'),
        content: const Text('Вы уверены, что хотите удалить этого сотрудника?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Отмена',
              style: TextStyle(
                color: Color(0xFF252525),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              _deleteEmployee(context);
            },
            child: const Text(
              'Удалить',
              style: TextStyle(color: Color(0xFFFF3B30)),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteEmployee(BuildContext context) {
    final box = Hive.box<Employee>('employees');
    final key = employee.key;

    if (key != null) {
      box.delete(key);
    }

    Navigator.pop(context);
    Navigator.pop(context, true);
  }
}

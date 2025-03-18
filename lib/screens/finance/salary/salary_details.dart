import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:personnel_management_flutter/models/employee/employee.dart';
import 'package:personnel_management_flutter/models/finance/bonus.dart';
import 'package:personnel_management_flutter/models/finance/reprimand.dart';

class SalaryDetailsScreen extends StatelessWidget {
  final Employee employee;

  const SalaryDetailsScreen({
    super.key,
    required this.employee,
  });

  @override
  Widget build(BuildContext context) {
    final salaryFormatted =
        NumberFormat.decimalPattern('ru_RU').format(employee.salary);
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
    final bonusSumFormatted =
        NumberFormat.decimalPattern('ru_RU').format(bonusSum);
    final bonusDate = employeeBonusList.isNotEmpty
        ? DateFormat('dd.MM.yyyy').format(employeeBonusList.first.date)
        : '';
    final finesSum =
        employeeFinesList.isNotEmpty ? employeeFinesList.first.sum : 0;
    final finesSumFormatted =
        NumberFormat.decimalPattern('ru_RU').format(finesSum);
    final finesDate = employeeFinesList.isNotEmpty
        ? DateFormat('dd.MM.yyyy').format(employeeFinesList.first.date)
        : '';
    final finalSalary = employee.salary + bonusSum - finesSum;
    final finalSalaryFormatted =
        NumberFormat.decimalPattern('ru_RU').format(finalSalary);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Данные о зарплате',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 17,
            color: Color(0xFF252525),
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        children: [
          _buildDetailCard(title: 'Сотрудник', value: employee.fullName),
          _buildDetailCard(title: 'Должность', value: employee.position),
          _buildPeriodCard(),
          _buildDetailCard(title: 'Зарплата', value: '$salaryFormatted ₽'),
          _buildFinesBonuses(
            title: 'Штрафы и премии',
            bonus: bonusSumFormatted,
            bonusDate: bonusDate,
            fines: finesSumFormatted,
            finesDate: finesDate,
          ),
          _buildDetailCardTooltip(
            title: 'Итоговая сумма',
            value: '$finalSalaryFormatted ₽',
            tooltipMessage:
                'Расчёт производится\nна основе указанной\nзаработной платы, а также\nучёта штрафов и премий.',
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard({
    required String title,
    required String value,
  }) {
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

  Widget _buildDetailCardTooltip({
    required String title,
    required String value,
    String? tooltipMessage,
  }) {
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
            child: Row(
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.4,
                    color: Color(0xFF252525),
                  ),
                ),
                Spacer(),
                if (tooltipMessage != null) ...[
                  Tooltip(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Color(0xFFF2F5F7)),
                    message: tooltipMessage,
                    textStyle: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF252525),
                    ),
                    child: SvgPicture.asset('assets/svg/help-icon.svg'),
                  ),
                ]
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildPeriodCard() {
    final start = DateFormat('dd.MM.yyyy').format(employee.hireDate);
    final end = DateFormat('dd.MM.yyyy')
        .format(employee.hireDate.add(Duration(days: 30)));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Расчетный период',
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
              '$start - $end',
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

  Widget _buildFinesBonuses({
    required String title,
    required String bonus,
    required String bonusDate,
    required String fines,
    required String finesDate,
  }) {
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
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Color(0xFFA6EA86),
                      child: SvgPicture.asset('assets/svg/wallet.svg'),
                    ),
                    SizedBox(width: 12),
                    Text(
                      '+ $bonus ₽',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF252525),
                      ),
                    ),
                    Spacer(),
                    Text(
                      bonusDate,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF818181),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Color(0xFFEA8C86),
                      child: SvgPicture.asset('assets/svg/wallet.svg'),
                    ),
                    SizedBox(width: 12),
                    Text(
                      '- $fines ₽',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF252525),
                      ),
                    ),
                    Spacer(),
                    Text(
                      finesDate,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF818181),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

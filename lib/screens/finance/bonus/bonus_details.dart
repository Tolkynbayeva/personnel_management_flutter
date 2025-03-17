import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:personnel_management_flutter/models/finance/bonus.dart';
import 'package:personnel_management_flutter/screens/finance/bonus/bonus_edit.dart';

class BonusDetailsScreen extends StatelessWidget {
  final Bonus bonus;

  const BonusDetailsScreen({
    super.key,
    required this.bonus,
  });

  @override
  Widget build(BuildContext context) {
    final salaryFormatted =
        NumberFormat.decimalPattern('ru_RU').format(bonus.sum);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Данные премии',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 17,
            height: 1.3,
            color: Color(0xFF252525),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BonusEditScreen(bonus: bonus),
                ),
              );
            },
            icon: SvgPicture.asset('assets/svg/edit-icon.svg'),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        children: [
          _buildDetailCard(
            title: 'Сотрудник',
            value: bonus.employeeName,
          ),
          _buildDetailCard(
            title: 'Название',
            value: bonus.info,
          ),
          _buildDetailCard(
            title: 'Тип',
            value: bonus.bonus,
          ),
          _buildDetailCard(
            title: 'Дата ',
            value: DateFormat('dd.MM.yyyy').format(bonus.date),
          ),
          _buildDetailCard(
            title: 'Сумма',
            value: '$salaryFormatted ₽',
          ),
          _buildDetailCard(
            title: 'Комментарий',
            value: bonus.comment,
          ),
        ],
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
}

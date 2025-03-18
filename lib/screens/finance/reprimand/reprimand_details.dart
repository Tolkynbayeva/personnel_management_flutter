import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:personnel_management_flutter/models/finance/reprimand.dart';
import 'package:personnel_management_flutter/screens/finance/reprimand/reprimand_edit.dart';

class ReprimandDetailsScreen extends StatelessWidget {
  final Reprimand reprimand;

  const ReprimandDetailsScreen({
    super.key,
    required this.reprimand,
  });

  @override
  Widget build(BuildContext context) {
    final salaryFormatted =
        NumberFormat.decimalPattern('ru_RU').format(reprimand.sum);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Данные выговора',
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
                  builder: (context) =>
                      ReprimandEditScreen(reprimand: reprimand),
                ),
              );
            },
            icon: SvgPicture.asset('assets/svg/edit-icon.svg'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        child: ListView(
          children: [
            _buildDetailCard(
              title: 'Сотрудник',
              value: reprimand.employeeName,
            ),
            _buildDetailCard(
              title: 'Название',
              value: reprimand.info,
            ),
            _buildDetailCard(
              title: 'Тип',
              value: reprimand.rebuke,
            ),
            _buildDetailCard(
              title: 'Дата ',
              value: DateFormat('dd.MM.yyyy').format(reprimand.date),
            ),
            _buildDetailCard(
              title: 'Сумма',
              value: '$salaryFormatted ₽',
            ),
            if (reprimand.comment.isNotEmpty)
              _buildDetailCard(
                title: 'Комментарий',
                value: reprimand.comment,
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
}

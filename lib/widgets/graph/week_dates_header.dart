import 'package:flutter/material.dart';

class WeekDatesHeader extends StatefulWidget {
  final DateTime initialDate;
  final ValueChanged<DateTime> onDateSelected;

  const WeekDatesHeader({
    super.key,
    required this.initialDate,
    required this.onDateSelected,
  });

  @override
  State<WeekDatesHeader> createState() => _WeekDatesHeaderState();
}

class _WeekDatesHeaderState extends State<WeekDatesHeader> {
  late List<DateTime> _weekDates;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _weekDates = _generateWeekDates(widget.initialDate);
    _selectedDate = widget.initialDate;
  }

  List<DateTime> _generateWeekDates(DateTime date) {
    final weekday = date.weekday;
    final monday = date.subtract(Duration(days: weekday - 1));
    return List.generate(7, (i) => monday.add(Duration(days: i)));
  }

  @override
  Widget build(BuildContext context) {
    final monthName = _formatMonth(_weekDates.first);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          monthName,
          style: const TextStyle(
            fontSize: 16,
            height: 1.4,
            color: Color(0xFF252525),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 64,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _weekDates.length,
            separatorBuilder: (context, index) => const SizedBox(width: 2),
            itemBuilder: (context, index) {
              final day = _weekDates[index];
              return _buildDayCard(day);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDayCard(DateTime day) {
    final isSelected = _selectedDate != null && _isSameDay(day, _selectedDate!);
    final dayNum = day.day;
    final weekdayName = _shortWeekday(day);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDate = day;
        });
        widget.onDateSelected(day);
      },
      child: Container(
        margin: EdgeInsets.only(right: 8, bottom: 2),
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D000000),
              offset: Offset(0, 2),
              blurRadius: 6,
            ),
          ],
          gradient: isSelected
              ? const LinearGradient(
                  colors: [
                    Color(0xFF2253F6),
                    Color(0xFF9DB4FF),
                  ],
                  end: Alignment(2, 0),
                )
              : null,
          color: isSelected ? null : const Color(0xFFF2F5F7),
          borderRadius: BorderRadius.circular(13),
        ),
        width: 44,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              weekdayName,
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? Color(0xFFF2F2EA) : const Color(0xFF252525),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$dayNum',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isSelected ? Color(0xFFF2F2EA) : const Color(0xFF252525),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }

  String _formatMonth(DateTime date) {
    final months = [
      'Январь',
      'Февраль',
      'Март',
      'Апрель',
      'Май',
      'Июнь',
      'Июль',
      'Август',
      'Сентябрь',
      'Октябрь',
      'Ноябрь',
      'Декабрь'
    ];
    return months[date.month - 1];
  }

  String _shortWeekday(DateTime date) {
    switch (date.weekday) {
      case 1:
        return 'ПН';
      case 2:
        return 'ВТ';
      case 3:
        return 'СР';
      case 4:
        return 'ЧТ';
      case 5:
        return 'ПТ';
      case 6:
        return 'СБ';
      case 7:
        return 'ВС';
    }
    return '';
  }
}

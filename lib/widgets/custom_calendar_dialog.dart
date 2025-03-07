import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomCalendarDialog extends StatefulWidget {
  final DateTime? initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  CustomCalendarDialog({
    super.key,
    this.initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  })  : firstDate = firstDate ?? DateTime(2000),
        lastDate = lastDate ?? DateTime(2100);

  @override
  State<CustomCalendarDialog> createState() => _CustomCalendarDialogState();
}

class _CustomCalendarDialogState extends State<CustomCalendarDialog> {
  late DateTime _selectedDate;
  late DateTime _displayDate;

  final List<String> weekdays = ['ПН', 'ВТ', 'СР', 'ЧТ', 'ПТ', 'СБ', 'ВС'];

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
    _displayDate = DateTime(_selectedDate.year, _selectedDate.month);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      content: Container(
        width: 360,
        height: 460,
        decoration: BoxDecoration(
          color: const Color(0xFFF2F5F7),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: const Offset(0, 2),
              blurRadius: 6,
            ),
          ],
        ),
        child: Column(
          children: [
            _buildHeader(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: weekdays
                    .map(
                      (day) => Expanded(
                        child: Center(
                          child: Text(
                            day,
                            style: const TextStyle(
                              fontSize: 16,
                              height: 1.5,
                              color: Color(0xFF252525),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            Expanded(child: _buildDaysGrid()),
            _buildBottomButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final monthText = DateFormat('LLLL', 'ru').format(_displayDate);
    final yearText = DateFormat('yyyy').format(_displayDate);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  size: 18,
                  color: Color(0xFF252525),
                ),
                onPressed: _goToPreviousMonth,
              ),
              PopupMenuButton<int>(
                color: const Color(0xFFF2F5F7),
                onSelected: (int newMonth) {
                  setState(() {
                    _displayDate =
                        DateTime(_displayDate.year, newMonth, _displayDate.day);
                  });
                },
                child: Row(
                  children: [
                    Text(
                      monthText,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF252525),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_drop_down,
                      color: Color(0xFF252525),
                    ),
                  ],
                ),
                itemBuilder: (context) {
                  return List.generate(12, (index) {
                    final monthIndex = index + 1;
                    final dateForName = DateTime(2023, monthIndex);
                    final localMonth =
                        DateFormat('LLLL', 'ru').format(dateForName);
                    return PopupMenuItem<int>(
                      value: monthIndex,
                      child: Text(localMonth),
                    );
                  });
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: Color(0xFF252525),
                ),
                onPressed: _goToNextMonth,
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  size: 18,
                  color: Color(0xFF252525),
                ),
                onPressed: _goToPreviousYear,
              ),
              PopupMenuButton<int>(
                color: const Color(0xFFF2F5F7),
                onSelected: (int newYear) {
                  setState(() {
                    _displayDate =
                        DateTime(newYear, _displayDate.month, _displayDate.day);
                  });
                },
                child: Row(
                  children: [
                    Text(
                      yearText,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF252525),
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down, color: Color(0xFF252525)),
                  ],
                ),
                itemBuilder: (context) {
                  return List.generate(101, (index) {
                    final yearValue = 2000 + index;
                    return PopupMenuItem<int>(
                      value: yearValue,
                      child: Text('$yearValue'),
                    );
                  });
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: Color(0xFF252525),
                ),
                onPressed: _goToNextYear,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDaysGrid() {
    final firstDayOfMonth = DateTime(_displayDate.year, _displayDate.month, 1);
    final weekdayOffset = firstDayOfMonth.weekday - 1;
    const totalCells = 42;

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemCount: totalCells,
      itemBuilder: (context, index) {
        final day = firstDayOfMonth.add(Duration(days: index - weekdayOffset));
        final isCurrentMonth = (day.month == _displayDate.month);
        final isSelected = (day.year == _selectedDate.year &&
            day.month == _selectedDate.month &&
            day.day == _selectedDate.day &&
            isCurrentMonth);

        final isEnabled =
            day.isAfter(widget.firstDate.subtract(const Duration(days: 1))) &&
                day.isBefore(widget.lastDate.add(const Duration(days: 1)));

        return GestureDetector(
          onTap: (isCurrentMonth && isEnabled)
              ? () {
                  setState(() {
                    _selectedDate = day;
                  });
                }
              : null,
          child: Container(
            alignment: Alignment.center,
            decoration: isSelected
                ? const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF2253F6), Color(0xFF9DB4FF)],
                    ),
                    shape: BoxShape.circle,
                  )
                : null,
            child: Text(
              '${day.day}',
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                letterSpacing: 0.5,
                color: isSelected ? Colors.white : const Color(0xFF252525),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Закрыть',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              height: 1.4,
              letterSpacing: 0.1,
              color: Color(0xFF2253F6),
            ),
          ),
        ),
        TextButton(
          onPressed: _applySelectedDate,
          child: const Text(
            'Применить',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              height: 1.4,
              letterSpacing: 0.1,
              color: Color(0xFF2253F6),
            ),
          ),
        ),
      ],
    );
  }

  void _goToPreviousMonth() {
    setState(() {
      _displayDate =
          DateTime(_displayDate.year, _displayDate.month - 1, _displayDate.day);
    });
  }

  void _goToNextMonth() {
    setState(() {
      _displayDate =
          DateTime(_displayDate.year, _displayDate.month + 1, _displayDate.day);
    });
  }

  void _goToPreviousYear() {
    setState(() {
      _displayDate =
          DateTime(_displayDate.year - 1, _displayDate.month, _displayDate.day);
    });
  }

  void _goToNextYear() {
    setState(() {
      _displayDate =
          DateTime(_displayDate.year + 1, _displayDate.month, _displayDate.day);
    });
  }

  void _applySelectedDate() {
    Navigator.of(context).pop(_selectedDate);
  }
}

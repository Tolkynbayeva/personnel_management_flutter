import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RangeCalendarDialog extends StatefulWidget {
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime? initialRangeStart;
  final DateTime? initialRangeEnd;

  RangeCalendarDialog({
    super.key,
    DateTime? firstDate,
    DateTime? lastDate,
    this.initialRangeStart,
    this.initialRangeEnd,
  })  : firstDate = firstDate ?? DateTime(2000),
        lastDate = lastDate ?? DateTime(2100);

  @override
  State<RangeCalendarDialog> createState() => _RangeCalendarDialogState();
}

class _RangeCalendarDialogState extends State<RangeCalendarDialog> {
  late DateTime _displayDate;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  final List<String> weekdays = ['ПН', 'ВТ', 'СР', 'ЧТ', 'ПТ', 'СБ', 'ВС'];

  @override
  void initState() {
    super.initState();
    _rangeStart = widget.initialRangeStart;
    _rangeEnd = widget.initialRangeEnd;

    _displayDate = _rangeStart ?? DateTime.now();
    if (_displayDate.isBefore(widget.firstDate)) {
      _displayDate = widget.firstDate;
    }
    if (_displayDate.isAfter(widget.lastDate)) {
      _displayDate = widget.lastDate;
    }
    _displayDate = DateTime(_displayDate.year, _displayDate.month);
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
        ),
        child: Column(
          children: [
            _buildHeader(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: weekdays.map((day) {
                  return Expanded(
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
                  );
                }).toList(),
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
                icon: const Icon(Icons.arrow_back_ios, size: 18),
                onPressed: _goToPreviousMonth,
              ),
              PopupMenuButton<int>(
                color: const Color(0xFFF2F5F7),
                onSelected: (int newMonth) {
                  setState(() {
                    _displayDate = DateTime(
                      _displayDate.year,
                      newMonth,
                      _displayDate.day,
                    );
                  });
                },
                child: Row(
                  children: [
                    Text(
                      monthText,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down),
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
                icon: const Icon(Icons.arrow_forward_ios, size: 18),
                onPressed: _goToNextMonth,
              ),
            ],
          ),
          // Блок переключения года
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, size: 18),
                onPressed: _goToPreviousYear,
              ),
              PopupMenuButton<int>(
                color: const Color(0xFFF2F5F7),
                onSelected: (int newYear) {
                  setState(() {
                    _displayDate = DateTime(
                      newYear,
                      _displayDate.month,
                      _displayDate.day,
                    );
                  });
                },
                child: Row(
                  children: [
                    Text(
                      yearText,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down),
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
                icon: const Icon(Icons.arrow_forward_ios, size: 18),
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
        final isEnabled =
            !day.isBefore(widget.firstDate) && !day.isAfter(widget.lastDate);
        final inRange = _inRange(day);
        final isStart = _isSameDay(day, _rangeStart);
        final isEnd = _isSameDay(day, _rangeEnd);

        return GestureDetector(
          onTap: (isCurrentMonth && isEnabled) ? () => _onDayTap(day) : null,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: (inRange && !isStart && !isEnd)
                  ? const Color(0xFFE8DEF8)
                  : null,
            ),
            child: _buildDayContent(
                day, isCurrentMonth, isEnabled, isStart, isEnd),
          ),
        );
      },
    );
  }

  Widget _buildDayContent(DateTime day, bool isCurrentMonth, bool isEnabled,
      bool isStart, bool isEnd) {
    final isSelected = (isStart || isEnd);

    return Container(
      decoration: isSelected
          ? const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2253F6), Color(0xFF9DB4FF)],
              ),
              shape: BoxShape.circle,
            )
          : null,
      alignment: Alignment.center,
      child: Text(
        '${day.day}',
        style: TextStyle(
          fontSize: 16,
          height: 1.5,
          color: !isCurrentMonth
              ? Colors.grey
              : isSelected
                  ? Colors.white
                  : isEnabled
                      ? const Color(0xFF252525)
                      : Colors.grey.shade400,
        ),
      ),
    );
  }

  bool _inRange(DateTime day) {
    if (_rangeStart == null || _rangeEnd == null) return false;
    final start = _rangeStart!;
    final end = _rangeEnd!;
    return !day.isBefore(start) && !day.isAfter(end);
  }

  bool _isSameDay(DateTime d1, DateTime? d2) {
    if (d2 == null) return false;
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }

  void _onDayTap(DateTime day) {
    setState(() {
      if (_rangeStart == null) {
        _rangeStart = day;
        _rangeEnd = null; 
      } else if (_rangeEnd == null) {
        if (day.isBefore(_rangeStart!)) {
          _rangeEnd = _rangeStart;
          _rangeStart = day;
        } else {
          _rangeEnd = day;
        }
      } else {
        _rangeStart = day;
        _rangeEnd = null;
      }
    });
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
          onPressed: _applySelectedRange,
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

  void _applySelectedRange() {
    if (_rangeStart == null || _rangeEnd == null) {
      Navigator.of(context).pop(null);
    } else {
      Navigator.of(context).pop([_rangeStart, _rangeEnd]);
    }
  }

  void _goToPreviousMonth() {
    setState(() {
      final prevMonth =
          DateTime(_displayDate.year, _displayDate.month - 1, _displayDate.day);
      if (prevMonth.isBefore(widget.firstDate)) return; // не выходим за границы
      _displayDate = prevMonth;
    });
  }

  void _goToNextMonth() {
    setState(() {
      final nextMonth =
          DateTime(_displayDate.year, _displayDate.month + 1, _displayDate.day);
      if (nextMonth.isAfter(widget.lastDate)) return;
      _displayDate = nextMonth;
    });
  }

  void _goToPreviousYear() {
    setState(() {
      final prevYear =
          DateTime(_displayDate.year - 1, _displayDate.month, _displayDate.day);
      if (prevYear.isBefore(widget.firstDate)) return;
      _displayDate = prevYear;
    });
  }

  void _goToNextYear() {
    setState(() {
      final nextYear =
          DateTime(_displayDate.year + 1, _displayDate.month, _displayDate.day);
      if (nextYear.isAfter(widget.lastDate)) return;
      _displayDate = nextYear;
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:personnel_management_flutter/models/employee/employee.dart';
import 'package:personnel_management_flutter/models/graph/graph.dart';
import 'package:personnel_management_flutter/screens/graph/graph_saved.dart';
import 'package:personnel_management_flutter/widgets/button_save.dart';
import 'package:intl/intl.dart';
import 'package:personnel_management_flutter/widgets/employee_autocomplete.dart';
import 'package:personnel_management_flutter/widgets/range_calendar_dialog.dart';
import 'package:personnel_management_flutter/screens/graph/graph_saved.dart';

class GraphAddScreen extends StatefulWidget {
  const GraphAddScreen({super.key});

  @override
  State<GraphAddScreen> createState() => _GraphAddScreenState();
}

class _GraphAddScreenState extends State<GraphAddScreen> {
  Employee? _selectedEmployee;
  DateTime? _workStartDate;
  DateTime? _workEndDate;
  TimeOfDay? _timeStart;
  TimeOfDay? _timeEnd;
  DateTime? _offStartDate;
  DateTime? _offEndDate;

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Employee>('employees');
    final allEmployees = box.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Добавить график',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 17,
            height: 1.3,
            color: Color(0xFF252525),
          ),
        ),
        actions: [
          IconButton(
            onPressed: _deleteSchedule,
            icon: SvgPicture.asset('assets/svg/trash.svg'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // EmployeeAutocompleteField(
                //   employees: allEmployees,
                //   initialEmployee: _selectedEmployee,
                //   onEmployeeSelected: (emp) {
                //     setState(() {
                //       _selectedEmployee = emp;
                //     });
                //   },
                // ),
                _buildWorkPeriodTile(),
                const Text(
                  'Рабочее время',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: Color(0xFF818181),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _buildTimeField(isStart: true)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildTimeField(isStart: false)),
                  ],
                ),
                const SizedBox(height: 16),
                _buildDayOffTile(),
              ],
            ),
            ButtonSave(onPressed: _saveSchedule),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkPeriodTile() {
    final periodText = (_workStartDate != null && _workEndDate != null)
        ? '${_formatDate(_workStartDate!)} - ${_formatDate(_workEndDate!)}'
        : 'Рабочий период';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
      color: const Color(0xFFF2F5F7),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        title: Text(
          periodText,
          style: const TextStyle(
            fontSize: 16,
            height: 1.4,
            color: Color(0xFF252525),
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          size: 30,
          color: Color(0xFF818181),
        ),
        onTap: () => _pickRange(),
      ),
    );
  }

  Widget _buildTimeField({required bool isStart}) {
    final label = isStart ? 'с' : 'до';
    final timeValue = isStart ? _timeStart : _timeEnd;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
      color: const Color(0xFFF2F5F7),
      child: InkWell(
        onTap: () => _pickTime(isStart),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.6,
                  color: Color(0xFF818181),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                timeValue != null ? _formatTime(timeValue) : '--:--',
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.4,
                  color: Color(0xFF252525),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDayOffTile() {
    final offText = (_offStartDate != null && _offEndDate != null)
        ? '${_formatDate(_offStartDate!)} - ${_formatDate(_offEndDate!)}'
        : 'Выходной';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
      color: const Color(0xFFF2F5F7),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        title: Text(
          offText,
          style: const TextStyle(
            fontSize: 16,
            height: 1.4,
            color: Color(0xFF252525),
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          size: 30,
          color: Color(0xFF818181),
        ),
        onTap: () => _pickRange(isDayOff: true),
      ),
    );
  }

  Future<void> _pickRange({bool isDayOff = false}) async {
    final result = await showDialog<List<DateTime?>>(
      context: context,
      builder: (_) => RangeCalendarDialog(),
    );

    if (result != null &&
        result.length == 2 &&
        result[0] != null &&
        result[1] != null) {
      final start = result[0]!;
      final end = result[1]!;

      setState(() {
        if (isDayOff) {
          _offStartDate = start;
          _offEndDate = end;
        } else {
          _workStartDate = start;
          _workEndDate = end;
        }
      });
    }
  }

  Future<void> _pickTime(bool isStart) async {
    final initialTime = TimeOfDay.now();
    final picked = await showTimePicker(
      context: context,
      initialTime:
          isStart ? (_timeStart ?? initialTime) : (_timeEnd ?? initialTime),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _timeStart = picked;
        } else {
          _timeEnd = picked;
        }
      });
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('d MMMM yyyy', 'ru').format(date);
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  void _saveSchedule() {
    if (_selectedEmployee == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Выберите сотрудника')),
      );
      return;
    }

    final employeeKey = _selectedEmployee!.key as int?;
    final timeStartStr = _timeStart != null
        ? '${_timeStart!.hour.toString().padLeft(2, '0')}:${_timeStart!.minute.toString().padLeft(2, '0')}'
        : null;
    final timeEndStr = _timeEnd != null
        ? '${_timeEnd!.hour.toString().padLeft(2, '0')}:${_timeEnd!.minute.toString().padLeft(2, '0')}'
        : null;

    final newGraph = Graph(
      employeeKey: employeeKey,
      workStartDate: _workStartDate,
      workEndDate: _workEndDate,
      timeStart: timeStartStr,
      timeEnd: timeEndStr,
      offStartDate: _offStartDate,
      offEndDate: _offEndDate,
    );
    final box = Hive.box<Graph>('graphs');
    box.add(newGraph);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => GraphSavedScreen()),
    );
  }

  void _deleteSchedule() {
    // TODO: Логика удаления
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Удаление графика (заглушка)')),
    );
  }
}

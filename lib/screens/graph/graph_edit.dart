import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:personnel_management_flutter/models/employee/employee.dart';
import 'package:personnel_management_flutter/models/graph/graph.dart';
import 'package:personnel_management_flutter/screens/graph/graph_save.dart';
import 'package:personnel_management_flutter/widgets/button_save.dart';
import 'package:personnel_management_flutter/widgets/employee_autocomplete.dart';
import 'package:personnel_management_flutter/widgets/range_calendar_dialog.dart';

class GraphEditScreen extends StatefulWidget {
  final Graph graph;

  const GraphEditScreen({
    super.key,
    required this.graph,
  });

  @override
  State<GraphEditScreen> createState() => _GraphEditScreenState();
}

class _GraphEditScreenState extends State<GraphEditScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _employeeController;
  DateTime? _workStartDate;
  DateTime? _workEndDate;
  TimeOfDay? _timeStart;
  TimeOfDay? _timeEnd;
  DateTime? _offStartDate;
  DateTime? _offEndDate;

  @override
  void initState() {
    super.initState();
    _employeeController =
        TextEditingController(text: widget.graph.employeeName);
    _workStartDate = widget.graph.workStartDate;
    _workEndDate = widget.graph.workEndDate;
    if (widget.graph.timeStart != null) {
      _timeStart = _parseTimeOfDay(widget.graph.timeStart!);
    }
    if (widget.graph.timeEnd != null) {
      _timeEnd = _parseTimeOfDay(widget.graph.timeEnd!);
    }
    _offStartDate = widget.graph.offStartDate;
    _offEndDate = widget.graph.offEndDate;
  }

  TimeOfDay _parseTimeOfDay(String timeString) {
    final parts = timeString.split(':');
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = int.tryParse(parts[1]) ?? 0;
    return TimeOfDay(hour: hour, minute: minute);
  }

  String _formatDate(DateTime date) {
    return DateFormat('d MMMM yyyy', 'ru').format(date);
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  void _saveChanges() async {
    widget.graph.employeeName = _employeeController.text.trim();
    widget.graph.workStartDate = _workStartDate;
    widget.graph.workEndDate = _workEndDate;
    widget.graph.timeStart =
        _timeStart != null ? _formatTime(_timeStart!) : null;
    widget.graph.timeEnd = _timeEnd != null ? _formatTime(_timeEnd!) : null;
    widget.graph.offStartDate = _offStartDate;
    widget.graph.offEndDate = _offEndDate;

    await widget.graph.save();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => GraphSaveScreen(),
      ),
    );
  }

  void _confirmDeleteGraph(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFFF2F5F7),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text('Удалить график сотрудника?'),
        content: const Text(
            'Вы уверены, что хотите удалить график этого сотрудника?'),
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
              _deleteGraph(context);
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

  void _deleteGraph(BuildContext context) {
    final box = Hive.box<Graph>('graphs');
    final key = widget.graph.key;
    if (key != null) {
      box.delete(key);
    }

    Navigator.pop(context);
    Navigator.pop(context, true);
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

  Widget _buildWorkPeriodTile() {
    final periodText = (_workStartDate != null && _workEndDate != null)
        ? '${_formatDate(_workStartDate!)} - ${_formatDate(_workEndDate!)}'
        : 'Рабочий период';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F5F7),
        borderRadius: BorderRadius.circular(13),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            offset: Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
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
          Icons.arrow_forward_ios,
          size: 20,
          color: Color(0xFF818181),
        ),
        onTap: () => _pickRange(),
      ),
    );
  }

  Widget _buildTimeField({required String label, required bool isStart}) {
    final maskFormatter = MaskTextInputFormatter(
      mask: '##:##',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy,
    );

    // Заполняем поле времени значением, если оно есть
    final initialText = isStart && _timeStart != null
        ? _formatTime(_timeStart!)
        : !isStart && _timeEnd != null
            ? _formatTime(_timeEnd!)
            : '';

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF2F5F7),
        borderRadius: BorderRadius.circular(13),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            offset: Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 16, bottom: 16),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF252525),
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: TextEditingController(text: initialText),
              keyboardType: TextInputType.number,
              inputFormatters: [maskFormatter],
              decoration: const InputDecoration(
                hintText: '--:--',
                border: InputBorder.none,
              ),
              onChanged: (value) {
                final unmasked = maskFormatter.getUnmaskedText();
                if (unmasked.length == 4) {
                  try {
                    final hour = int.parse(unmasked.substring(0, 2));
                    final minute = int.parse(unmasked.substring(2, 4));
                    final newTime = TimeOfDay(hour: hour, minute: minute);
                    setState(() {
                      if (isStart) {
                        _timeStart = newTime;
                      } else {
                        _timeEnd = newTime;
                      }
                    });
                  } catch (_) {}
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayOffTile() {
    final offText = (_offStartDate != null && _offEndDate != null)
        ? '${_formatDate(_offStartDate!)} - ${_formatDate(_offEndDate!)}'
        : 'Выходной';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F5F7),
        borderRadius: BorderRadius.circular(13),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            offset: Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
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
          Icons.arrow_forward_ios,
          size: 20,
          color: Color(0xFF818181),
        ),
        onTap: () => _pickRange(isDayOff: true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Редактировать график',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 17,
            height: 1.3,
            color: Color(0xFF252525),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _confirmDeleteGraph(context),
            icon: SvgPicture.asset('assets/svg/trash.svg'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Сотрудник',
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.6,
                          color: Color(0xFF818181),
                        ),
                      ),
                      const SizedBox(height: 12),
                      EmployeeTypeAheadField(
                        controller: _employeeController,
                        onSelected: (Employee selected) {
                          _employeeController.text = selected.fullName;
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                      ),
                      const SizedBox(height: 16),
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
                          Expanded(
                              child:
                                  _buildTimeField(label: 'с ', isStart: true)),
                          const SizedBox(width: 16),
                          Expanded(
                              child: _buildTimeField(
                                  label: 'до ', isStart: false)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildDayOffTile(),
                    ],
                  ),
                ),
              ),
            ),
            ButtonSave(onPressed: _saveChanges),
          ],
        ),
      ),
    );
  }
}

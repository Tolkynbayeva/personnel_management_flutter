import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class GraphAddScreen extends StatefulWidget {
  const GraphAddScreen({super.key});

  @override
  State<GraphAddScreen> createState() => _GraphAddScreenState();
}

class _GraphAddScreenState extends State<GraphAddScreen> {
  final _formKey = GlobalKey();

  final _employeeController = TextEditingController();
  DateTime? _workStartDate;
  DateTime? _workEndDate;
  TimeOfDay? _timeStart;
  TimeOfDay? _timeEnd;
  DateTime? _offStartDate;
  DateTime? _offEndDate;

  late Box<Employee> _employeeBox;
  late Box<Graph> _graphBox;

  @override
  void initState() {
    super.initState();
    _employeeBox = Hive.box<Employee>('employees');
    _graphBox = Hive.box<Graph>('graphs');
  }

  @override
  void dispose() {
    super.dispose();
    _employeeController.dispose();
  }

  void _saveGraph() async {
    if (_employeeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Выберите сотрудника')));
      return;
    }

    final newGraph = Graph(
      employeeName: _employeeController.text.trim(),
      workStartDate: _workStartDate,
      workEndDate: _workEndDate,
      timeStart: _timeStart != null ? _formatTime(_timeStart!) : null,
      timeEnd: _timeEnd != null ? _formatTime(_timeEnd!) : null,
      offStartDate: _offStartDate,
      offEndDate: _offEndDate,
    );

    _graphBox.add(newGraph);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => GraphSaveScreen(),
      ),
    );
  }

  void _deleteGraph() async {
    final graphBox = Hive.box<Graph>('graphs');
    final graphsToDelete = graphBox.values
        .where((g) => g.employeeName == _employeeController.text.trim())
        .toList();

    if (graphsToDelete.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('График не найден')));
      return;
    }

    for (final graph in graphsToDelete) {
      await graph.delete();
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('График удален')));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
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
            onPressed: _deleteGraph,
            icon: SvgPicture.asset('assets/svg/trash.svg'),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      EmployeeTypeAheadField(
                        color: Color(0xFF252525),
                        controller: _employeeController,
                        onSelected: (Employee selected) {
                          _employeeController.text = selected.fullName;
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                      ),
                      SizedBox(height: 16),
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
            ButtonSave(onPressed: _saveGraph)
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('d MMMM yyyy', 'ru').format(date);
  }

  Widget _buildWorkPeriodTile() {
    final periodText = (_workStartDate != null && _workEndDate != null)
        ? '${_formatDate(_workStartDate!)} - ${_formatDate(_workEndDate!)}'
        : 'Рабочий период';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Color(0xFFF2F5F7),
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

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Widget _buildTimeField({required String label, required bool isStart}) {
    final maskFormatter = MaskTextInputFormatter(
      mask: '##:##',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy,
    );

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
        color: Color(0xFFF2F5F7),
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
}

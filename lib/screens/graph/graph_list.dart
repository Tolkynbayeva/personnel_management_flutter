import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:personnel_management_flutter/models/graph/graph.dart';
import 'package:personnel_management_flutter/screens/graph/graph_edit.dart';
import 'package:personnel_management_flutter/widgets/button_add.dart';
import 'package:personnel_management_flutter/screens/graph/graph_add.dart';
import 'package:personnel_management_flutter/widgets/graph/week_dates_header.dart';

class GraphListScreen extends StatefulWidget {
  const GraphListScreen({super.key});

  @override
  State<GraphListScreen> createState() => _GraphListScreenState();
}

class _GraphListScreenState extends State<GraphListScreen> {
  late Box<Graph> _graphBox;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _graphBox = Hive.box<Graph>('graphs');
    _selectedDate = DateTime.now();
  }

  String formatEmployeeName(String fullName) {
    final parts = fullName.split(' ');
    if (parts.length >= 3) {
      final surname = parts[0];
      final nameInitial = parts[1].substring(0, 1);
      final patronymicInitial = parts[2].substring(0, 1);
      return '$surname $nameInitial.$patronymicInitial';
    }
    return fullName;
  }

  bool _isWithinRange(DateTime date, DateTime start, DateTime end) {
    final d = DateTime(date.year, date.month, date.day);
    final s = DateTime(start.year, start.month, start.day);
    final e = DateTime(end.year, end.month, end.day);

    return !d.isBefore(s) && !d.isAfter(e);
  }

  @override
  Widget build(BuildContext context) {
    if (!Hive.isBoxOpen('graphs')) {
      return const Center(child: CircularProgressIndicator());
    }

    final graphs = _graphBox.values.toList()
      ..sort((a, b) => a.employeeName.compareTo(b.employeeName));

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
          child: Column(
            children: [
              WeekDatesHeader(
                initialDate: DateTime.now(),
                onDateSelected: (date) {
                  setState(() {
                    _selectedDate = date;
                  });
                },
              ),
              const SizedBox(height: 14),
              Divider(height: 1, color: Color(0xFF000000).withOpacity(0.05)),
              const SizedBox(height: 22),
              Expanded(
                child: ListView.builder(
                  itemCount: graphs.length,
                  itemBuilder: (context, index) {
                    final graph = graphs[index];
                    final isDayOff = _isWithinRange(
                      _selectedDate!,
                      graph.offStartDate!,
                      graph.offEndDate!,
                    );
                    final isWorking = _isWithinRange(
                      _selectedDate!,
                      graph.workStartDate!,
                      graph.workEndDate!,
                    );
                    final displayText = isDayOff
                        ? 'Выходной'
                        : (isWorking
                            ? '${graph.timeStart} - ${graph.timeEnd}'
                            : 'Нет данных');
                    final backgroundColor =
                        isDayOff ? Color(0xFFE5FFE9) : const Color(0xFFF2F5F7);

                    return InkWell(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => GraphEditScreen(graph: graph),
                          ),
                        );

                        if (result == true) {
                          setState(() {});
                        }
                      },
                      child: Card(
                        margin: const EdgeInsets.only(bottom: 9),
                        color: backgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  formatEmployeeName(graph.employeeName),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF252525),
                                  ),
                                ),
                              ),
                              Text(
                                displayText,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF252525),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: ButtonAdd(onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const GraphAddScreen(),
              ),
            );
          }),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:personnel_management_flutter/models/graph/graph.dart';
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
  DateTime? _selectedDate; // какую дату выбрал пользователь

  @override
  void initState() {
    super.initState();
    _graphBox = Hive.box<Graph>('graphs');
    _selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    if (!Hive.isBoxOpen('graphs')) {
      return const Center(child: CircularProgressIndicator());
    }

    final graphs = _graphBox.values.toList();

    // Пример: если нужно фильтровать
    // final filtered = graphs.where((g) => _belongsToSelectedDate(g)).toList();

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
                  // Если хотите фильтровать — сделайте логику здесь
                },
              ),
              const SizedBox(height: 16),
              Divider(height: 1, color: Color(0xFF000000).withOpacity(0.05)),
              const SizedBox(height: 22),
              Expanded(
                child: ListView.builder(
                  itemCount: graphs.length,
                  itemBuilder: (context, index) {
                    final graph = graphs[index];
                    return InkWell(
                      onTap: () {
                        // TODO: открыть детали графика?
                      },
                      child: Card(
                        margin: const EdgeInsets.only(bottom: 9),
                        color: const Color(0xFFF2F5F7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Expanded(
                                child:
                                    Text('Employee key: ${graph.employeeKey}'),
                              ),
                              Text('${graph.timeStart} - ${graph.timeEnd}'),
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

  bool _belongsToSelectedDate(Graph g) {
    if (_selectedDate == null) return true; // показать все
    // Считаем, что если workStartDate == _selectedDate, тогда подходит
    // Или offStartDate == _selectedDate
    // (Логика фильтрации зависит от ваших требований)
    if (g.workStartDate != null &&
        _isSameDay(g.workStartDate!, _selectedDate!)) {
      return true;
    }
    if (g.offStartDate != null && _isSameDay(g.offStartDate!, _selectedDate!)) {
      return true;
    }
    return false;
  }

  bool _isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }
}

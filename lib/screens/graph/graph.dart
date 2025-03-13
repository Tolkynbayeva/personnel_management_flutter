import 'package:flutter/material.dart';
import 'package:personnel_management_flutter/models/graph/graph.dart';
import 'package:personnel_management_flutter/screens/graph/graph_add.dart';
import 'package:personnel_management_flutter/screens/graph/graph_list.dart';
import 'package:personnel_management_flutter/widgets/empty.dart';
import 'package:hive_flutter/hive_flutter.dart';

class GraphScreen extends StatelessWidget {
  const GraphScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<Graph>>(
      valueListenable: Hive.box<Graph>('graphs').listenable(),
      builder: (context, box, _) {
        if (box.isEmpty) {
          return Empty(
            description: 'Добавьте график сотрудников.',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => GraphAddScreen(),
                ),
              );
            },
          );
        } else {
          return GraphListScreen();
        }
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:personnel_management_flutter/models/finance/reprimand.dart';
import 'package:personnel_management_flutter/screens/finance/reprimand/reprimand_add.dart';
import 'package:personnel_management_flutter/screens/finance/reprimand/reprimand_list.dart';
import 'package:personnel_management_flutter/widgets/empty.dart';

class ReprimandScreen extends StatelessWidget {
  final DateTime? filterDate;

  const ReprimandScreen({
    super.key,
    this.filterDate,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<Reprimand>>(
      valueListenable: Hive.box<Reprimand>('reprimands').listenable(),
      builder: (context, box, _) {
        if (box.isEmpty) {
          return Empty(
            description: 'Добавьте данные о финансовых операциях.',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ReprimandAddScreen(),
                ),
              );
            },
          );
        } else {
          return ReprimandListScreen(filterDate: filterDate);
        }
      },
    );
  }
}

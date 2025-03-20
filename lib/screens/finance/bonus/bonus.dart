import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:personnel_management_flutter/models/finance/bonus.dart';
import 'package:personnel_management_flutter/screens/finance/bonus/bonus_add.dart';
import 'package:personnel_management_flutter/screens/finance/bonus/bonus_list.dart';
import 'package:personnel_management_flutter/widgets/empty.dart';

class BonusScreen extends StatelessWidget {
  final DateTime? filterDate;

  const BonusScreen({
    super.key,
    this.filterDate,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<Bonus>>(
      valueListenable: Hive.box<Bonus>('bonuses').listenable(),
      builder: (context, box, _) {
        if (box.isEmpty) {
          return Empty(
            description: 'Добавьте данные о финансовых операциях.',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BonusAddScreen(),
                ),
              );
            },
          );
        } else {
          return BonusListScreen(filterDate: filterDate);
        }
      },
    );
  }
}

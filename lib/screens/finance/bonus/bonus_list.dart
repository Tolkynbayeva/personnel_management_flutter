import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:personnel_management_flutter/models/finance/bonus.dart';
import 'package:personnel_management_flutter/screens/finance/bonus/bonus_details.dart';
import 'package:personnel_management_flutter/widgets/button_add.dart';
import 'package:personnel_management_flutter/screens/finance/bonus/bonus_add.dart';

class BonusListScreen extends StatefulWidget {
  final DateTime? filterDate;
  const BonusListScreen({
    super.key,
    this.filterDate,
  });

  @override
  State<BonusListScreen> createState() => _BonusListScreenState();
}

class _BonusListScreenState extends State<BonusListScreen> {
  late Box<Bonus> _bonusBox;

  @override
  void initState() {
    super.initState();
    _bonusBox = Hive.box<Bonus>('bonuses');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!Hive.isBoxOpen('bonuses')) {
      return Center(child: CircularProgressIndicator());
    }
    final allItems = _bonusBox.values.toList();
    final filteredItems = allItems.where((bonus) {
      if (widget.filterDate == null) {
        return true;
      }
      return _isSameDay(bonus.date, widget.filterDate!);
    }).toList();

    return Stack(
      children: [
        ListView.builder(
          padding: EdgeInsets.only(top: 32),
          itemCount: filteredItems.length,
          itemBuilder: (context, index) {
            final bonus = filteredItems[index];
            if (bonus == null) return SizedBox();

            return InkWell(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BonusDetailsScreen(bonus: bonus),
                  ),
                );

                if (result == true) {
                  setState(() {});
                }
              },
              child: Card(
                margin: EdgeInsets.only(bottom: 16),
                color: Color(0xFFF2F5F7),
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bonus.info,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Color(0xFF252525),
                        ),
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          SvgPicture.asset('assets/svg/ellipse.svg'),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              DateFormat("d MMMM y", "ru_RU")
                                  .format(bonus.date),
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF818181),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          SvgPicture.asset('assets/svg/ellipse.svg'),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              bonus.employeeName,
                              style: TextStyle(
                                fontSize: 14,
                                height: 1.6,
                                color: Color(0xFF818181),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        Positioned(
          bottom: 0,
          right: 4,
          child: ButtonAdd(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const BonusAddScreen(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

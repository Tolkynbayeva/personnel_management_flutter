import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:personnel_management_flutter/models/finance/reprimand.dart';
import 'package:personnel_management_flutter/screens/finance/reprimand/reprimand_details.dart';
import 'package:personnel_management_flutter/widgets/button_add.dart';
import 'package:personnel_management_flutter/screens/finance/reprimand/reprimand_add.dart';

class ReprimandListScreen extends StatefulWidget {
  final DateTime? filterDate;

  const ReprimandListScreen({
    super.key,
    this.filterDate,
  });

  @override
  State<ReprimandListScreen> createState() => _ReprimandListScreenState();
}

class _ReprimandListScreenState extends State<ReprimandListScreen> {
  late Box<Reprimand> _reprimandBox;

  @override
  void initState() {
    super.initState();
    _reprimandBox = Hive.box<Reprimand>('reprimands');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!Hive.isBoxOpen('reprimands')) {
      return Center(child: CircularProgressIndicator());
    }
    final allItems = _reprimandBox.values.toList();
    final filteredItems = allItems.where((reprimand) {
      if (widget.filterDate == null) {
        return true;
      }
      return _isSameDay(reprimand.date, widget.filterDate!);
    }).toList();

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 24),
          child: ListView.builder(
            itemCount: filteredItems.length,
            itemBuilder: (context, index) {
              final reprimand = filteredItems[index];
              if (reprimand == null) return SizedBox();

              return InkWell(
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ReprimandDetailsScreen(reprimand: reprimand),
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
                          reprimand.info,
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
                                    .format(reprimand.date),
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
                                reprimand.employeeName,
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
        ),
        Positioned(
          bottom: 0,
          right: 4,
          child: ButtonAdd(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ReprimandAddScreen(),
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

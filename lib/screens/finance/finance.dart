import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personnel_management_flutter/screens/finance/bonus/bonus.dart';
import 'package:personnel_management_flutter/screens/finance/reprimand/reprimand.dart';
import 'package:personnel_management_flutter/screens/finance/salary/salary.dart';

class FinanceScreen extends StatefulWidget {
  final DateTime? filterDate;
  final void Function()? onClearFilter;

  const FinanceScreen({
    super.key,
    this.filterDate,
    this.onClearFilter,
  });

  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {
  int _selectedIndex = 0;
  final List<String> _tabs = ['Выговор', 'Премия', 'Зарплата'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 16),
      child: Column(
        children: [
          Row(
            children: List.generate(_tabs.length, (index) {
              return Expanded(child: _buildTab(_tabs[index], index));
            }),
          ),
          if (widget.filterDate != null)
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 12),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDEE5FF),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      Text(
                        DateFormat('dd.MM.yyyy').format(widget.filterDate!),
                        style: const TextStyle(
                          color: Color(0xFF2253F6),
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: widget.onClearFilter,
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF2253F6),
                          ),
                          padding: const EdgeInsets.all(4),
                          child: Icon(
                            Icons.close,
                            size: 9,
                            color: Color(0xFFDEE5FF),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          Expanded(
            child: _buildTabContent(_selectedIndex),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final bool isSelected = (_selectedIndex == index);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? const Color(0xFF2253F6) : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.4,
            color: isSelected ? const Color(0xFF252525) : Color(0xFF818181),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(int index) {
    switch (index) {
      case 0:
        return ReprimandScreen(filterDate: widget.filterDate);
      case 1:
        return BonusScreen(filterDate: widget.filterDate);
      case 2:
        return SalaryScreen();
      default:
        return const SizedBox();
    }
  }
}

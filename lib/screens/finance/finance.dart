import 'package:flutter/material.dart';
import 'package:personnel_management_flutter/screens/finance/bonus/bonus.dart';
import 'package:personnel_management_flutter/screens/finance/reprimand/reprimand.dart';

class FinanceScreen extends StatefulWidget {
  const FinanceScreen({super.key});

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
        return ReprimandScreen();
      case 1:
        return BonusScreen();
      case 2:
        return _buildZarplataContent();
      default:
        return const SizedBox();
    }
  }

  // Widget _buildVygovorContent() {
  //   return Center(
  //     child: Text('Тут будут «Выговор»'),
  //   );
  // }

  Widget _buildPremiyaContent() {
    return Center(
      child: Text('Тут будут «Премия»'),
    );
  }

  Widget _buildZarplataContent() {
    return Center(
      child: Text('Тут будут «Зарплата»'),
    );
  }
}

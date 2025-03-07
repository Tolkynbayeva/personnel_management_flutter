import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:personnel_management_flutter/screens/chart.dart';
import 'package:personnel_management_flutter/screens/employee/employees.dart';
import 'package:personnel_management_flutter/screens/finance.dart';
import 'package:personnel_management_flutter/screens/news/news.dart';
import 'package:personnel_management_flutter/screens/settings.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    EmployeesScreen(),
    FinanceScreen(),
    ChartScreen(),
    NewsScreen(),
    SettingsScreen(),
  ];

  final List<String> _titles = [
    'Сотрудники',
    'Финансы',
    'График',
    'Новости',
    'Настройки',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Color _colorForIndex(int index) {
    return _currentIndex == index
        ? const Color(0xFF2253F6)
        : const Color(0xFF818181);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // backgroundColor: Colors.white,
      appBar: AppBar(
       // backgroundColor: Colors.white,
        centerTitle: false,
        title: Text(
          _titles[_currentIndex],
          style: TextStyle(
            fontSize: 34,
            height: 1.2,
            fontWeight: FontWeight.w700,
            color: Color(0xFF252525),
          ),
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFFF2F5F7),
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            label: '',
            icon: Column(
              children: [
                SvgPicture.asset(
                  'assets/svg/employees.svg',
                  colorFilter: ColorFilter.mode(
                    _colorForIndex(0),
                    BlendMode.srcIn,
                  ),
                  width: 24,
                  height: 24,
                ),
                SizedBox(height: 4),
                Text(
                  'Сотрудники',
                  style: TextStyle(
                    color: _colorForIndex(0),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: Column(
              children: [
                SvgPicture.asset(
                  'assets/svg/finance.svg',
                  colorFilter: ColorFilter.mode(
                    _colorForIndex(1),
                    BlendMode.srcIn,
                  ),
                  width: 24,
                  height: 24,
                ),
                SizedBox(height: 4),
                Text(
                  'Финансы',
                  style: TextStyle(
                    color: _colorForIndex(1),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: Column(
              children: [
                SvgPicture.asset(
                  'assets/svg/chart.svg',
                  colorFilter: ColorFilter.mode(
                    _colorForIndex(2),
                    BlendMode.srcIn,
                  ),
                  width: 24,
                  height: 24,
                ),
                SizedBox(height: 4),
                Text(
                  'График',
                  style: TextStyle(
                    color: _colorForIndex(2),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: Column(
              children: [
                SvgPicture.asset(
                  'assets/svg/news.svg',
                  colorFilter: ColorFilter.mode(
                    _colorForIndex(3),
                    BlendMode.srcIn,
                  ),
                  width: 24,
                  height: 24,
                ),
                SizedBox(height: 4),
                Text(
                  'Новости',
                  style: TextStyle(
                    color: _colorForIndex(3),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: Column(
              children: [
                SvgPicture.asset(
                  'assets/svg/settings.svg',
                  colorFilter: ColorFilter.mode(
                    _colorForIndex(4),
                    BlendMode.srcIn,
                  ),
                  width: 24,
                  height: 24,
                ),
                SizedBox(height: 4),
                Text(
                  'Настройки',
                  style: TextStyle(
                    color: _colorForIndex(4),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

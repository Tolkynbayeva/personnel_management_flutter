import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 40, horizontal: 16),
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            'Настройка профиля',
            style: TextStyle(
              fontSize: 16,
              height: 1.4,
              color: Color(0xFF252525),
            ),
          ),
          trailing: Icon(
            Icons.chevron_right,
            size: 34,
            color: Color(0xFFDEDEDF),
          ),
          onTap: () {},
        ),
        Divider(
          thickness: 0.5,
          color: Color(0x40ADADAF),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            'Обратная связь',
            style: TextStyle(
              fontSize: 16,
              height: 1.4,
              color: Color(0xFF252525),
            ),
          ),
          trailing: Icon(
            Icons.chevron_right,
            size: 34,
            color: Color(0xFFDEDEDF),
          ),
          onTap: () {},
        ),
        Divider(
          thickness: 0.5,
          color: Color(0x40ADADAF),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            'Информация',
            style: TextStyle(
              fontSize: 16,
              height: 1.4,
              color: Color(0xFF252525),
            ),
          ),
          trailing: Icon(
            Icons.chevron_right,
            size: 34,
            color: Color(0xFFDEDEDF),
          ),
          onTap: () {},
        ),
        Divider(
          thickness: 0.5,
          color: Color(0x40ADADAF),
        ),
      ],
    );
  }
}

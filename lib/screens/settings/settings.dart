import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:personnel_management_flutter/models/user_profile/user_profile.dart';
import 'package:personnel_management_flutter/screens/settings/account.dart';
import 'package:personnel_management_flutter/screens/settings/feedback.dart';
import 'package:personnel_management_flutter/screens/settings/information.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late Box<UserProfile> _userProfileBox;

  @override
  void initState() {
    super.initState();
    _userProfileBox = Hive.box<UserProfile>('user_profile');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _userProfileBox.listenable(keys: ['user_profile']),
      builder: (context, Box<UserProfile> box, _) {
        final UserProfile? userProfile = _userProfileBox.get('user_profile');

        return ListView(
          padding: EdgeInsets.symmetric(vertical: 40, horizontal: 16),
          children: [
            if (userProfile != null) ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      color: Color(0xFFF2F5F7),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0D000000),
                          offset: Offset(0, 2),
                          blurRadius: 6,
                        ),
                      ],
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: userProfile.avatarPath.isNotEmpty
                            ? FileImage(File(userProfile.avatarPath))
                            : AssetImage('assets/images/default_avatar.png')
                                as ImageProvider,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '${userProfile.name} ${userProfile.surname}',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      color: Color(0xFF252525),
                    ),
                  ),
                  SizedBox(height: 60),
                ],
              )
            ],
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
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => AccountScreen(),
                  ),
                );
              },
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
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => FeedbackScreen(),
                  ),
                );
              },
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
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => InformationScreen(),
                  ),
                );
              },
            ),
            Divider(
              thickness: 0.5,
              color: Color(0x40ADADAF),
            ),
          ],
        );
      },
    );
  }
}

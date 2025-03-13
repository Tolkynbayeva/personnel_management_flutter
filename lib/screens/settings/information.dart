import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InformationScreen extends StatelessWidget {
  const InformationScreen({super.key});

  static const _privacyPolicyUrl = 'https://example.com/privacy';
  static const _userAgreementUrl = 'https://example.com/user_agreement';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Информация',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 17,
            height: 1.3,
            color: Color(0xFF252525),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 40, horizontal: 16),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Политика конфиденциальности',
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
              onTap: () => _launchUrl(_privacyPolicyUrl),
            ),
            Divider(
              thickness: 0.5,
              color: Color(0x40ADADAF),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Пользовательское соглашение',
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
              onTap: () => _launchUrl(_userAgreementUrl),
            ),
            Divider(
              thickness: 0.5,
              color: Color(0x40ADADAF),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Не получается открыть $url');
    }
  }
}

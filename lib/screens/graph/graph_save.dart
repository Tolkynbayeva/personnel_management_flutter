import 'package:flutter/material.dart';
import 'package:personnel_management_flutter/screens/tabs.dart';
import 'package:personnel_management_flutter/widgets/button_back.dart';

class GraphSaveScreen extends StatelessWidget {
  const GraphSaveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/saved.png'),
            const SizedBox(height: 24),
            Text(
              'Сохранено!',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                height: 1.1,
                color: Color(0xFF252525),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 219,
              child: Text(
                'Параметры успешно сохранены.',
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.4,
                  color: Color(0xFF818181),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 31),
            ButtonBack(
              title: 'К графику',
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TabsScreen(
                      initialIndex: 2,
                    ),
                  ),
                  (route) => false,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

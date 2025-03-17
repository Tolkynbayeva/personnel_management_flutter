import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:personnel_management_flutter/models/employee/employee.dart';
import 'package:personnel_management_flutter/models/feedback/feedback.dart';
import 'package:personnel_management_flutter/models/finance/bonus.dart';
import 'package:personnel_management_flutter/models/finance/reprimand.dart';
import 'package:personnel_management_flutter/models/graph/graph.dart';
import 'package:personnel_management_flutter/models/user_profile/user_profile.dart';
import 'package:personnel_management_flutter/screens/tabs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(EmployeeAdapter());
  Hive.registerAdapter(ReprimandAdapter());
  Hive.registerAdapter(BonusAdapter());
  Hive.registerAdapter(FeedbackModelAdapter());
  Hive.registerAdapter(UserProfileAdapter());
  Hive.registerAdapter(GraphAdapter());
  await Hive.openBox<Employee>('employees');
  await Hive.openBox<Reprimand>('reprimands');
  await Hive.openBox<Bonus>('bonuses');
  await Hive.openBox<FeedbackModel>('feedbacks');
  await Hive.openBox<UserProfile>('user_profile');
  await Hive.openBox<Graph>('graphs');
  
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (ctx) => const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFF2F5F7),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF2F5F7),
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF252525)),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
      ),
      home: TabsScreen(),
    );
  }
}

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:niyama/models/habit.dart';
import 'package:niyama/navigation_page.dart';
import 'package:niyama/models/boxes.dart';
import 'package:niyama/pages/auth_page.dart';
import 'package:niyama/services/noti_service.dart';
import 'package:niyama/theme/dark_theme.dart';
import 'package:niyama/theme/light_theme.dart';
import 'package:niyama/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/standalone.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));

  await Hive.initFlutter();
  Hive.registerAdapter(HabitAdapter());
  boxHabit = await Hive.openBox<Habit>('habit');
  await Hive.openBox<String>('dateBox');
  await Hive.openBox<String>('profile');
  await Hive.openBox<bool>('isDarkTheme');
  boxToDo = await Hive.openBox<String>('to-do');
  await Hive.openBox<int>('themeColor');
  await Hive.openBox<bool>('auth');

  await AndroidAlarmManager.initialize();

  NotiService().initNotification();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  final Box<bool> authBox = Hive.box<bool>('auth');

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = authBox.get('isAuthEnabled', defaultValue: false)!;
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      builder: (context, _) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        return MaterialApp(
          home: isEnabled ? AuthPage() : NavigationPage(),
          themeMode: themeProvider.themeMode,
          theme: lightThemeData,
          darkTheme: darkThemeData,
        );
      },
    );
  }
}

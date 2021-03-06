import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:evento/model/eventData.dart';
import 'package:evento/ui/countdownSystem.dart';
import 'package:evento/ui/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'model/event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(EventAdapter());

  await AndroidAlarmManager.initialize();
  runApp(ChangeNotifierProvider(create: (_) => EventData(), child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Color(0xffFCA532),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          accentColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.white)),
      title: "Evento",
      home: CustomSplashScreen(),
    );
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}

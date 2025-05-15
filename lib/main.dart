import 'package:anastagram/Models/profile.dart';
import 'package:anastagram/Models/userdata.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'Pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(ProfileAdapter());
  Hive.registerAdapter(UserDataAdapter());

  await Hive.openBox<UserData>('userData');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: Colors.blue[100],
          cursorColor: Colors.blue[800],
          selectionHandleColor: Colors.blue[800],
        ),
      ),
      home: HomePage(),
    );
  }
}

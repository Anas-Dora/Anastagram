import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Models/user_data.dart';
import 'Pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textSelectionTheme: TextSelectionThemeData(
            selectionColor: Colors.blue[100],
            cursorColor: Colors.blue[800],
            selectionHandleColor: Colors.blue[800],
          ),
        ),
        home: HomePage(),
      ),
    );
  }
}

import 'package:anastagram/Pages/home_page.dart';
import 'package:anastagram/app/theme/app_theme.dart';
import 'package:flutter/material.dart';

class AnastagramApp extends StatelessWidget {
  const AnastagramApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const HomePage(),
    );
  }
}


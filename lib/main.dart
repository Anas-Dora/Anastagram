import 'package:anastagram/app/app.dart';
import 'package:anastagram/data/profile.dart';
import 'package:anastagram/data/userdata.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(ProfileAdapter());
  Hive.registerAdapter(UserDataAdapter());

  await Hive.openBox<UserData>('userData');
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const AnastagramApp();
  }
}

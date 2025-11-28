import 'package:flutter/material.dart';

import 'main_menu/menu.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MuToolUI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xff19283b),
            brightness: Brightness.dark,
            primary: Colors.blue
        ),
      ),
      home: const Menu(),
    );
  }
}

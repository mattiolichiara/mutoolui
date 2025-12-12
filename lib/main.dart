import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import 'main_menu/menu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  //
  WindowOptions windowOptions = WindowOptions(
    size: Size(1280, 720),
    minimumSize: Size(1280, 720),
    center: true,
    skipTaskbar: false,
    title: "MuTool UI",
    fullScreen: false,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    // await windowManager.setMaximizable(false);
    // await windowManager.setBackgroundColor(const Color(0xff19283b));
    // await windowManager.setResizable(false);
    await windowManager.show();
    await windowManager.focus();
  });
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

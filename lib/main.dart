import 'package:flutter/material.dart';

import 'screens/splash/splash_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const UpcycleApp());
}

class UpcycleApp extends StatelessWidget {
  const UpcycleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Upcycle Project Tracker',
      theme: AppTheme.light,
      home: const SplashScreen(),
    );
  }
}

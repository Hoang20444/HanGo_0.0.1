import 'package:flutter/material.dart';
import 'presentation/screens/login/login_screen.dart';
import 'presentation/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HanGo E-Learning',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: LoginScreen(),
    );
  }
}

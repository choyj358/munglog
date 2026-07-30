import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_theme.dart';
import 'package:frontend/features/auth/presentation/welcome_screen.dart';

class MungLogApp extends StatelessWidget {
  const MungLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '멍로그',
      theme: AppTheme.light,
      home: const WelcomeScreen(),
    );
  }
}

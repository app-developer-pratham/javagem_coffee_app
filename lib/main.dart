import 'package:flutter/material.dart';
import 'package:javagem_coffee_app/core/app_theme.dart';
import 'package:javagem_coffee_app/screens/onboarding_screen.dart';

void main() {
  runApp(const CoffeeApp());
}

class CoffeeApp extends StatelessWidget {
  const CoffeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      home: const OnboardingScreen(),
    );
  }
}

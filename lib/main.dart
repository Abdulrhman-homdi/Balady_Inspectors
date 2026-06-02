import 'package:flutter/material.dart';
import 'core/theme_notifier.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const IncidentMonitoringApp());
}

class IncidentMonitoringApp extends StatelessWidget {
  const IncidentMonitoringApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, themeMode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'نظام مراقبة البلاغات',
          themeMode: themeMode,
          theme: ThemeData(
            fontFamily: 'IBMPlexSansArabic',
            primaryColor: const Color(0xFF2D9373),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF2D9373),
              brightness: Brightness.light,
            ),
          ),
          darkTheme: ThemeData(
            fontFamily: 'IBMPlexSansArabic',
            primaryColor: const Color(0xFF2D9373),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF2D9373),
              brightness: Brightness.dark,
            ),
          ),
          home: const SplashScreen(),
        );
      },
    );
  }
}

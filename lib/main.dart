import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const IncidentMonitoringApp());
}

class IncidentMonitoringApp extends StatelessWidget {
  const IncidentMonitoringApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'نظام مراقبة البلاغات',
      theme: ThemeData(
        // استخدم نفس الاسم (family) الذي عرفته في pubspec
        fontFamily: 'IBMPlexSansArabic',
        primaryColor: const Color(0xFF2D9373),
      ),
      home: const SplashScreen(), // نقطة الانطلاق
    );
  }
}

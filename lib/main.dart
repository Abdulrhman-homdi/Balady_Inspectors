import 'package:flutter/material.dart';
import 'core/theme_notifier.dart';
import 'core/app_theme.dart';
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
          title: 'Balady Inspector | مراقب بلدي',
          themeMode: themeMode,
          theme: buildLightTheme(),
          darkTheme: buildDarkTheme(),
          home: const SplashScreen(),
        );
      },
    );
  }
}

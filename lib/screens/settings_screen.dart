import 'package:flutter/material.dart';
import '../core/theme_notifier.dart';
import 'login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'الإعدادات',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: 'IBMPlexSansArabic',
            color: Color(0xFF111827),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_ios, color: Color(0xFF111827), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'المظهر',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'IBMPlexSansArabic',
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _ThemeSelector(),
                  ],
                ),
              ),
            ),
            _LogoutButton(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _ThemeSelector extends StatefulWidget {
  @override
  State<_ThemeSelector> createState() => _ThemeSelectorState();
}

class _ThemeSelectorState extends State<_ThemeSelector> {
  int _selected = themeNotifier.value == ThemeMode.system
      ? 0
      : themeNotifier.value == ThemeMode.light
          ? 1
          : 2;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _ThemeOption(
            icon: Icons.phone_android,
            title: 'حسب النظام',
            subtitle: 'يتبع نمط الهاتف تلقائياً',
            index: 0,
            selected: _selected == 0,
            onTap: () => _select(0),
          ),
          const Divider(height: 24, color: Color(0xFFF3F4F6)),
          _ThemeOption(
            icon: Icons.sunny,
            title: 'فاتح',
            subtitle: 'نمط فاتح طوال الوقت',
            index: 1,
            selected: _selected == 1,
            onTap: () => _select(1),
          ),
          const Divider(height: 24, color: Color(0xFFF3F4F6)),
          _ThemeOption(
            icon: Icons.dark_mode,
            title: 'داكن',
            subtitle: 'نمط داكن طوال الوقت',
            index: 2,
            selected: _selected == 2,
            onTap: () => _select(2),
          ),
        ],
      ),
    );
  }

  void _select(int index) {
    setState(() => _selected = index);
    switch (index) {
      case 0:
        themeNotifier.value = ThemeMode.system;
      case 1:
        themeNotifier.value = ThemeMode.light;
      case 2:
        themeNotifier.value = ThemeMode.dark;
    }
  }
}

class _ThemeOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final int index;
  final bool selected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.index,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Radio<int>(
              value: index,
              groupValue: selected ? index : -1,
              onChanged: (_) => onTap(),
              activeColor: const Color(0xFF2D9373),
            ),
            Icon(icon, color: const Color(0xFF6B7280), size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'IBMPlexSansArabic',
                      color: Color(0xFF111827),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'IBMPlexSansArabic',
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => LoginScreen()),
              (route) => false,
            );
          },
          icon: const Icon(Icons.logout, color: Colors.white, size: 20),
          label: const Text(
            'تسجيل الخروج',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              fontFamily: 'IBMPlexSansArabic',
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFEF4444),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
        ),
      ),
    );
  }
}

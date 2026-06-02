import 'package:flutter/material.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: Column(
          children: [
            const _TopBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: const Column(
                  children: [
                    SizedBox(height: 16),
                    _ProfileCard(),
                    SizedBox(height: 16),
                    _KpiRow(),
                    SizedBox(height: 24),
                    _DataSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SettingsScreen(),
                      ),
                    );
                  },
                  child: const Icon(
                    Icons.settings_outlined,
                    color: Color(0xFF6B7280),
                    size: 26,
                  ),
                ),
                const Spacer(),
                const Text(
                  'معلوماتي',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'IBMPlexSansArabic',
                    color: Color(0xFF111827),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              decoration: InputDecoration(
                hintText: 'ابحث عن البلاغ',
                hintStyle: TextStyle(
                  fontFamily: 'IBMPlexSansArabic',
                  fontSize: 14,
                  color: const Color(0xFF9CA3AF),
                ),
                suffixIcon: Icon(
                  Icons.search,
                  color: const Color(0xFF9CA3AF),
                ),
                filled: true,
                fillColor: const Color(0xFFF3F4F6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
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
          CircleAvatar(
            radius: 40,
            backgroundColor: const Color(0xFF2D9373).withOpacity(0.1),
            child: Icon(
              Icons.person,
              size: 40,
              color: const Color(0xFF2D9373).withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'تركي بن عبدالرحمن',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              fontFamily: 'IBMPlexSansArabic',
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'رقم الموظف : 11022',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'IBMPlexSansArabic',
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
}

class _KpiRow extends StatelessWidget {
  const _KpiRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _KpiCard(
            title: 'متوسط وقت الاستجابة الأسبوعي',
            value: '5.2',
            unit: 'يوم',
            footer: 'من 20 بلاغ',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _KpiCard(
            title: 'معدل الإغلاق اليومي',
            value: '52',
            unit: '%',
            footer: 'من 20 بلاغ',
          ),
        ),
      ],
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final String footer;

  const _KpiCard({
    required this.title,
    required this.value,
    required this.unit,
    required this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'IBMPlexSansArabic',
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                unit,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'IBMPlexSansArabic',
                  color: Color(0xFF2D9373),
                ),
              ),
              const SizedBox(width: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'IBMPlexSansArabic',
                  color: Color(0xFF2D9373),
                  height: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            footer,
            style: const TextStyle(
              fontSize: 11,
              fontFamily: 'IBMPlexSansArabic',
              color: Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }
}

class _DataSection extends StatelessWidget {
  const _DataSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          'بياناتي',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: 'IBMPlexSansArabic',
            color: Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 12),
        _ContactCard(),
        const SizedBox(height: 12),
        _AddressCard(),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _ContactCard extends StatelessWidget {
  const _ContactCard();

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
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              const Spacer(),
              Icon(
                Icons.phone_outlined,
                size: 20,
                color: const Color(0xFF2D9373),
              ),
              const SizedBox(width: 8),
              const Text(
                'أرقام التواصل الشخصية',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'IBMPlexSansArabic',
                  color: Color(0xFF111827),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFF3F4F6)),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text(
                '055 444 8888',
                textDirection: TextDirection.ltr,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'IBMPlexSansArabic',
                  color: Color(0xFF111827),
                ),
              ),
              const Spacer(),
              const Text(
                'الرقم المسجل',
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'IBMPlexSansArabic',
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard();

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
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              const Spacer(),
              Icon(
                Icons.location_on_outlined,
                size: 20,
                color: const Color(0xFF2D9373),
              ),
              const SizedBox(width: 8),
              const Text(
                'العنوان الوطني',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'IBMPlexSansArabic',
                  color: Color(0xFF111827),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFF3F4F6)),
          const SizedBox(height: 12),
          const Row(
            children: [
              Expanded(
                child: Text(
                  'MBAA88888888 ,حي شاطئ, 3434 الكلفان',
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'IBMPlexSansArabic',
                    color: Color(0xFF111827),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Text(
                'العنوان الأول',
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'IBMPlexSansArabic',
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

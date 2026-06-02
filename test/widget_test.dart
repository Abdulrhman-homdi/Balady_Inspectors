import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// تأكد أن هذا المسار يطابق اسم مشروعك
import 'package:incident_monitoring_system/main.dart';

void main() {
  testWidgets('Splash Screen smoke test', (WidgetTester tester) async {
    // IncidentMonitoringApp بناء التطبيق باسمه الجديد
    await tester.pumpWidget(const IncidentMonitoringApp());

    // التحقق من وجود نصوص شاشة السبلاش بدلاً من العداد
    expect(find.text('اسم الأمانة باللغة العربية'), findsOneWidget);
    expect(find.text('Name of Municipality in English'), findsOneWidget);
  });
}

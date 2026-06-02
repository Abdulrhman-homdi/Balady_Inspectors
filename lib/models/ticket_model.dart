import 'package:flutter/material.dart';

class Ticket {
  final String id;
  final String ticketId;
  final String title;
  final String category;
  final String status;
  final String imageUrl;
  final String description;

  const Ticket({
    required this.id,
    required this.ticketId,
    required this.title,
    required this.category,
    required this.status,
    this.imageUrl = '',
    this.description = '',
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['_id'] ?? '',
      ticketId: json['ticketId'] ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      status: json['status'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      description: json['description'] ?? '',
    );
  }

  static Color colorForStatus(String status) {
    switch (status) {
      case 'جديد':
        return const Color(0xFF2563EB);
      case 'قيد المعالجة':
        return const Color(0xFFF59E0B);
      case 'متأخر':
        return const Color(0xFFDC2626);
      case 'مصعد':
        return const Color(0xFF7C3AED);
      case 'منتهي':
        return const Color(0xFF16A34A);
      default:
        return const Color(0xFF6B7280);
    }
  }

  static List<String> buttonsForStatus(String status) {
    switch (status) {
      case 'جديد':
        return ['تفاصيل البلاغ', 'مباشرة البلاغ'];
      case 'قيد المعالجة':
        return ['تفاصيل البلاغ', 'متابعة الإجراءات'];
      case 'متأخر':
        return ['مباشرة الحالة', 'مباشرة البلاغ حالا'];
      case 'مصعد':
        return ['متابعة حالة التصعيد'];
      case 'منتهي':
        return ['تفاصيل البلاغ'];
      default:
        return ['تفاصيل البلاغ'];
    }
  }
}

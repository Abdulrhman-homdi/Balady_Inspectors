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
        return const Color(0xFF3B82F6);
      case 'قيد المعالجة':
        return const Color(0xFFF59E0B);
      case 'متأخر':
        return const Color(0xFFEF4444);
      case 'مصعد':
        return const Color(0xFF8B5CF6);
      case 'منتهي':
        return const Color(0xFF22C55E);
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

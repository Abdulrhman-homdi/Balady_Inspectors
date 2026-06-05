import 'package:flutter/material.dart';

class TicketLocation {
  final String address;
  final String district;
  final double lat;
  final double lng;
  final String landmark;

  const TicketLocation({
    this.address = '',
    this.district = '',
    this.lat = 0,
    this.lng = 0,
    this.landmark = '',
  });

  factory TicketLocation.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const TicketLocation();
    return TicketLocation(
      address: json['address'] ?? '',
      district: json['district'] ?? '',
      lat: (json['lat'] ?? 0).toDouble(),
      lng: (json['lng'] ?? 0).toDouble(),
      landmark: json['landmark'] ?? '',
    );
  }
}

class ProgressEntry {
  final String action;
  final String details;
  final String assignee;
  final DateTime? createdAt;

  const ProgressEntry({
    this.action = '',
    this.details = '',
    this.assignee = '',
    this.createdAt,
  });

  factory ProgressEntry.fromJson(Map<String, dynamic> json) {
    return ProgressEntry(
      action: json['action'] ?? '',
      details: json['details'] ?? '',
      assignee: json['assignee'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }
}

class Ticket {
  final String id;
  final String ticketId;
  final String title;
  final String category;
  final String status;
  final String imageUrl;
  final String description;
  final TicketLocation? location;
  final List<ProgressEntry> progressLog;

  const Ticket({
    required this.id,
    required this.ticketId,
    required this.title,
    required this.category,
    required this.status,
    this.imageUrl = '',
    this.description = '',
    this.location,
    this.progressLog = const [],
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    final progressList = (json['progressLog'] as List<dynamic>?)
            ?.map((e) => ProgressEntry.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    return Ticket(
      id: json['_id'] ?? '',
      ticketId: json['ticketId'] ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      status: json['status'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      description: json['description'] ?? '',
      location: TicketLocation.fromJson(json['location'] as Map<String, dynamic>?),
      progressLog: progressList,
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

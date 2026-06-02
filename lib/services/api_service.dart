import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/ticket_model.dart';

class ApiService {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://127.0.0.1:5000/api/tickets';
    }
    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android) {
      return 'http://192.168.0.135:5000/api/tickets';
    }
    return 'http://127.0.0.1:5000/api/tickets';
  }

  static Future<List<Ticket>> fetchTickets() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final List<dynamic> data = body['data'] as List<dynamic>;
      return data
          .map((item) => Ticket.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    throw Exception('فشل تحميل البلاغات - ${response.statusCode}');
  }
}

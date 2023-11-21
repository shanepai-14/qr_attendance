import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SmsService {
  static const String apiKey = '2HuLFZncBt3Skrfh17WJoQWQqT8';
  static const String apiSecret = '2bk9HVfZSsd3E1879ynqy6YsNL7IU9UqCvCIDFmt';
  // static const String senderId = 'YOUR_SENDER_ID';
  static const String apiUrl = 'https://api.movider.co/v1/sms';

  Future<void> sendSms(String phoneNumber, String message) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $apiKey:$apiSecret',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'to': phoneNumber,
        'message': message,
      }),
    );

    if (response.statusCode == 200) {
      print('SMS sent successfully');
    } else {
      print('Failed to send SMS. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }
}

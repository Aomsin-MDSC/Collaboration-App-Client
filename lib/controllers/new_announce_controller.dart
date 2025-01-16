import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class NewAnnounceController extends GetxController {
  static NewAnnounceController get instance => Get.find();

  final announceTitle = TextEditingController();
  final announceText = TextEditingController();
  DateTime? selectedDate;

  Future<void> createAnnounce(projectId) async {
    try {
      final url = Uri.parse('http://10.24.8.16:5263/api/CreateAnnounces');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'announce_title': announceTitle.text,
          'announce_text': announceText.text,
          'project_id': projectId,
          'announce_date': selectedDate!.toIso8601String(),
        }),

      );


      if (response.statusCode == 200) {
        print("Announce created successfully!");
      } else {
        print("Failed to create announce: ${response.body}");
        print(jsonEncode({
          'announce_title': announceTitle.text,
          'announce_text': announceText.text,
          'project_id': projectId,
          'announce_date': selectedDate!.toIso8601String(),
        }));
      }
    } catch (e) {
      print("Something went wrong: $e");
    }
  }
}
import 'dart:convert';

import 'package:collaboration_app_client/controllers/announce_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class NewAnnounceController extends GetxController {
  static NewAnnounceController get instance => Get.find();

  final AnnounceController controller = Get.find<AnnounceController>();
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
        await controller.fetchAnnounce(projectId);
        print("Announce created successfully!");
      } else {
        print("Failed to create announce: ${response.body}");
      }
    } catch (e) {
      print("Something went wrong: $e");
    }
  }
}
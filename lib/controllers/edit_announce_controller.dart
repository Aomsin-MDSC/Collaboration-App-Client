import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class EditAnnounceController extends GetxController {
  static EditAnnounceController get instance => Get.find();

  final editannouncename = TextEditingController();
  final editannouncedetail = TextEditingController();
  DateTime? editselectedDate;

  Future<void> updateAnnounce(announceId) async {
    try {
      final url = Uri.parse('http://10.24.8.16:5263/api/UpdateAnnounce/$announceId');

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'announce_title': editannouncename.text,
          'announce_text': editannouncedetail.text,
          'announce_date': editselectedDate!.toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        print("Announce updated successfully!");
      } else {
        print("Failed to updated announce: ${response.body}");
      }
    } catch (e) {
      throw("Something went wrong: $e");
    }
  }

  Future<void> deleteAnnounce(announceId) async {
    try {
      final url = Uri.parse('http://10.24.8.16:5263/api/DeleteAnnounce/$announceId');

      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print("Announce deleted successfully!");
      } else {
        print("Failed to deleted announce: ${response.body}");
      }
    } catch (e) {
      throw("Something went wrong: $e");
    }
  }
}
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'new_project_controller.dart';

class NewTagController extends GetxController {
  static NewTagController get instance => Get.find();

  final controller = Get.put(NewProjectController());

  final tagname = TextEditingController(); //get tag name
  String tagcolor = "#808080";

  void changeColor(Color color) {
    tagcolor = "#${color.value.toRadixString(16).substring(2)}";
    update();
  }

  void updateTagName(String name) {
    tagname.text = name;
      update();
  }

  Color get currenttagColor =>
      Color(int.parse(tagcolor.replaceFirst('#', '0xff')));

  Future<void> createTag() async {
    try {
      final url = Uri.parse('http://10.24.8.16:5263/api/CreateTag');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'tag_name': tagname.text,
          'tag_color': tagcolor,
        }),
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Tag created successfully!");
        await controller.fetchTags();
      } else {
        Get.snackbar("Error", "Failed to create tag: ${response.body}");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    }
  }
}

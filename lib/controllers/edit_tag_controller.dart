import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'new_project_controller.dart';

class EditTagController extends GetxController {
  static EditTagController get instance => Get.find();

  final controller = Get.put(NewProjectController());

  final edittagname = TextEditingController(); //get tag name
  String tagcolor = "#808080";

  void editchangeColor(Color color) {
    tagcolor = "#${color.value.toRadixString(16).substring(2)}";
    update();
  }

  void editupdateTagName(String name) {
    edittagname.text = name;
    update();
  }

  Color get editcurrenttagColor =>
      Color(int.parse(tagcolor.replaceFirst('#', '0xff')));

  Future<void> updateTag(int tagId) async {
    try {
      final url = Uri.parse('http://10.24.8.16:5263/api/UpdateTag/$tagId');

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'tag_name': edittagname.text.isNotEmpty
              ? edittagname.text
              : controller.tags
                  .firstWhere((element) => element.tagId == tagId)
                  .tagName,
          'tag_color': tagcolor,
        }),
      );

      if (response.statusCode == 200) {
        await controller.fetchTags();
        //Get.snackbar("Success", "Tag update successfully!");
      } else {
        Get.snackbar("Error", "Failed to update tag: ${response.body}");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    }
  }

  Future<void> deleteTag(int tagId) async {
    try {
      final response = await http.delete(
        Uri.parse('http://10.24.8.16:5263/api/DeleteTag/$tagId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        await controller.fetchTags();
        print('Tag deleted successfully');
        Get.snackbar("Success", "Tag deleted successfully");
      } else {
        print('Failed to delete tag');
        Get.snackbar("Error", "Failed to delete tag");
      }
    } catch (e) {
      print('Error deleting tag: $e');
      Get.snackbar("Error", "Something went wrong: $e");
    }
  }
}

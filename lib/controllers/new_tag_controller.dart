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


  Future<void> createTag({Function? onCompleted = null}) async {

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
        if(onCompleted != null) onCompleted();
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Created Tag Successfully.'),
              ],
            ),
            action: SnackBarAction(label: "OK", onPressed: () {}),
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
        await controller.fetchTags();
      }  if (response.statusCode == 400) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.warning, color: Colors.white),
                SizedBox(width: 8),
                Text('This tag name already exists.'),
              ],
            ),
            // behavior: SnackBarBehavior.floating,
            // margin: EdgeInsets.only(bottom: MediaQuery.of(Get.context!).size.height - 175, left: 15, right: 15),
            action: SnackBarAction(label: "OK", onPressed: () {}), //action
            backgroundColor: Colors.orange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.cancel, color: Colors.white),
              SizedBox(width: 8),
              Text('Create Tag Failed.'),
            ],
          ),
          // behavior: SnackBarBehavior.floating,
          // margin: EdgeInsets.only(bottom: MediaQuery.of(Get.context!).size.height - 175, left: 15, right: 15),
          action: SnackBarAction(label: "OK", onPressed: () {}), //action
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}

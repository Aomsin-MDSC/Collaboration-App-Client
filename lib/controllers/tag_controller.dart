import 'dart:convert';
import 'package:collaboration_app_client/models/tag_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class TagController extends GetxController {
  static TagController get instance => Get.find();

  var tag = <TagModel>[].obs;

  Future fetchTagMap(int tag_id) async {
    try {
      final response =
      await http.get(Uri.parse('http://10.24.8.16:5263/api/GetTags'));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        tag.value = jsonData.map((data) => TagModel.fromJson(data)).toList();
        tag.forEach((project) {
        });
      } else {
        throw Exception('Failed to load tags');
      }
    } catch (e) {
      print('Error fetching tags: $e');
    }
  }
}

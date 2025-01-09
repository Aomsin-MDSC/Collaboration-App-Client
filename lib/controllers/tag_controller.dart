import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class TagController extends GetxController {
  static TagController get instance => Get.find();

  var selected_tag_map = <String>[].obs;

  Future fetchTagMap(int tag_id) async {
    try {
      final response =
          await http.get(Uri.parse('http://10.24.8.16:5263/api/GetTags'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        // Filter tags where tag_id is 1
        final filteredData = data.where((e) => e['tag_id'] == tag_id).toList();

        selected_tag_map.value =
            filteredData.map((e) => e['tag_name'] as String).toList();
        return selected_tag_map.first;
      } else {
        throw Exception('Failed to load tags');
      }
    } catch (e) {
      print('Error fetching tags: $e');
    }
  }
}

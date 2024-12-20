import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'new_project_controller.dart';

class NewTaskController extends GetxController {
  static NewTaskController get instance => Get.find();
  final controller = Get.put(NewProjectController());

  final taskname = TextEditingController();
  final taskdetails = TextEditingController();
  String taskcolor = "#808080";

  DateTime? selectedDate; // get day selected

  // member
  var memberlist = <String>[
    'shouta',
    'thank',
    'pob',
    'fam',
  ].obs;

  // get memberlist for show
  var selectedmember = <String>[].obs;
  var membersMap = <String, int>{}.obs;

  // tag
  var taglist = <String>[
    'work',
    'job',
    'present',
    'Add Tag',
  ].obs;

  // get tag for show
  var selectedtag = <String>[].obs;
  var TagsMap = <String, int>{}.obs;

  // colors
  void taskchangeColor(Color color) {
    taskcolor = "#${color.value.toRadixString(16).substring(2)}";
    update();
  }

  Color get taskcurrenttagColor => Color(int.parse(taskcolor.replaceFirst('#','0xff')));

  Future<void> fetchMembers() async {
    try {
      final response = await http.get(Uri.parse('http://10.24.8.16:5263/api/GetMembers'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        memberlist.value = data.map((e) => e['user_name'] as String).toList();
        membersMap.value = {
          for (var e in data) e['user_name'] as String: e['user_id'] as int,
        };
      } else {
        throw Exception('Failed to load members');
      }
    } catch (e) {
      print('Error fetching members: $e');
    }
  }
  Future<void> fetchTags() async {
    try {
      final response = await http.get(Uri.parse('http://10.24.8.16:5263/api/GetTags'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        taglist.value = data.map((e) => e['tag_name'] as String).toList();
        TagsMap.value = {
          for (var e in data) e['tag_name'] as String: e['tag_id'] as int,
        };
        if (!taglist.contains('Add Tag')) {
          taglist.add('Add Tag');
        }
      } else {
        throw Exception('Failed to load tags');
      }
    } catch (e) {
      print('Error fetching tags: $e');
    }
  }
  Future<void> createTask() async {
    try {
      final memberIds = selectedmember.map((e) => {'UserId': membersMap[e]}).toList();
      final tagId = TagsMap[selectedtag.first];
      final url = Uri.parse('http://10.24.8.16:5263/api/CreateTask');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'task_name': taskname.text,
          'task_color': taskcolor,
          'task_detail': taskdetails.text,
          'task_end': selectedDate?.toIso8601String(),
          'task_status': 0,
          'user_id': memberIds,
          'tag_id': tagId,
          // 'project_id': ,
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
  @override
  void onInit() {
    fetchMembers();
    fetchTags();
    super.onInit();
  }
}
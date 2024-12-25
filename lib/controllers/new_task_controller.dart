import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'new_project_controller.dart';

class NewTaskController extends GetxController {
  static NewTaskController get instance => Get.find();
  final controller = Get.put(NewProjectController());

  final taskName = TextEditingController();
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
  ].obs;

  final taskList = RxList<Task>([
    Task(taskName: 'Task 1', isToggled: false),
    Task(taskName: 'Task 2', isToggled: false),
    Task(taskName: 'Task 3', isToggled: false),
    Task(taskName: 'Task 4', isToggled: false),
    Task(taskName: 'Task 5', isToggled: false),
    Task(taskName: 'Task 6', isToggled: false),
  ]);

  // get tag for show
  var selectedtag = <String>[].obs;
  var tagsMap = <String, int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMembers(); // โหลดรายชื่อสมาชิกจาก API
    fetchTags(); // โหลด tag จาก API
  }
  // colors
  void taskchangeColor(Color color) {
    taskcolor = "#${color.value.toRadixString(16).substring(2)}";
    update();
  }

  Color get taskcurrenttagColor =>
      Color(int.parse(taskcolor.replaceFirst('#', '0xff')));
  Future<void> fetchMembers() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.24.8.16:5263/api/GetMembers'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        memberlist.value = data.map((e) => e['user_name'] as String).toList();
        membersMap.value = {
          for (var e in data) e['user_name'] as String: e['user_id'] as int,
        };
      } else {
        throw Exception('Failed to fetch members.');
      }
    } catch (e) {
      print('Error fetching members: $e');
    }
  }

  // ฟังก์ชันดึงข้อมูล tag จาก API
  Future<void> fetchTags() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.24.8.16:5263/api/GetTags'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        taglist.value = data.map((e) => e['tag_name'] as String).toList();
        tagsMap.value = {
          for (var e in data) e['tag_name'] as String: e['tag_id'] as int,
        };
      } else {
        throw Exception('Failed to fetch tags.');
      }
    } catch (e) {
      print('Error fetching tags: $e');
    }
  }
}

class Task {
  final String taskName;
  bool isToggled;

  Task({
    required this.taskName,
    this.isToggled = false,
  });
}



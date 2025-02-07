import 'dart:convert';
import 'package:collaboration_app_client/controllers/in_project_controller.dart';
import 'package:collaboration_app_client/models/tag_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'new_project_controller.dart';

class NewTaskController extends GetxController {
  static NewTaskController get instance => Get.find();
  final controller = Get.put(NewProjectController());

  final TaskController tcontroller = Get.find<TaskController>();

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

  // get tag for show
  var tags = [].obs;
  TagModel? selectedTag;

  @override
  void onInit() {
    final projectId = Get.arguments['projectId'] as int?;
    super.onInit();
    if (projectId != null) {
      fetchMembers(projectId);
    } else {
      print("Error: projectId is null");
    } // โหลดรายชื่อสมาชิกจาก API
    fetchTags(); // โหลด tag จาก API
  }

  // colors
  void taskchangeColor(Color color) {
    taskcolor = "#${color.value.toRadixString(16).substring(2)}";
    update();
  }

  Color get taskcurrenttagColor =>
      Color(int.parse(taskcolor.replaceFirst('#', '0xff')));

  Future<void> fetchMembers(int projectId) async {
    try {
      final response = await http
          .get(Uri.parse('http://10.24.8.16:5263/api/GetMember/$projectId'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        memberlist.value =
            data.map((e) => e['user_name'] as String).toList();
        membersMap.value = {
          for (var e in data) e['user_name'] as String: e['user_id'] as int,
        };

        throw Exception('Failed to load members');
      }
    } catch (e) {
      Exception('Error fetching Selected members: $e');
    }
  }

  // ฟังก์ชันดึงข้อมูล tag จาก API
  Future<void> fetchTags() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.24.8.16:5263/api/GetTags'),
      );

      if (response.statusCode == 200) {
        tags.clear();
        final List<dynamic> data = jsonDecode(response.body);
        for (var i in data) {
          TagModel t = TagModel(
            tagId: i['tag_id'],
            tagName: i['tag_name'],
            tagColor: i['tag_color'],
          );
          tags.add(t);
        }
      } else {
        throw Exception('Failed to load tags');
      }
    } catch (e) {
      print('Error fetching tags: $e');
    }
  }

  Future<void> createTask(projectId) async {
    try {
      final url = Uri.parse('http://10.24.8.16:5263/api/CreateTask');

      final tagId = controller.selectedTag != null ? controller.selectedTag!.tagId : null;
      final memberId = membersMap[selectedmember.first];
      final userId = await controller.getUserIdFromToken();

      print("Selected members: $memberId");
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'task_name': taskName.text,
          'task_detail': taskdetails.text,
          'task_end': selectedDate!.toIso8601String(),
          'task_color': taskcolor,
          'user_id': userId,
          'project_id': projectId,
          'tag_id': tagId,
          'task_status': false,
          'task_Owner': memberId,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Created Task Successfully.'),
              ],
            ),
            // behavior: SnackBarBehavior.floating,
            // margin: EdgeInsets.only(bottom: MediaQuery.of(Get.context!).size.height - 180, left: 15, right: 15),
            action: SnackBarAction(label: "OK", onPressed: () {}), //action
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: Duration(seconds: 3),
          ),
        );
        await tcontroller.fetchTask(projectId);
        print("Task created successfully!");
      } else {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.cancel, color: Colors.white),
                SizedBox(width: 8),
                Text('Create Task Failed.'),
              ],
            ),
            // behavior: SnackBarBehavior.floating,
            // margin: EdgeInsets.only(bottom: MediaQuery.of(Get.context!).size.height - 180, left: 15, right: 15),
            action: SnackBarAction(label: "OK", onPressed: () {}), //action
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: Duration(seconds: 3),
          ),
        );
        print("Failed to create task: ${response.body}");
      }
    } catch (e) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.cancel, color: Colors.white),
              SizedBox(width: 8),
              Text('Create Task Failed.'),
            ],
          ),
          // behavior: SnackBarBehavior.floating,
          // margin: EdgeInsets.only(bottom: MediaQuery.of(Get.context!).size.height - 180, left: 15, right: 15),
          action: SnackBarAction(label: "OK", onPressed: () {}), //action
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: Duration(seconds: 3),
        ),
      );
      print('Error in createTask: $e');
      rethrow;
    }
  }
}



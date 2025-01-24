import 'dart:convert';
import 'package:collaboration_app_client/controllers/in_project_controller.dart';
import 'package:collaboration_app_client/controllers/tag_controller.dart';
import 'package:collaboration_app_client/models/tag_model.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditTaskController extends GetxController {
  static EditTaskController get instance => Get.find();

  final edittaskname = TextEditingController();
  final edittaskdetails = TextEditingController();
  String edittaskcolor = "#808080";
  DateTime? editselectedDate; // get day selected

  final TaskController tcontroller = Get.find<TaskController>();
  final tagController = Get.put(TagController());

  var editmemberlist = <String>[].obs;
  var editselectedmember = <String>[].obs;
  var editmembersMap = <String, int>{}.obs;
  var edit_selected_members_map = <String>[].obs;

  var tags = [].obs;
  TagModel? selectedTag;

  // colors
  void edittaskchangeColor(Color color) {
    edittaskcolor = "#${color.value.toRadixString(16).substring(2)}";
    update();
  }

  Color get taskcurrenttagColor =>
      Color(int.parse(edittaskcolor.replaceFirst('#', '0xff')));

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("Retrieved token: ${prefs.getString('jwt_token')}");
    return prefs.getString('jwt_token');
  }

  Future<int?> getUserIdFromToken() async {
    final token = await getToken();
    if (token != null && JwtDecoder.isExpired(token) == false) {
      final decodedToken = JwtDecoder.decode(token);
      return int.tryParse(decodedToken['userId'].toString());
    }
    return null;
  }

  Future<void> fetchSelectedMembers(int projectId) async {
    try {
      final response = await http
          .get(Uri.parse('http://10.24.8.16:5263/api/GetMember/$projectId'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        edit_selected_members_map.value =
            data.map((e) => e['user_name'] as String).toList();
        editmembersMap.value = {
          for (var e in data) e['user_name'] as String: e['user_id'] as int,
        };

        throw Exception('Failed to load members');
      }
    } catch (e) {
      Exception('Error fetching Selected members: $e');
    }
  }

  Future<void> updateTask(
      int projectId, int taskId, int tag_id, String task_Owner) async {
    try {
      final token = await getToken();
      final userId = await getUserIdFromToken();
      final taskids = Get.put(TaskController());

      final memberId = editselectedmember.isNotEmpty
          ? editmembersMap[editselectedmember.first]
          : editmembersMap[task_Owner];
      print("Testtttttttttttttttt${memberId}");

      final tagId = tagController.selectedTag?.tagId;

      final response = await http.put(
        Uri.parse('http://10.24.8.16:5263/api/UpdateTask/$taskId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "task_name": edittaskname.text.isNotEmpty
              ? edittaskname.text
              : taskids.task.value
                  .firstWhere((element) => element.taskId == taskId)
                  .taskName,
          "task_detail": edittaskdetails.text.isNotEmpty
              ? edittaskdetails.text
              : taskids.task.value
                  .firstWhere((element) => element.taskId == taskId)
                  .taskDetail,
          "task_end": editselectedDate!.toIso8601String(),
          "task_color": edittaskcolor,
          "task_status": false,
          "user_id": userId,
          "tag_id": tagId,
          "project_id": projectId,
          "task_Owner": memberId
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Saved Task Successfully.'),
              ],
            ),
            // behavior: SnackBarBehavior.floating,
            // margin: EdgeInsets.only(bottom: MediaQuery.of(Get.context!).size.height - 180, left: 15, right: 15),
            action: SnackBarAction(label: "OK", onPressed: () {}), //action
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
        await tcontroller.fetchTask(projectId);
        print('Project updated successfully');
      } else {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.cancel, color: Colors.white),
                SizedBox(width: 8),
                Text('Save Task Failed.'),
              ],
            ),
            // behavior: SnackBarBehavior.floating,
            // margin: EdgeInsets.only(bottom: MediaQuery.of(Get.context!).size.height - 180, left: 15, right: 15),
            action: SnackBarAction(label: "OK", onPressed: () {}), //action
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
        print('Failed to update project');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.cancel, color: Colors.white),
              SizedBox(width: 8),
              Text('Save Task Failed.'),
            ],
          ),
          // behavior: SnackBarBehavior.floating,
          // margin: EdgeInsets.only(bottom: MediaQuery.of(Get.context!).size.height - 180, left: 15, right: 15),
          action: SnackBarAction(label: "OK", onPressed: () {}), //action
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
      throw ('Error updating project: $e');
    }
  }

  Future<void> deleteTask(int taskId, projectId) async {
    try {
      final response = await http.delete(
        Uri.parse('http://10.24.8.16:5263/api/DeleteTask/$taskId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Deleted Task Successfully.'),
              ],
            ),
            // behavior: SnackBarBehavior.floating,
            // margin: EdgeInsets.only(bottom: MediaQuery.of(Get.context!).size.height - 180, left: 15, right: 15),
            action: SnackBarAction(label: "OK", onPressed: () {}), //action
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
        await tcontroller.fetchTask(projectId);
        print('Project deleted successfully');
        // Get.snackbar("Success", "Project deleted successfully");
      } else {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.cancel, color: Colors.white),
                SizedBox(width: 8),
                Text('Delete Task Failed.'),
              ],
            ),
            // behavior: SnackBarBehavior.floating,
            // margin: EdgeInsets.only(bottom: MediaQuery.of(Get.context!).size.height - 180, left: 15, right: 15),
            action: SnackBarAction(label: "OK", onPressed: () {}), //action
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
        print('Failed to delete project');
      }
    } catch (e) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.cancel, color: Colors.white),
              SizedBox(width: 8),
              Text('Delete Task Failed.'),
            ],
          ),
          // behavior: SnackBarBehavior.floating,
          // margin: EdgeInsets.only(bottom: MediaQuery.of(Get.context!).size.height - 180, left: 15, right: 15),
          action: SnackBarAction(label: "OK", onPressed: () {}), //action
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
      print('Error deleting project: $e');
    }
  }

  @override
  void onInit() {
    final projectId = Get.arguments['projectId'] as int?;
    final tagId = Get.arguments['tagId'] as int?;

    if (projectId != null) {
      fetchSelectedMembers(projectId);
    } else {
      print("Error: projectId is null");
    }

    if (tagId != null) {
      tagController.fetchTagMap(tagId);
    } else {
      print("Error: tagId is null");
    }
    super.onInit();
  }
}

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/project_model.dart';
import '../models/task_model.dart';

class TaskController extends GetxController {
  static TaskController get instance => Get.find();
  var task = <Task>[].obs;
  var isLoading = true.obs;
  late int projectId;


  @override
  void onInit() async {
    super.onInit();
    final Map<String, dynamic> arguments = Get.arguments;
    projectId = arguments['projectId'];
    fetchTask(projectId);
  }

  Future<void> fetchTask(int projectId) async {
    try {
      isLoading(true);
      print("Fetching API...");
      final response = await http.get(
        Uri.parse('http://10.24.8.16:5263/api/GetTasks/$projectId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        print('Decoded data: $jsonData');
        task.value = jsonData.map((data) => Task.fromJson(data)).toList();
        print("Projects loaded: ${task.length}");
        task.forEach((task) {
          print('Task ID: ${task.taskId}, User ID: ${task.userId}');
        });
      } else {
        print('Failed to load projects');
        print('Response: ${response.body}');
      }
    } catch (e) {
      throw ('Error fetching projects: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateTaskStatus(int taskId, bool taskStatus) async {
    try {
      final response = await http.put(
        Uri.parse('http://10.24.8.16:5263/api/UpdateStatus/$taskId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'task_status': taskStatus,
          'project_id': projectId
        }),
      );
      print('Response status code: ${response.statusCode}');
      print('${response.body}');

      if (response.statusCode == 200) {
        var taskupdate = task.firstWhere((task) => task.taskId == taskId);
        taskupdate.taskStatus = taskStatus;

        print('Response: ${response.body}');
        print('Response: ${taskupdate}');
        Get.snackbar('Success', 'Task status updated successfully');
      } else {
        Get.snackbar('Error', 'Fail to update task status');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update task status: $e');
    }
  }

  Future<void> updateTaskOrder(List<Task> tasks) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.24.8.16:5263/api/tasks/updateOrder'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(tasks.map((task) => {
          'task_id': task.taskId,
          'task_order': task.taskOrder,
        }).toList()),

      );
      print(jsonEncode(tasks.map((task) => {
        'task_id': task.taskId,
        'task_order': task.taskOrder,
      }).toList()),);

      if (response.statusCode == 200) {
        print("Order updated successfully");
      } else {
        throw("Failed to update order: ${response.body}");
      }
    } catch (e) {
      throw("Error updating order: $e");
    }
  }
}

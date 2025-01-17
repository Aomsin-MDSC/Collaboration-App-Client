import 'dart:convert';
import 'package:collaboration_app_client/controllers/project_controller.dart';
import 'package:collaboration_app_client/models/tag_model.dart';
import 'package:collaboration_app_client/views/project_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'in_project_controller.dart';

class NewProjectController extends GetxController {
  static NewProjectController get instance => Get.find();
  final ProjectController projectController = Get.find<ProjectController>();
  final projectname = TextEditingController();
  var memberlist = <String>[].obs;
  var selectedmember = <String>[].obs;
  RxMap<int, String> membersMap = RxMap<int, String>();

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

  var tags = [].obs;
  TagModel? selectedTag;

  Future<void> fetchMembers(String token) async {
    try {
      final response =
          await http.get(Uri.parse('http://10.24.8.16:5263/api/GetUsers'),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        
        memberlist.value = data.map((e) => e['user_name'] as String).toList();
        membersMap.value = {
          for (var e in data) e['user_id'] as int: e['user_name'] as String,
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
      final response =
          await http.get(Uri.parse('http://10.24.8.16:5263/api/GetTags'));

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

  Future<void> createProject() async {
    try {
      final token = await getToken();
      if (token == null) {
        print("Token not found!");
        return;
      }
      final userId = await getUserIdFromToken();
      if (userId == null) {
        print("User ID not found!");
        return;
      }
      print("Selected members: $selectedmember");

      // if (selectedmember.isEmpty) {
      //   print('No members selected!');
      //   return;
      // }
      // if (selectedTag == null) {
      //   print('No tag selected!');
      //   return;
      // }

      final memberIds = selectedmember
          .map((e) => {'UserId': int.parse(membersMap.entries.firstWhere((entry) => entry.value == e).key.toString())})
          .toList();

      memberIds.add({'UserId': userId});

      final tagId = selectedTag != null ? selectedTag!.tagId : null;
      print("Selected TagId: $memberIds");
      print("Selected TagId: $tagId");

      String body = jsonEncode({
        'ProjectName': projectname.text,
        'TagId': tagId,
        'CreatorId': userId,
        'Members': memberIds,
      });
      print(body);
      final response = await http.post(
        Uri.parse('http://10.24.8.16:5263/api/CreateProject'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Created Project Successfully.'),
              ],
            ),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(bottom: MediaQuery.of(Get.context!).size.height - 260, left: 15, right: 15),
            action: SnackBarAction(label: "OK", onPressed: () {}), //action
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: Duration(seconds: 3),
          ),
        );
        print('Project created successfully');
        projectController.fetchApi(token);
      } else {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.cancel, color: Colors.white),
                SizedBox(width: 8),
                Text('Create Project Failed.'),
              ],
            ),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(bottom: MediaQuery.of(Get.context!).size.height - 260, left: 15, right: 15),
            action: SnackBarAction(label: "OK", onPressed: () {}), //action
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: Duration(seconds: 3),
          ),
        );
        print('Failed to create project');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.cancel, color: Colors.white),
              SizedBox(width: 8),
              Text('Create Project Failed.'),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(bottom: MediaQuery.of(Get.context!).size.height - 260, left: 15, right: 15),
          action: SnackBarAction(label: "OK", onPressed: () {}), //action
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: Duration(seconds: 3),
        ),
      );
      throw ('Error creating project: $e');
    }
  }


  @override
  void onInit() async{
    fetchTags();
    super.onInit();
    String? token = await getToken();
    if (token != null && token.isNotEmpty) {
      fetchMembers(token);
    } else {
      print("Token not found");
    }
  }
}

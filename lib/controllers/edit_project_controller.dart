import 'dart:convert';
import 'package:collaboration_app_client/controllers/project_controller.dart';
import 'package:collaboration_app_client/controllers/tag_controller.dart';
import 'package:collaboration_app_client/models/tag_model.dart';
import 'package:collaboration_app_client/views/edit_project_view.dart';
import 'package:collaboration_app_client/views/home_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EditProjectController extends GetxController {
  static EditProjectController get instance => Get.find();
  final tagController = Get.put(TagController());
  final ProjectController controler = Get.find<ProjectController>();
  final editprojectname = TextEditingController();
  var editmemberlist = <String>[].obs;
  
  // var memberlist = <String>[].obs;  
  // var selectedManagers = <String>[].obs; 
  // var selectedMembers = <String>[].obs; 

  var editselectedmember = <String>[].obs;
  var editmembersMap = <String, int>{}.obs;
  var edit_selected_members_map = <String>[].obs;
  var edit_selected_manager_map = <String>[].obs;

  // late int projectId;
  final projectname = TextEditingController();

  var edittaglist = <String>[
    'work',
    'job',
    'present',
    'Add Tag',
  ].obs;

  var editselectedtag = <String>[].obs;
  var selected_tag_map = <String>[].obs;
  var editTagsMap = <String, int>{}.obs;

  var tags = [].obs;
  TagModel? selectedTag;

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

  Future<void> fetchMembers(token) async {
    try {
      final response = await http.get(
        Uri.parse('http://10.24.8.16:5263/api/GetUsers'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        editmemberlist.value =
            data.map((e) => e['user_name'] as String).toList();
        editmembersMap.value = {
          for (var e in data) e['user_name'] as String: e['user_id'] as int,
        };
      } else {
        throw Exception('Failed to load members');
      }
    } catch (e) {
      print('Error fetching members: $e');
    }
  }

  Future<void> fetchSelectedMembers(int projectId) async {
    try {
      final response = await http
          .get(Uri.parse('http://10.24.8.16:5263/api/GetMember/$projectId'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final userId = await getUserIdFromToken();

        /* edit_selected_members_map.value =
            data.map((e) => e['user_name'] as String).toList(); */

        edit_selected_members_map.value = data
            .where((e) => e['user_id'] != userId && e['member_role'] == 1)
            .map((e) => e['user_name'] as String)
            .toList();

       edit_selected_manager_map.value = data
            .where((e) => e['user_id'] != userId && e['member_role'] == 0)
            .map((e) => e['user_name'] as String)
            .toList();

        throw Exception('Failed to load members');
      }
    } catch (e) {
      Exception('Error fetching Selected members: $e');
    }
  }

  Future<void> fetchTagMap(int tag_id) async {
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

          if (tag_id != null && tag_id == t.tagId) {
            selectedTag = t;
          }
        }

        // Filter tags where tag_id is 1

        final filteredData = data.where((e) => e['tag_id'] == tag_id).toList();

        edittaglist.value = data.map((e) => e['tag_name'] as String).toList();

        selected_tag_map.value =
            filteredData.map((e) => e['tag_name'] as String).toList();

        editTagsMap.value = {
          for (var e in data) e['tag_name'] as String: e['tag_id'] as int,
        };

        if (!edittaglist.contains('Add Tag')) {
          edittaglist.add('Add Tag');
        }
      } else {
        throw Exception('Failed to load tags');
      }
    } catch (e) {
      print('Error fetching tags: $e');
    }
  }

  Future<void> updateProject(int projectId, int tag_id) async {
    try {
      final projectids = Get.put(ProjectController());

      final token = await getToken();
      final userId = await getUserIdFromToken();

      /* if (editselectedmember.isEmpty) {
        editselectedmember.value = edit_selected_members_map;
      } */

      print(
          "editselectedmember::::::::::::::::::::::: $edit_selected_members_map");
      
        final memberIds = [
      ...edit_selected_manager_map.map((manager) => {
            'UserId': editmembersMap[manager]!.toInt(),
            'MemberRole': 0, 
          }),
      ...edit_selected_members_map.map((member) => {
            'UserId': editmembersMap[member]!.toInt(),
            'MemberRole': 1, 
          }),
    ];
      // final memberIds =
      //     editselectedmember.map((e) => editmembersMap[e]).toList();

      if (!memberIds.contains(userId)) {
        memberIds.add({
          'UserId': userId!.toInt(),
          'MemberRole': 0, // 0 for manager, 1 for member
        });
      }

      print("Member IDs::::::::::::::::::::::: $memberIds");

      // final memberIds = editselectedmember
      //         .map((e) => editmembersMap[e])
      //         .toList()
      //         .isNotEmpty
      //     ? editselectedmember.map((e) => editmembersMap[e]).toList()
      //     : edit_selected_members_map.map((e) => editmembersMap[e]).toList();

      final tagId = tagController.selectedTag?.tagId != null ? tagController.selectedTag?.tagId : null;
      print("Tag ID::::::::::::::::::::::: $tagId");

      if (token == null) {
        print("Token not found!");
        return;
      }
    String  body = jsonEncode({
          'ProjectName': editprojectname.text.isNotEmpty
              ? editprojectname.text
              : projectids.project.value
                  .firstWhere((element) => element.projectId == projectId)
                  .projectName,
          'TagId': tagId,
          'CreatorId': userId,
          'Members': memberIds,
        });
        print("Edit Project Page Controller :::::: $body"); 
        print(projectId);  

      final response = await http.put(
        Uri.parse('http://10.24.8.16:5263/api/UpdateProject/$projectId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'ProjectName': editprojectname.text.isNotEmpty
              ? editprojectname.text
              : projectids.project.value
                  .firstWhere((element) => element.projectId == projectId)
                  .projectName,
          'TagId': tagId,
          'CreatorId': userId,
          'Members': memberIds,
        }),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Saved Project Successfully.'),
              ],
            ),
            // behavior: SnackBarBehavior.floating,
            // margin: EdgeInsets.only(bottom: MediaQuery.of(Get.context!).size.height - 260, left: 15, right: 15),
            action: SnackBarAction(label: "OK", onPressed: () {}), //action
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: Duration(seconds: 3),
          ),
        );
        await controler.fetchApi(token);
        print('Project updated successfully');
      } else {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.cancel, color: Colors.white),
                SizedBox(width: 8),
                Text('Save Project Failed.'),
              ],
            ),
            // behavior: SnackBarBehavior.floating,
            // margin: EdgeInsets.only(bottom: MediaQuery.of(Get.context!).size.height - 260, left: 15, right: 15),
            action: SnackBarAction(label: "OK", onPressed: () {}), //action
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: Duration(seconds: 3),
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
              Text('Save Project Failed.'),
            ],
          ),
          // behavior: SnackBarBehavior.floating,
          // margin: EdgeInsets.only(bottom: MediaQuery.of(Get.context!).size.height - 260, left: 15, right: 15),
          action: SnackBarAction(label: "OK", onPressed: () {}), //action
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: Duration(seconds: 3),
        ),
      );
      throw ('Error updating project: $e');
    }
  }

  Future<void> deleteProject(int projectId) async {
    try {
      final token = await getToken();
      if (token == null) {
        print("Token not found!");
        return;
      }

      final response = await http.delete(
        Uri.parse('http://10.24.8.16:5263/api/DeleteProject/$projectId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Deleted Project Successfully.'),
              ],
            ),
            // behavior: SnackBarBehavior.floating,
            // margin: EdgeInsets.only(bottom: MediaQuery.of(Get.context!).size.height - 260, left: 15, right: 15),
            action: SnackBarAction(label: "OK", onPressed: () {}), //action
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: Duration(seconds: 3),
          ),
        );
        await controler.fetchApi(token);
        print('Project deleted successfully');
      } else {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.cancel, color: Colors.white),
                SizedBox(width: 8),
                Text('Delete Project Failed.'),
              ],
            ),
            // behavior: SnackBarBehavior.floating,
            // margin: EdgeInsets.only(bottom: MediaQuery.of(Get.context!).size.height - 260, left: 15, right: 15),
            action: SnackBarAction(label: "OK", onPressed: () {}), //action
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: Duration(seconds: 3),
          ),
        );
        throw('Failed to delete project');
      }
    } catch (e) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('Delete Project Failed.'),
            ],
          ),
          // behavior: SnackBarBehavior.floating,
          // margin: EdgeInsets.only(bottom: MediaQuery.of(Get.context!).size.height - 260, left: 15, right: 15),
          action: SnackBarAction(label: "OK", onPressed: () {}), //action
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: Duration(seconds: 3),
        ),
      );
      throw('Error deleting project: $e');
    }
  }

  @override
  void onInit() async {
    fetchSelectedMembers(Get.arguments['projectId']);
    tagController.fetchTagMap(Get.arguments['tagId']);
    // loadProjectDetails(projectId);
    super.onInit();
    String? token = await getToken();
    if (token != null && token.isNotEmpty) {
      fetchMembers(token);
    } else {
      print("Token not found");
    }
  }
}

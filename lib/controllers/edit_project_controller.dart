import 'dart:convert';
import 'package:collaboration_app_client/controllers/project_controller.dart';
import 'package:collaboration_app_client/models/tag_model.dart';
import 'package:collaboration_app_client/views/edit_project_view.dart';
import 'package:collaboration_app_client/views/home_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EditProjectController extends GetxController {
  static EditProjectController get instance => Get.find();

  final editprojectname = TextEditingController();
  var editmemberlist = <String>[].obs;
  var editselectedmember = <String>[].obs;
  var editmembersMap = <String, int>{}.obs;
  var edit_selected_members_map = <String>[].obs;

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

  Future<void> fetchMembers() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.24.8.16:5263/api/GetUsers'));

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
        edit_selected_members_map.value =
            data.map((e) => e['user_name'] as String).toList();

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

      final memberIds =
          editselectedmember.map((e) => editmembersMap[e]).toList();

      if (!memberIds.contains(userId)) {
        memberIds.add(userId);
      }

      // final memberIds = editselectedmember
      //         .map((e) => editmembersMap[e])
      //         .toList()
      //         .isNotEmpty
      //     ? editselectedmember.map((e) => editmembersMap[e]).toList()
      //     : edit_selected_members_map.map((e) => editmembersMap[e]).toList();

      final tagId = selectedTag?.tagId != null ? selectedTag?.tagId : tag_id;
      print("Tag ID::::::::::::::::::::::: $tagId");

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
        print('Project updated successfully');
        Get.off(() => const HomeView(), arguments: {'refresh': true});
      } else {
        print('Failed to update project');
        print('Response body: ${response.body}');
      }
    } catch (e) {
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
        print('Project deleted successfully');
        Get.snackbar("Success", "Project deleted successfully");
      } else {
        print('Failed to delete project');
        Get.snackbar("Error", "Failed to delete project");
      }
    } catch (e) {
      print('Error deleting project: $e');
      Get.snackbar("Error", "Something went wrong: $e");
    }
  }

  @override
  void onInit() {
    fetchMembers();
    fetchSelectedMembers(Get.arguments['projectId']);
    fetchTagMap(Get.arguments['tagId']);
    // loadProjectDetails(projectId);
    super.onInit();
  }
}

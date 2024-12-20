import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EditProjectController extends GetxController {
  static EditProjectController get instance => Get.find();

  // final editprojectname = TextEditingController();
  var editmemberlist = <String>[].obs;
  var editselectedmember = <String>[].obs;
  var editmembersMap = <String, int>{}.obs;


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

  var edittaglist = <String>[
    'work',
    'job',
    'present',
    'Add Tag',
  ].obs;

  var editselectedtag = <String>[].obs;
  var editTagsMap = <String, int>{}.obs;

  Future<void> fetchMembers() async {
    try {
      final response = await http.get(Uri.parse('http://10.24.8.16:5263/api/GetMembers'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        editmemberlist.value = data.map((e) => e['user_name'] as String).toList();
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

  Future<void> fetchTags() async {
    try {
      final response = await http.get(Uri.parse('http://10.24.8.16:5263/api/GetTags'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        edittaglist.value = data.map((e) => e['tag_name'] as String).toList();
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
      print("Selected members: $editselectedmember");

      if (editselectedmember.isEmpty) {
        print('No members selected!');
        return;
      }

      final memberIds = editselectedmember.map((e) => {'UserId': editmembersMap[e]}).toList();
      final tagId = editTagsMap[editselectedtag.first];
      print("Selected TagId: $tagId");


      final response = await http.post(
        Uri.parse('http://10.24.8.16:5263/api/CreateProject'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          // 'ProjectName': editprojectname.text,
          'TagId': tagId,
          'CreatorId': userId,
          'Members': memberIds,
        }),
      );

      if (response.statusCode == 200) {
        print('Project created successfully');
      } else {
        print('Failed to create project');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error creating project: $e');
    }
  }

  @override
  void onInit() {
    fetchMembers();
    fetchTags();
    super.onInit();
  }
}

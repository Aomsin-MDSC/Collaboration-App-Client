import 'dart:convert';

import 'package:collaboration_app_client/models/comment_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/task_model.dart';

class TaskPageController extends GetxController {
  static TaskPageController get instance => Get.find();

  bool taskstatus = true;
  var isLoading = true.obs;
  var comments = <CommentModel>[].obs;

  final commentText = TextEditingController();

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

  Future<void> fetchComment(int taskId) async {
    try {
      print("Fetching API...");
      final response = await http.get(
        Uri.parse('http://10.24.8.16:5263/comment/GetComments/$taskId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        comments.clear();
        for(var i in data){
          CommentModel C = CommentModel(
            commentId: i['comment_id'],
            commentText: i['comment_text'],
            commentDate: DateTime.parse(i['comment_date']),
            userId: i['user_id'],
            taskId: taskId,
            userName: i['user_name'],
          );
          comments.add(C);
        }

      } else {
        throw Exception('Failed to load tags');
      }
    } catch (e) {
      throw ('Error fetching projects: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> CreateComment(taskId) async {
    try {
      final userId = await getUserIdFromToken();
      final url = Uri.parse('http://10.24.8.16:5263/comment/CreateComment');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'comment_text': commentText.text,
          'comment_date': DateTime.now().toIso8601String(),
          'user_id': userId,
          'task_id': taskId,
        }),
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Comment successfully!");
      } else {
        print("Failed to comment: ${jsonDecode(response.body)['message'] ?? response.statusCode}");
      }
    } catch (e) {
      throw("Something went wrong: $e");
    }
  }
}

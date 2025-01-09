import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/project_model.dart';

class ProjectController extends GetxController {
  static ProjectController get instance => Get.find();
  var project = <Project>[].obs;
  var isLoading = true.obs;
  Rx<int> userId = 0.obs;


  @override
  void onInit() async {
    super.onInit();
    String? token = await getToken();
    if (token != null && token.isNotEmpty) {
      fetchApi(token);
    } else {
      print("Token not found");
    }
    userId.value = await loadUserId();
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }
  Future<int> loadUserId() async {
    await Future.delayed(const Duration(seconds: 1));
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token != null && token.isNotEmpty) {
      try {
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        if (decodedToken.containsKey('userId')) {
          print("User ID found: ${decodedToken['userId']}");
          return int.parse(decodedToken['userId'].toString());
        } else {
          print("userId not found in token");
          return -1;
        }
      } catch (e) {
        print("Error decoding token: $e");
        return -1;
      }
    } else {
      print('No token found');
      return -1;
    }
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
  }

  Future<void> fetchApi(String token) async {
    try {
      isLoading(true);
      print("Fetching API...");
      final response = await http.get(
        Uri.parse('http://10.24.8.16:5263/api/GetProjects'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      print('Token used: $token');

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        // print('Decoded data: $jsonData');
        project.value = jsonData.map((data) => Project.fromJson(data)).toList();
        // print("Projects loaded: ${project.length}");
        project.forEach((project) {
          // print('Project ID: ${project.projectId}, User ID: ${project.userId}');
        });
      } else {
        print('Failed to load projects');
        print('Response: ${response.body}');
      }
    } catch (e) {
      print('Error fetching projects: $e');
    } finally {
      isLoading(false);
    }
  }

  // ฟังก์ชันอัปเดตข้อมูล (ยังไม่ได้ใช้ในตัวอย่าง)
  Future<void> updateReorder() async {
    // Implementation of update reorder logic
  }
}

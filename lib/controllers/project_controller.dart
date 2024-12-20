import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/project_model.dart';

class ProjectController extends GetxController {
  static ProjectController get instance => Get.find();
  var project = <Project>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() async {
    super.onInit();
    String? token = await getToken(); // รับ Token จาก SharedPreferences
    if (token != null && token.isNotEmpty) {
      fetchApi(token);  // ถ้ามี Token ให้เรียก API
    } else {
      print("Token not found");
    }
  }

  // ฟังก์ชันดึง Token จาก SharedPreferences
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token'); // ใช้ key เดียวกันในทุกจุด
  }

  // ฟังก์ชันบันทึก Token ลง SharedPreferences
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token); // ใช้ key เดียวกัน
  }

  // ฟังก์ชัน fetch API
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
        print('Decoded data: $jsonData');
        project.value = jsonData.map((data) => Project.fromJson(data)).toList();
        print("Projects loaded: ${project.length}");
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

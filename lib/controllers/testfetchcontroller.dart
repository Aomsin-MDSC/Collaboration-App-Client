import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/testmodel.dart';

class ProjectController extends GetxController {
  static ProjectController get instance => Get.find();
  var project = <Project>[].obs;
  var isLoading = true.obs;


  @override
  void onInit() async {
    String token = await getToken();
    if (token.isNotEmpty) {
      fetchApi(token);
    } else {
      print("Token not found");
    }
    super.onInit();
  }
  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }
  Future<void> fetchApi(String token) async {
    try {
      isLoading(true);
      print("Fetching API...");
      final response =
      await http.get(Uri.parse('http://10.24.8.16:5263/api/GetProjects'),
        headers: {
          'Authorization': 'Bearer $token',
        },);
      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        project.value = jsonData.map((data) => Project.fromJson(data)).toList();
        print("Products loaded: ${project.length}");
      } else {
        print('Failed to load products');
      }
    } finally {
      isLoading(false);
    }
  }



  Future<void> updateReorder() async {
    // try {

    //   final response = await http.put(
    //     Uri.parse(
    //         'https://fakestoreapi.com/'), // Replace with your correct endpoint
    //     headers: {"Content-Type": "application/json"},
    //     body: ,
    //   );

    //   if (response.statusCode == 200) {
    //     print("Reorder successfully updated!");
    //   } else {
    //     print("Failed to update reorder: ${response.body}");
    //   }
    // } catch (e) {
    //   print("Error while updating reorder: $e");
    // }
  }
}

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/testmodel.dart';

class ProjectController extends GetxController {
  var project = <Project>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIxIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZSI6IlRlc3QwMSIsImV4cCI6MTczNDYxMTk4NSwiaXNzIjoibXktYXBpIiwiYXVkIjoibW9iaWxlLWFwcCJ9._s5HC6F8MvjdR88huSP7LLco4jUsu5QP3PXRSlw95tQ"; // Token ที่ได้จากการ login หรือที่เก็บไว้
    fetchApi(token);
    super.onInit();
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

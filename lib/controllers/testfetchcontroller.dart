import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/testmodel.dart';

class ProjectController extends GetxController {
  var products = <Project>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchApi();
    super.onInit();
  }

  Future<void> fetchApi() async {
    try {
      isLoading(true);
      final response =
          await http.get(Uri.parse('http://10.24.8.16:5263/api/GetProjects'));
      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        products.value =
            jsonData.map((data) => Project.fromJson(data)).toList();
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

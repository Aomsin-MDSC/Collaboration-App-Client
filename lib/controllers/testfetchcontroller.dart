import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/testmodel.dart';

class ProductController extends GetxController {
  var products = <Product>[].obs;
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
          await http.get(Uri.parse('http://10.0.2.2:5263/api/users'));
      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        products.value =
            jsonData.map((data) => Product.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load products');
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

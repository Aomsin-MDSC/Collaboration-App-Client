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
          await http.get(Uri.parse('https://fakestoreapi.com/products'));
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
}

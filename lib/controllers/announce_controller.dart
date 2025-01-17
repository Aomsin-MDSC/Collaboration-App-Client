import 'dart:convert';
import 'package:collaboration_app_client/models/announce_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnnounceController extends GetxController {
  static AnnounceController get instance => Get.find();
  var announces = <Announce>[].obs;


  @override
  void onInit() async {
    super.onInit();
  }

  Future<void> fetchAnnounce(int projectId) async {

    try {
      final Map<String, dynamic> arguments = Get.arguments;
      final int projectId = arguments['projectId'];

      final url = Uri.parse('http://10.24.8.16:5263/api/GetAnnounce/$projectId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        announces.value = jsonData.map((data) => Announce.fromJson(data)).toList();
      } else {
        announces.clear();
        print("Failed to fetch announces: ${response.body}");
      }
    } catch (e) {
      print("Error fetching announces: $e");
    }
  }
}
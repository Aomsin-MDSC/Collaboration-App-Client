import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../views/home_view.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final username = TextEditingController();
  final password = TextEditingController();

  //Login Func
  Future<void> login() async {
    final url = Uri.parse('http://10.24.8.16:5263/api/login'); // URL ของ API
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'UserName': username.text,
        'Password': password.text,
      }),
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      Get.to(
          // TestFetch()
          HomeView());
    } else {
      print("Fail");
    }
  }
}

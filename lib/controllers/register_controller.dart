import 'dart:convert';

import 'package:collaboration_app_client/views/Login_View.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RegisterController extends GetxController {
  static RegisterController get instance => Get.find();

  final username = TextEditingController();
  final password = TextEditingController();

  Future<void> registerUser() async {
    final url = Uri.parse('http://10.24.8.16:5263/api/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'User_name': username.text.trim(),
        'User_password': password.text.trim(),
      }),
    );
    if (response.statusCode == 200) {
      return Get.to(const LoginView());
    } else {
      throw Exception('Registration failed');
    }
  }
}

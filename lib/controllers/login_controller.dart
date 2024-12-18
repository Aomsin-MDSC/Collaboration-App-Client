import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../views/home_view.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final username = TextEditingController();
  final password = TextEditingController();

  //Login Func
  Future<void> login() async {
    final url = Uri.parse('http://10.0.2.2:5263/api/user/login'); // API URL

    if (username.text.trim().isEmpty || password.text.trim().isEmpty) {
      Get.snackbar('Error', 'Username and password are required');
      return;
    }

    Get.dialog(
      Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'UserName': username.text.trim(),
          'Password': password.text.trim(),
        }),
      );

      Get.back(); // Close loading dialog

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        Get.snackbar('Login successful', 'Welcome : ${username.text}',
            duration: const Duration(seconds: 10));
        print('Login successful: $data');
        Get.to(const HomeView());
      } else if (response.statusCode == 401) {
        Get.snackbar('Login Failed', 'Invalid username or password');
      } else {
        Get.snackbar('Error', 'Login failed: ${response.body}',
            duration: const Duration(seconds: 10));
      }
    } catch (e) {
      Get.back(); // Close loading dialog
      print('Error during login: $e');
      Get.snackbar('Error', 'An error occurred. Please try again later.');
    }
  }
}

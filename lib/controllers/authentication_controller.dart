import 'dart:convert';
import 'package:collaboration_app_client/views/Login_View.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../views/home_view.dart';

class AuthenticationController extends GetxController {
  static AuthenticationController get instance => Get.find();

  final username = TextEditingController();
  final password = TextEditingController();

  Future<void> login() async {
    final url = Uri.parse('http://10.24.8.16:5263/api/login'); // URL ของ API

    if (username.text.trim().isEmpty || password.text.trim().isEmpty) {
      Get.snackbar('Error', 'Username and password are required');
      return;
    }

    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'UserName': username.text,
          'Password': password.text,
        }),
      );

      Get.back(); // Close loading dialog
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        String token =
            data['token']; // Adjust based on your API's response structure

        // Save the token in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        Get.snackbar('Login successful', 'Welcome : ${username.text}',
            duration: const Duration(seconds: 5),
            margin: const EdgeInsets.all(8),
            backgroundColor: Colors.black54,
            colorText: Colors.white);
        print('Login successful: $data');
        Get.off(const HomeView());
      } else if (response.statusCode == 401) {
        Get.snackbar('Login Failed', 'Invalid username or password',
            duration: const Duration(seconds: 5),
            margin: const EdgeInsets.all(8),
            backgroundColor: Colors.black54,
            colorText: Colors.white);
      } else {
        Get.snackbar('Error', 'Login failed: ${response.body}',
            duration: const Duration(seconds: 5),
            margin: const EdgeInsets.all(8),
            backgroundColor: Colors.black54,
            colorText: Colors.white);
      }
    } catch (e) {
      Get.back(); // Close loading dialog
      print('Error during login: $e');
      Get.snackbar('Error', 'An error occurred. Please try again later.',
          duration: const Duration(seconds: 5),
          margin: const EdgeInsets.all(8),
          backgroundColor: Colors.black54,
          colorText: Colors.white);
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    print("Token deleted");

    Get.off(() => const LoginView());
  }
}
import 'dart:convert';
import 'package:collaboration_app_client/controllers/project_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../views/Login_View.dart';
import '../views/home_view.dart';

class AuthenticationController extends GetxController {
  static AuthenticationController get instance => Get.find();

  final username = TextEditingController();
  final password = TextEditingController();

  //Login Func
  Future<void> login() async {
    final url = Uri.parse('http://10.24.8.16:5263/api/login'); // URL ของ API

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'UserName': username.text,
          'Password': password.text,
        }),
      );

      // Close any existing dialogs
      Get.back();

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        final token = data['token'];

        // Save the token in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', token);
        print('Token saved: ${prefs.getString('jwt_token')}');

        // Show a success message
        Get.snackbar(
          'Login successful',
          'Welcome : ${username.text}',
          duration: const Duration(seconds: 5),
          margin: const EdgeInsets.all(8),
          backgroundColor: Colors.black54,
          colorText: Colors.white,
        );
        print('Login successful: $data');

        // Navigate to the HomeView
        Get.put(ProjectController()); // Ensure ProjectController is initialized
        Get.off(const HomeView());
      } else if (response.statusCode == 401) {
        // Invalid username or password
        Get.snackbar(
          'Login Failed',
          'Invalid username or password',
          duration: const Duration(seconds: 5),
          margin: const EdgeInsets.all(8),
          backgroundColor: Colors.black54,
          colorText: Colors.white,
        );
      } else {
        // Other errors
        Get.snackbar(
          'Error',
          'Login failed: ${response.body}',
          duration: const Duration(seconds: 5),
          margin: const EdgeInsets.all(8),
          backgroundColor: Colors.black54,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      // Handle any exceptions
      Get.back(); // Close loading dialog
      print('Error during login: $e');
      Get.snackbar(
        'Error',
        'An error occurred. Please try again later.',
        duration: const Duration(seconds: 5),
        margin: const EdgeInsets.all(8),
        backgroundColor: Colors.black54,
        colorText: Colors.white,
      );
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    print("Token deleted");

    Get.off(() => const LoginView());
  }
}


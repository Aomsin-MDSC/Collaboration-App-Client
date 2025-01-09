import 'dart:convert';
import 'package:collaboration_app_client/controllers/project_controller.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
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

        final fcmToken = await FirebaseMessaging.instance.getToken();
        if (fcmToken != null) {
          await saveTokenToDatabase(fcmToken, token); // Update token in DB
        }

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

  Future<void> saveTokenToDatabase(String fcmToken, String jwtToken) async {
    final userId = await getUserId();
    print("Device : $userId");
    try {
      final url = Uri.parse('http://10.24.8.16:5263/api/TokenDevice/$userId');
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_token': fcmToken, // Firebase token
        }),
      );

      if (response.statusCode == 200) {
        print('Device Token updated successfully!');
      } else {
        print('Failed to update token: ${response.body}');
      }
    } catch (e) {
      throw('Error updating token: $e');
    }
  }

  Future<int?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');
    if (token != null) {
      try {
        final decodedToken = JwtDecoder.decode(token);
        return decodedToken['userId'] != null ? int.tryParse(decodedToken['userId'].toString()) : null;
      } catch (e) {
        print('Error decoding token: $e');
      }
    }
    return null;
  }


  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    print("Token deleted");

    Get.off(() => const LoginView());
  }
}

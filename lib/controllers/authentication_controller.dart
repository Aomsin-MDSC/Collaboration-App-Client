import 'dart:convert';
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
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', token);
        print('Token saved: ${prefs.getString('jwt_token')}');

        final fcmToken = await FirebaseMessaging.instance.getToken();
        if (fcmToken != null) {
          await saveTokenToDatabase(fcmToken, token); // Update token in DB
        }

        // Show a success message
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Login Successfully.'),
              ],
            ),
            // behavior: SnackBarBehavior.floating,
            // margin: EdgeInsets.only(bottom: MediaQuery.of(Get.context!).size.height - 260, left: 15, right: 15),
            action: SnackBarAction(label: "OK", onPressed: () {}), //action
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
        print('Login successful: $data');
        
        // Navigate to the HomeView
        Get.offAll(() => const HomeView(), arguments: {'refresh': true});
      } else if (response.statusCode == 400) {
        try {
          if (response.body.isNotEmpty) {
            final responseData = json.decode(response.body);

            String errorMessage = responseData['message'];

            ScaffoldMessenger.of(Get.context!).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.warning, color: Colors.white),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        errorMessage,
                        style: const TextStyle(overflow: TextOverflow.ellipsis),
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                action: SnackBarAction(label: "OK", onPressed: () {}),
                backgroundColor: Colors.orange,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        } catch (e) {
          print('Error decoding response: $e');
          ScaffoldMessenger.of(Get.context!).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.error, color: Colors.white),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Failed to decode error response.',
                      style: TextStyle(overflow: TextOverflow.ellipsis),
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
              action: SnackBarAction(label: "OK", onPressed: () {}),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
      else if (response.statusCode == 401) {
        try {
          if (response.body.isNotEmpty) {
            final responseData = json.decode(response.body);

            String errorMessage = responseData['message'];

            ScaffoldMessenger.of(Get.context!).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.warning, color: Colors.white),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        errorMessage,
                        style: const TextStyle(overflow: TextOverflow.ellipsis),
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                action: SnackBarAction(label: "OK", onPressed: () {}),
                backgroundColor: Colors.orange,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        } catch (e) {
          print('Error decoding response: $e');
          ScaffoldMessenger.of(Get.context!).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.error, color: Colors.white),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Failed to decode error response.',
                      style: TextStyle(overflow: TextOverflow.ellipsis),
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
              action: SnackBarAction(label: "OK", onPressed: () {}),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
      else {
        // If status code is not 200 or 400, show a generic failure message
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                SizedBox(width: 8),
                Text('Login Failed.'),
              ],
            ),
            action: SnackBarAction(label: "OK", onPressed: () {}),
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
        throw Exception('Registration failed');
      }
    } catch (e) {
      // Handle any exceptions
      Get.back(); // Close loading dialog
      print('Error during login: $e');
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.cancel, color: Colors.white),
              SizedBox(width: 8),
              Text('Login Successfully.'),
            ],
          ),
          // behavior: SnackBarBehavior.floating,
          // margin: EdgeInsets.only(bottom: MediaQuery.of(Get.context!).size.height - 180, left: 15, right: 15),
          action: SnackBarAction(label: "OK", onPressed: () {}), //action
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 3),
        ),
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

  Future<void> deleteTokenToDatabase(int userId) async {
    try {
      final url = Uri.parse('http://10.24.8.16:5263/api/DeleteTokenDevice');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'UserId': userId, // Firebase token
        }),
      );

      if (response.statusCode == 200) {
        print('Device Token deleted successfully!');
      } else {
        print('Failed to delete token: ${response.body}');
      }
    } catch (e) {
      throw('Error deleting token: $e');
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

    final userId = await getUserId();
    print("DeleteDevice : $userId");

    if (userId != null) {
      await deleteTokenToDatabase(userId);
      print("Token deleted");
    } else {
      print("UserId is null. Unable to delete token.");
    }

    await prefs.remove('jwt_token');
    print("User Token deleted");

    Get.off(() => const LoginView());
  }
}

import 'dart:convert';

import 'package:collaboration_app_client/views/Login_View.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
        'user_name': username.text.trim(),
        'user_password': password.text.trim(),
      }),
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('Created Successfully.'),
            ],
          ),
          // behavior: SnackBarBehavior.floating,
          // margin: EdgeInsets.only(bottom: MediaQuery.of(Get.context!).size.height - 180, left: 15, right: 15),
          action: SnackBarAction(label: "OK", onPressed: () {}), //action
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: Duration(seconds: 3),
        ),
      );
      return print("success");
    } else {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.cancel, color: Colors.white),
              SizedBox(width: 8),
              Text('Create Failed.'),
            ],
          ),
          // behavior: SnackBarBehavior.floating,
          // margin: EdgeInsets.only(bottom: MediaQuery.of(Get.context!).size.height - 142, left: 15, right: 15),
          action: SnackBarAction(label: "OK", onPressed: () {}), //action
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: Duration(seconds: 3),
        ),
      );
      throw Exception('Registration failed');
    }
  }
}

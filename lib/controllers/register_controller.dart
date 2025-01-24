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

  Future<void> registerUser({Function? onCompleted = null}) async {
    try {
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
        if(onCompleted != null) onCompleted();
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Created Successfully.'),
              ],
            ),
            action: SnackBarAction(label: "OK", onPressed: () {}),
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: Duration(seconds: 3),
          ),
        );
      }
      if (response.statusCode == 400) {
        try {
          if (response.body.isNotEmpty) {
            final responseData = json.decode(response.body);

            String errorMessage = responseData['message'];

            ScaffoldMessenger.of(Get.context!).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.white),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        errorMessage,
                        style: TextStyle(overflow: TextOverflow.ellipsis),
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.orange,
                duration: Duration(seconds: 3),
              ),
            );
          }
        } catch (e) {
          print('Error decoding response: $e');
          ScaffoldMessenger.of(Get.context!).showSnackBar(
            SnackBar(
              content: Row(
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
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
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
                Icon(Icons.cancel, color: Colors.white),
                SizedBox(width: 8),
                Text('Create Failed.'),
              ],
            ),
            action: SnackBarAction(label: "OK", onPressed: () {}),
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: Duration(seconds: 3),
          ),
        );
        throw Exception('Registration failed');
      }
    } catch (error) {
      // Handle other errors (e.g. network issues, timeout)
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.white),
              SizedBox(width: 8),
              Text('An unexpected error occurred: $error'),
            ],
          ),
          action: SnackBarAction(label: "OK", onPressed: () {}),
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: Duration(seconds: 3),
        ),
      );
      print("Error occurred: $error");
    }
  }
}

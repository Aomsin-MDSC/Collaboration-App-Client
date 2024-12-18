import 'package:collaboration_app_client/controllers/login_controller.dart';
import 'package:collaboration_app_client/views/Login_View.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/register_controller.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<RegisterForm> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RegisterController());
    return Form(
        child: Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: controller.username,
            decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.person),
                // labelText: "Username",
                hintText: "Username",
                border: OutlineInputBorder()),
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: controller.password,
            decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.white,
              prefixIcon: Icon(Icons.fingerprint),
              // labelText: "Password",
              hintText: "Password",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black87),
                  onPressed: () {
                    controller.registerUser();
                  },
                  child: Text('register'.toUpperCase()))),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: TextButton(
              onPressed: () => (Get.to(const LoginView())),
              child: Text.rich(
                TextSpan(
                    text: "You Have An Account? ",
                    style: Theme.of(context).textTheme.bodyLarge,
                    children: [
                      TextSpan(
                          text: "login".toUpperCase(),
                          style: const TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold))
                    ]),
              ),
            ),
          )
        ],
      ),
    ));
  }
}

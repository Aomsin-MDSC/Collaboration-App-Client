import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/register_controller.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _LoginFormState();
}

bool _passwordVisible = true;

@override
void initState() {
  _passwordVisible;
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
            maxLength: 50,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              } else if (value.length > 50) {
                return 'Cannot exceed 50 characters';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            obscureText: _passwordVisible,
            controller: controller.password,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              prefixIcon: const Icon(Icons.fingerprint),
              // labelText: "Password",
              hintText: "Password",
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
                icon: _passwordVisible
                    ? const Icon(Icons.visibility_off_outlined)
                    : const Icon(Icons.visibility_outlined),
              ),
            ),
            maxLength: 50,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              } else if (value.length > 50) {
                return 'Cannot exceed 50 characters';
              }
              return null;
            },
            onFieldSubmitted: (_) async {
              await controller.registerUser(onCompleted: () {
                Get.back();
              });
            },
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
                  onPressed: () async {
                    await controller.registerUser(onCompleted: () {
                      Get.back();
                    });
                  },
                  child: Text('register'.toUpperCase()))),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: TextButton(
              onPressed: () {
                Get.back();
              },
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

import 'package:collaboration_app_client/controllers/register_controller.dart';
import 'package:collaboration_app_client/views/home_view.dart';
import 'package:collaboration_app_client/views/register_view.dart';
import 'package:collaboration_app_client/views/testfetch.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

bool _passwordVisible = true;

@override
void initState() {
  _passwordVisible;
}

class _LoginFormState extends State<LoginForm> {
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
          ),
          const SizedBox(
            height: 30,
          ),
          SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(foregroundColor: Colors.white, backgroundColor: Colors.black87),
                  onPressed: () => (
                        //text controller
                  Get.to(
                      // TestFetch()
                  HomeView()
                  )
                      ),
                  child: Text('Login'.toUpperCase())
              )
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: TextButton(
              onPressed: () => (Get.to(const RegisterView())),
              child: Text.rich(
                TextSpan(
                    text: "Don't Have An Account ",
                    style: Theme.of(context).textTheme.bodyLarge,
                    children: [
                      TextSpan(
                          text: "Signup".toUpperCase(),
                          style: const TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold))
                    ]),
              ),
            ),
          )
        ],
      ),
     )
    );
  }
}

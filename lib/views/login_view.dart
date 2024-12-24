import 'package:flutter/material.dart';
import 'login_assets/login_form.dart';
import 'login_assets/login_header.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [LoginHeader(),LoginForm()],
            ),
          ),
        ),
      ),
    );
  }
}

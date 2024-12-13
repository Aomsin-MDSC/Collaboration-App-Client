import 'package:collaboration_app_client/views/register_assets/register_form.dart';
import 'package:collaboration_app_client/views/register_assets/register_header.dart';
import 'package:flutter/material.dart';


class RegisterView extends StatelessWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(255, 237, 122, 2),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [RegisterHeader(),RegisterForm()],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'new_project_assets/edit_project_form.dart';


class EditProjectView extends StatelessWidget {
  const EditProjectView ({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(161, 182, 255, 1),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [EditProjectForm()],
            ),
          ),
        ),
      ),
    );
  }
}
import 'package:collaboration_app_client/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:collaboration_app_client/views/new_project_assets/new_project_form.dart';

class NewProjectView extends StatelessWidget {
  const NewProjectView ({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("NEW PROJECT",
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [NewProjectForm()],
            ),
          ),
        ),
      ),
    );
  }
}
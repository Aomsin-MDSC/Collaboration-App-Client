import 'package:collaboration_app_client/controllers/project_controller.dart';
import 'package:flutter/material.dart';
import 'package:collaboration_app_client/views/new_project_assets/new_project_form.dart';
import 'package:get/get.dart';

class NewProjectView extends StatelessWidget {
  const NewProjectView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProjectController());
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "NEW PROJECT",
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              final String? token = await controller.getToken();
              if (token != null && token.isNotEmpty) {
                controller.fetchApi(token);
                Get.back();
              } else {
                print("Token not found");
              }
            },
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

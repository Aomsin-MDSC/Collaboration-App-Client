import 'package:collaboration_app_client/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:collaboration_app_client/views/new_project_assets/new_project_form.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controllers/edit_project_controller.dart';
import '../controllers/new_project_controller.dart';

class NewProjectView extends StatelessWidget {
  const NewProjectView ({super.key});

  @override
  Widget build(BuildContext context) {
    // final int projectId = Get.arguments['projectId'];
    // final controller = Get.put(EditProjectController());
    // controller.loadProjectDetails(projectId);
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
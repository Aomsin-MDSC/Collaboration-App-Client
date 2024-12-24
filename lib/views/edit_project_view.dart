import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../controllers/edit_project_controller.dart';
import 'new_project_assets/edit_project_form.dart';


class EditProjectView extends StatelessWidget {
  const EditProjectView ({super.key});

  @override
  Widget build(BuildContext context) {
    // final int projectId = Get.arguments['projectId'];
    final controller = Get.put(EditProjectController());
    // controller.loadProjectDetails(projectId);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("EDIT PROJECT",
          ),
        ),
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
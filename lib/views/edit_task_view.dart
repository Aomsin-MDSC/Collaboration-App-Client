import 'package:collaboration_app_client/controllers/in_project_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'new_task_assets/edit_task_form.dart';

class EditTaskView extends StatelessWidget {
  const EditTaskView ({super.key});

  @override
  Widget build(BuildContext context) {
    final Taskcontroller = Get.put(TaskController());
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("EDIT TASK",
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed:() async{
              await Taskcontroller.fetchTask(Taskcontroller.projectId);
              Get.back();
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [EditTaskForm()],
            ),
          ),
        ),
      ),
    );
  }
}
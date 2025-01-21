import 'package:collaboration_app_client/controllers/in_project_controller.dart';
import 'package:collaboration_app_client/views/new_task_assets/new_task_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewTaskView extends StatelessWidget {
  const NewTaskView ({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TaskController());
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("NEW TASK",
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed:() async{
              await controller.fetchTask(controller.projectId);
              Get.back();
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [NewTaskForm()],
            ),
          ),
        ),
      ),
    );
  }
}
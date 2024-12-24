import 'package:flutter/material.dart';
import 'new_task_assets/edit_task_form.dart';

class EditTaskView extends StatelessWidget {
  const EditTaskView ({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("EDIT TASK",
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
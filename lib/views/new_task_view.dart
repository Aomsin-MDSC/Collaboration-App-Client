import 'package:collaboration_app_client/views/new_task_assets/new_task_form.dart';
import 'package:flutter/material.dart';

class NewTaskView extends StatelessWidget {
  const NewTaskView ({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(150, 180, 80, 1),
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
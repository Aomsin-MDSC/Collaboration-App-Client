import 'package:collaboration_app_client/models/project_model.dart';
import 'package:collaboration_app_client/views/edit_project_view.dart';
import 'package:collaboration_app_client/views/project_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProjectCard extends StatelessWidget {
  final Project project;

  const ProjectCard({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        // padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero), // Set padding to zero
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        ),
      ),
      onPressed: () {
        Get.to(() => const ProjectView());
      },
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ListTile(
                title: Text(project.projectName),
                subtitle: Text(project.tagName),
                trailing: IconButton(
                  onPressed: () {
                    Get.to(() => const EditProjectView());
                  },
                  icon: const Icon(Icons.settings),
                  iconSize: 30,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

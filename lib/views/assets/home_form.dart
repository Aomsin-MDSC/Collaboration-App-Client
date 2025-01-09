import 'package:collaboration_app_client/models/project_model.dart';
import 'package:collaboration_app_client/views/edit_project_view.dart';
import 'package:collaboration_app_client/views/project_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ProjectCard extends StatelessWidget {
  final Project project;
  final int currentUserId;

  const ProjectCard(
      {super.key, required this.project, required this.currentUserId});

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
        Get.to(() => const ProjectView(), arguments: {
          'projectId': project.projectId,
          'tagId': project.tagId
        });
      },
      child: Card(
        color: Colors.white,
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ListTile(
                title: Row(
                  children: [
                    Text(project.projectName),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent, // api color
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        "ssss", //api tag
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                subtitle: Text('Owner: ${project.userName}'), // api user
                trailing: project.userId == currentUserId
                    ? IconButton(
                        onPressed: () {
                          print('User ID matches, navigating to edit');
                          Get.to(
                            EditProjectView(),
                            arguments: {
                              'projectId': project.projectId,
                              'tagId': project.tagId,
                            },
                          );
                        },
                        icon: const Icon(Icons.settings),
                        iconSize: 30,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

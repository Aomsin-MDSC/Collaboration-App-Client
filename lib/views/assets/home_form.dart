import 'package:collaboration_app_client/models/project_model.dart';
import 'package:collaboration_app_client/models/tag_model.dart';
import 'package:collaboration_app_client/views/edit_project_view.dart';
import 'package:collaboration_app_client/views/project_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controllers/tag_controller.dart';

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
          'projectName': project.projectName,
          'tagId': project.tagId,
          'userId' : project.userId,
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
                    Flexible(
                      child: Text(
                        project.projectName,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    if (project.tagId != -1) Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: Color(int.parse('0xFF' + project.tagColor.substring(1))), // api color
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          project.tagName, // api tag
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
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
                          print('Project User ID: ${project.userId}');
                          print('Current User ID: $currentUserId');
                          print('Current tag: ${project.tagId}');
                          Get.to(
                            EditProjectView(),
                            arguments: {
                              'projectId': project.projectId,
                              'projectName': project.projectName,
                              'tagId': project.tagId,
                              // 'refresh': true,
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

import 'package:collaboration_app_client/models/project_model.dart';
import 'package:collaboration_app_client/models/tag_model.dart';
import 'package:collaboration_app_client/views/edit_project_view.dart';
import 'package:collaboration_app_client/views/project_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controllers/project_controller.dart';
import '../../controllers/tag_controller.dart';

class ProjectCard extends StatelessWidget {
  final Project project;
  final int currentUserId;

  const ProjectCard(
      {super.key, required this.project, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TagController());
    final projectcontroll = Get.put(ProjectController());

    return FutureBuilder<int?>(
      future: projectcontroll.fetchMemberRole(project.projectId, currentUserId),
      builder: (context, snapshot) {
        final canEdit = snapshot.data == 0;

        return TextButton(
          style: ButtonStyle(
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
            ),
          ),
          onPressed: () async {
            await controller.fetchTagMap(project.tagId);
            Get.to(() => const ProjectView(), arguments: {
              'projectId': project.projectId,
              'tagId': project.tagId,
              'userId': project.userId,
              'projectName': project.projectName,
              'canEdit': canEdit,
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
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            project.projectName,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        SizedBox(height: 10),
                        if (project.tagId != -1)
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5),
                              decoration: BoxDecoration(
                                color: Color(int.parse(
                                    '0xFF' + project.tagColor.substring(1))),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                project.tagName,
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
                    trailing: canEdit
                        ? IconButton(
                      onPressed: () async {
                        await controller.fetchTagMap(project.tagId);
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
      },
    );
  }
}

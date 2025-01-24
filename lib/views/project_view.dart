import 'package:collaboration_app_client/utils/color.dart';
import 'package:collaboration_app_client/views/edit_project_view.dart';
import 'package:collaboration_app_client/views/new_announce_view.dart';
import 'package:collaboration_app_client/views/project_assets/project_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/in_project_controller.dart';
import '../controllers/project_controller.dart';
import '../views/new_task_view.dart';
import 'widgets/expandable_fab_widget.dart';

class ProjectView extends StatefulWidget {
  const ProjectView({super.key});

  @override
  State<ProjectView> createState() => _ProjectViewState();
}

class _ProjectViewState extends State<ProjectView> {
  final int projectId = Get.arguments['projectId'];
  final int tagId = Get.arguments['tagId'];
  final int userId = Get.arguments['userId'];
  final bool canEdit = Get.arguments['canEdit'];

  @override
  void initState() {
    super.initState();
    Get.put(ProjectController());
    Get.put(TaskController());
    TaskController.instance.fetchTask(projectId);
  }

  @override
  Widget build(BuildContext context) {
    final ProjectController projectController = Get.find<ProjectController>();
    final controller = Get.put(ProjectController());

    String projectName = projectController.project.value
        .firstWhere((value) => value.projectId == projectId)
        .projectName;

    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          title: Text(projectName),
                          // content: Text("if want ?"),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                final String? token =
                                    await controller.getToken();
                                if (token != null && token.isNotEmpty) {
                                  controller.fetchApi(token);
                                  Get.back();
                                } else {
                                  print("Token not found");
                                }
                              },
                              child: const Text("CLOSE"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text(
                    projectName,
                    style: const TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      overflow: TextOverflow.ellipsis, //same
                    ),
                    // overflow: TextOverflow.ellipsis, //same
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 20, right: 20),
            child: canEdit
                ? ExpandableFab(
                    distance: 70,
                    children: [
                      Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              FloatingActionButton.extended(
                                heroTag: null,
                                label: const Text(
                                  "New Announce",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                                backgroundColor: btcolor,
                                icon: const Icon(Icons
                                    .announcement), // Toggle between search and close icon
                                onPressed: () {
                                  Get.to(const NewAnnounceView(), arguments: {
                                    'projectId': projectId,
                                    'tagId': tagId,
                                    'userId': userId
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const SizedBox(width: 20),
                              FloatingActionButton.extended(
                                label: const Text("Edit Project",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold)),
                                heroTag: null,
                                backgroundColor: btcolor,
                                icon: const Icon(Icons.edit),
                                onPressed: () async {
                                  print('Button Pressed, Project ID: ${projectController.project.first}');
                            //  await  tagController.fetchTagMap(projectController.project.firstWhere((element) => element.userId == projectController.userId).tagId);

                                  // final product = projectController.project[index];
                                  Get.to( const EditProjectView(), arguments: {
                                    'projectId': projectId,
                                    'tagId': tagId,
                                  });
                                  // arguments: {'projectId': project.projectId});
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 35),
                                child: FloatingActionButton.extended(
                                  label: const Text(
                                    textAlign: TextAlign.center,
                                    "New Task",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  heroTag: null,
                                  backgroundColor: btcolor,
                                  icon: const Icon(Icons.task),
                                  onPressed: () {
                                    Get.to(() => const NewTaskView(), arguments: {
                                      'projectId': projectId,
                                      'tagId': tagId,
                                      'userId': userId,
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  )
                  : Container(),
          ),
          body: const Padding(
            padding: EdgeInsets.all(8.0),
            child: ProjectForm(),
          )),
    );
  }
}

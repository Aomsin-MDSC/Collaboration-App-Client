import 'package:collaboration_app_client/utils/color.dart';
import 'package:collaboration_app_client/views/edit_announce_view.dart';
import 'package:collaboration_app_client/views/edit_project_view.dart';
import 'package:collaboration_app_client/views/new_announce_view.dart';
import 'package:collaboration_app_client/views/project_assets/project_form.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:get/get.dart';
import '../controllers/announce_controller.dart';
import '../controllers/in_project_controller.dart';
import '../controllers/new_announce_controller.dart';
import '../controllers/new_task_controller.dart';
import '../controllers/project_controller.dart';
import '../models/project_model.dart';
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
  //final String projectName = Get.arguments['projectName'];

  // late final NewTaskController newTaskController;
  // final Map<int, bool> toggleStates = {}; // Track toggle states by index
  // String searchQuery = ''; // Track the search query
  // bool isSearchVisible = false; // To control the visibility of the search bar
  // // final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Get.put(ProjectController());

    Get.put(TaskController());
    TaskController.instance.fetchTask(projectId);

    // final projectController = Get.put(ProjectController());
    // Future.delayed(Duration.zero, () async {
    //   String? token = await projectController.getToken();
    //   if (token != null && token.isNotEmpty) {
    //     projectController.fetchApi(token);
    //   } else {
    //     print("Token not found");
    //   }
    // });

    // Get.put(NewAnnounceController());
    // NewAnnounceController.instance.createAnnounce(projectId);

    // Get.put(AnnounceController());
    // AnnounceController.instance.fetchAnnounce(projectId);

    // Get.put(NewTaskController());
    // NewTaskController.instance.createTask(projectId,userId);

    // newTaskController = Get.put(NewTaskController());
  }

  @override
  Widget build(BuildContext context) {
    final ProjectController projectController = Get.find<ProjectController>();
    int currentUserId = projectController.userId.value;
    final controller = Get.put(ProjectController());

    String projectName = projectController.project.value
        .firstWhere((value) => value.projectId == projectId)
        .projectName;

    // Check if the keyboard is visible using MediaQuery
    bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

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
                              child: Text("CLOSE"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text(
                    projectName,
                    style: TextStyle(
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
            child: userId != currentUserId
                ? null // Hide FAB when the keyboard is visible
                : ExpandableFab(
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
                                  print(
                                      'Button Pressed, Project ID: $projectId');
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
                                onPressed: () {
                                  // final product = projectController.project[index];
                                  Get.to(const EditProjectView(), arguments: {
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
                                    Get.to(() => NewTaskView(), arguments: {
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
                  ),
          ),
          body: const Padding(
            padding: EdgeInsets.all(8.0),
            child: ProjectForm(),
          )),
    );
  }
}

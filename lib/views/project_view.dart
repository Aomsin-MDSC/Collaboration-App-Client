import 'package:collaboration_app_client/utils/color.dart';
import 'package:collaboration_app_client/views/edit_announce_view.dart';
import 'package:collaboration_app_client/views/edit_project_view.dart';
import 'package:collaboration_app_client/views/new_announce_view.dart';
import 'package:collaboration_app_client/views/project_assets/project_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:get/get.dart';
import '../controllers/new_task_controller.dart';
import '../controllers/project_controller.dart';
import '../views/new_task_view.dart';

class ProjectView extends StatefulWidget {
  const ProjectView({super.key});

  @override
  State<ProjectView> createState() => _ProjectViewState();
}

class _ProjectViewState extends State<ProjectView> {
  // late final NewTaskController newTaskController;
  // final Map<int, bool> toggleStates = {}; // Track toggle states by index
  // String searchQuery = ''; // Track the search query
  // bool isSearchVisible = false; // To control the visibility of the search bar
  // // final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Get.put(ProjectController());
    // newTaskController = Get.put(NewTaskController());
  }


  @override
  Widget build(BuildContext context) {
    final ProjectController projectController = Get.find<ProjectController>();

    // Check if the keyboard is visible using MediaQuery
    bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Project Page"),
          ),
          floatingActionButtonLocation: ExpandableFab.location,
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 20, right: 20),
            child: isKeyboardVisible
                ? null // Hide FAB when the keyboard is visible
                : ExpandableFab(
                    childrenAnimation: ExpandableFabAnimation.rotate,
                    distance: 70,
                    openButtonBuilder: RotateFloatingActionButtonBuilder(
                        angle: -3.14 / 2,
                        fabSize: ExpandableFabSize.regular,
                        backgroundColor: btcolor,
                        child: const Icon(Icons.add)),
                    closeButtonBuilder: RotateFloatingActionButtonBuilder(
                        angle: -3.14 / 2,
                        fabSize: ExpandableFabSize.regular,
                        backgroundColor: btcolor,
                        child: const Icon(Icons.close)),
                    type: ExpandableFabType.fan,
                    pos: ExpandableFabPos.right,
                    fanAngle: 180,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10, right: 50),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  "Edit Project",
                                  style: TextStyle(
                                      fontSize: 17, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 20),
                                FloatingActionButton.small(
                                  heroTag: null,
                                  backgroundColor: btcolor,
                                  child: const Icon(Icons.edit),
                                  onPressed: () {
                                    // final product = projectController.project[index];
                                      Get.to(EditProjectView());
                                      // arguments: {'projectId': project.projectId});
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(width: 20),
                            Row(
                              children: [
                                const Text(
                                  "New Task",
                                  style: TextStyle(
                                      fontSize: 17, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 35),
                                FloatingActionButton.small(
                                  heroTag: null,
                                  backgroundColor: btcolor,
                                  child: const Icon(Icons.task),
                                  onPressed: () {
                                    Get.to(const NewTaskView());
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(width: 10),
                            Row(
                              children: [
                                const Text(
                                  "New Announce",
                                  style: TextStyle(
                                      fontSize: 17, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10),
                                FloatingActionButton.small(
                                  heroTag: null,
                                  backgroundColor: btcolor,
                                  child: const Icon(Icons
                                      .announcement), // Toggle between search and close icon
                                  onPressed: () {
                                    Get.to(const NewAnnounceView());
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
          body: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [Flexible(child: ProjectForm())],
            ),
          )),
    );
  }
}

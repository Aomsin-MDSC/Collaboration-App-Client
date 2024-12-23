import 'package:collaboration_app_client/views/edit_task_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:get/get.dart';
import '../controllers/new_task_controller.dart';
import '../controllers/project_controller.dart';
import '../views/new_project_view.dart';
import '../views/new_task_view.dart';

class ProjectView extends StatefulWidget {
  const ProjectView({super.key});

  @override
  State<ProjectView> createState() => _ProjectViewState();
}

class _ProjectViewState extends State<ProjectView> {
  late final NewTaskController newTaskController;
  final Map<int, bool> toggleStates = {}; // Track toggle states by index
  String searchQuery = ''; // Track the search query
  bool isSearchVisible = false; // To control the visibility of the search bar
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Get.put(ProjectController());
    newTaskController = Get.put(NewTaskController());
  }

  @override
  Widget build(BuildContext context) {
    // Check if the keyboard is visible using MediaQuery
    bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          title: const Text("Project Page"),
        ),
        floatingActionButtonLocation: ExpandableFab.location,
        floatingActionButton: isKeyboardVisible
            ? null // Hide FAB when the keyboard is visible
            : ExpandableFab(
                childrenAnimation: ExpandableFabAnimation.rotate,
                distance: 117,
                openButtonBuilder: RotateFloatingActionButtonBuilder(
                    angle: -3.14 / 2,
                    fabSize: ExpandableFabSize.large,
                    child: const Icon(Icons.add)),
                closeButtonBuilder: RotateFloatingActionButtonBuilder(
                    angle: -3.14 / 2,
                    fabSize: ExpandableFabSize.large,
                    child: const Icon(Icons.close)),
                type: ExpandableFabType.fan,
                pos: ExpandableFabPos.center,
                fanAngle: 180,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 110),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            const Text(
                              "New Project",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            FloatingActionButton.large(
                              heroTag: null,
                              child: const Icon(Icons.edit),
                              onPressed: () {
                                Get.to(const NewProjectView());
                              },
                            ),
                          ],
                        ),
                        const SizedBox(width: 20),
                        Column(
                          children: [
                            const Text(
                              "New Task",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            FloatingActionButton.large(
                              heroTag: null,
                              child: const Icon(Icons.task),
                              onPressed: () {
                                Get.to(const NewTaskView());
                              },
                            ),
                          ],
                        ),
                        const SizedBox(width: 20),
                        Column(
                          children: [
                            const Text(
                              "Search",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            FloatingActionButton.large(
                              heroTag: null,
                              child: Icon(isSearchVisible
                                  ? Icons.close
                                  : Icons
                                      .search), // Toggle between search and close icon
                              onPressed: () {
                                setState(() {
                                  isSearchVisible =
                                      !isSearchVisible; // Toggle search visibility
                                });

                                if (isSearchVisible) {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                } else {
                                  _searchController.clear();
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Conditionally show the search bar with animation
              AnimatedOpacity(
                opacity: isSearchVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300), // Shorter duration
                child: Visibility(
                  visible: isSearchVisible,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 15, right: 15),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: 'Search',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchQuery =
                              value.toLowerCase(); // Update search query
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Obx(() {
                  final filteredList = newTaskController.taskList.where((task) {
                    return task.taskName!.toLowerCase().contains(searchQuery);
                  }).toList();

                  return RefreshIndicator(
                    onRefresh: () async {
                      newTaskController.taskList.refresh();
                    },
                    child: ReorderableListView.builder(
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final taskList = filteredList[index];

                        return TextButton(
                          key: ValueKey(taskList),
                          onPressed: () {
                            // Api Here
                            Get.to(const EditTaskView());
                          },
                          child: Card(
                            margin: const EdgeInsets.all(0),
                            child: ListTile(
                              title: Text(taskList.taskName!),
                              subtitle: Text(taskList.taskName!),
                              trailing: // Toggle switch is Not following the List
                                  Switch(
                                value: taskList.isToggled,
                                inactiveTrackColor:
                                    const Color.fromARGB(255, 241, 130, 130),
                                activeColor: Colors.green,
                                onChanged: (bool value) {
                                  setState(() {
                                    taskList.isToggled = value;
                                  });
                                },
                              ),
                            ),
                          ),
                        );
                      },
                      proxyDecorator: (Widget child, int index,
                          Animation<double> animation) {
                        return Material(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: child,
                          ),
                        );
                      },
                      onReorder: (int oldIndex, int newIndex) {
                        if (newIndex > oldIndex) {
                          newIndex -= 1;
                        }
                        final items =
                            newTaskController.taskList.removeAt(oldIndex);
                        newTaskController.taskList.insert(newIndex, items);
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:collaboration_app_client/controllers/in_project_controller.dart';
import 'package:collaboration_app_client/controllers/new_task_controller.dart';
import 'package:collaboration_app_client/controllers/project_controller.dart';
import 'package:collaboration_app_client/views/edit_task_view.dart';
import 'package:collaboration_app_client/views/task_page_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class ProjectForm extends StatefulWidget {
  const ProjectForm({super.key});

  @override
  State<ProjectForm> createState() => _ProjectFormState();
}

class _ProjectFormState extends State<ProjectForm> {
  late final NewTaskController newTaskController;
  final Map<int, bool> toggleStates = {}; // Track toggle states by index
  String searchQuery = ''; // Track the search query
  bool isSearchVisible = false; // To control the visibility of the search bar
  // final TextEditingController _searchController = TextEditingController();
  final controller = Get.put(TaskController());

  @override
  void initState() {
    super.initState();
    Get.put(TaskController());
    newTaskController = Get.put(NewTaskController());
  }

  @override
  Widget build(BuildContext context) {
    final TaskController taskController = Get.find<TaskController>();
    final Map<String, dynamic> arguments = Get.arguments;
    final int projectId = arguments['projectId'];

    final List<String> announce = [
      "Announce 1",
      "Announce 2",
      "Announce 3",
      "Announce 4",
      "Announce 5",
      "Announce 6",
      "Announce 7",
      "Announce 8",
      "Announce 9",
      "Announce 10",
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Conditionally show the search bar with animation
        CarouselSlider(
          options: CarouselOptions(
              height: 100,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3)),
          items: announce.map((i) {
            return Builder(
              builder: (BuildContext context) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text(
                        i,
                        style: const TextStyle(fontSize: 16.0),
                        textAlign: TextAlign.center,
                      )),
                );
              },
            );
          }).toList(),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
          child: TextField(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              labelText: 'Search',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onChanged: (value) {
              setState(() {
                searchQuery = value.toLowerCase(); // Update search query
              });
            },
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: Obx(() {
            final filteredList = taskController.task.where((task) {
              return task.taskName
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase());
            }).toList();
            return RefreshIndicator(
              onRefresh: () async {
                taskController.fetchTask(projectId);
              },
              child: ReorderableListView.builder(
                padding: EdgeInsets.only(bottom: 120),
                shrinkWrap: true,
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final taskList = filteredList[index];

                  return TextButton(
                      key: ValueKey(taskList.taskId),
                      onPressed: () {
                        // Api Here
                        Get.to(const TaskPageView());
                      },
                      child: Card(
                        color: Colors.white,
                        margin: const EdgeInsets.all(0),
                        child: ListTile(
                          title: Row(
                            children: [
                              Text(taskList.taskName!), // api
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent, // api color
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  "ssss", // api tag
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          subtitle: Text("Owner ???"), // api user
                          trailing: AnimatedToggleSwitch<bool>.dual(
                            indicatorSize: const Size.fromWidth(40),
                            height: 45,
                            current: taskList.taskStatus,
                            first: false,
                            second: true,
                            style: const ToggleStyle(
                              borderColor: Colors.transparent,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            onChanged: (value) async {
                              // API Here
                              await TaskController.instance
                                  .updateTaskStatus(taskList.taskId, value);
                              await taskController.fetchTask(projectId);
                            },
                            textBuilder: (value) => value
                                ? const Center(
                                    child: Text(
                                      'Done',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                : const Center(
                                    child: Text(
                                      'Pending  ',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                            styleBuilder: (value) => value
                                ? ToggleStyle(
                                    backgroundColor: Colors.green,
                                    indicatorColor: Colors.white,
                                    indicatorBorder: Border.all(
                                      color: Colors.green,
                                      width: 3,
                                    ))
                                : const ToggleStyle(
                                    backgroundColor: Colors.redAccent,
                                    indicatorColor: Colors.white,
                                  ),
                          ),
                        ),
                      ));
                },
                proxyDecorator:
                    (Widget child, int index, Animation<double> animation) {
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
                  //Api Here
                  final items = newTaskController.taskList.removeAt(oldIndex);
                  newTaskController.taskList.insert(newIndex, items);
                },
              ),
            );
          }),
        ),
      ],
    );
  }
}

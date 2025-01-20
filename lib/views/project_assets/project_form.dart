import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:collaboration_app_client/controllers/in_project_controller.dart';
import 'package:collaboration_app_client/controllers/new_project_controller.dart';
import 'package:collaboration_app_client/controllers/new_task_controller.dart';
import 'package:collaboration_app_client/controllers/project_controller.dart';
import 'package:collaboration_app_client/utils/color.dart';
import 'package:collaboration_app_client/views/edit_announce_view.dart';
import 'package:collaboration_app_client/views/edit_task_view.dart';
import 'package:collaboration_app_client/views/task_page_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controllers/announce_controller.dart';

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
  final announcecontroller = Get.put(AnnounceController());
  final projectcontroller = Get.put(ProjectController());
  late int projectId;
  final tagId = Get.arguments['tagId'];
  final userId = Get.arguments['userId'];

  @override
  void initState() {
    super.initState();
    newTaskController = Get.put(NewTaskController());
    final Map<String, dynamic> arguments = Get.arguments;
    projectId = arguments['projectId'];
    announcecontroller.fetchAnnounce(projectId);

    final getUser = Get.put(NewProjectController());
    getUser.membersMap.value = {};
    Future.delayed(Duration.zero, () async {
      String? token = await getToken();
      await getUser.fetchMembers(token!);
    });
  }


  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  @override
  Widget build(BuildContext context) {
    final refresh = Get.arguments?['refresh'] ?? false;

    if (refresh) {
      Future.delayed(Duration.zero, () async {
        controller.fetchTask(projectId);
      });
    }

    final TaskController taskController = Get.find<TaskController>();
    final getUser = Get.put(NewProjectController());
    final project = Get.find<ProjectController>();

    final ProjectController projectController = Get.find<ProjectController>();
    int currentUserId = projectController.userId.value;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // CarouselSlider with a fallback for empty data
        Obx(() {
          if (announcecontroller.announces.isEmpty) {
            return Container();
          }
          return CarouselSlider.builder(
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height * 0.15,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
            ),
            itemCount: announcecontroller.announces.length,
            itemBuilder: (context, index, realIndex) {
              final announce = announcecontroller.announces[index];
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          title: Text(announce.announceTitle),
                          content: Text(announce.announceText),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: const Text('Close'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 2, horizontal: 2), // ขยายพื้นที่กด
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // มุมโค้งของปุ่ม
                    ),
                  ),
                  child: Card(
                    color: Colors.white,
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(
                            announce.announceTitle,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(fontSize: 16),
                          ),
                          subtitle: Text(
                            announce.announceText,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.grey),
                          ),
                          trailing: projectcontroller.userId == announce.userId
                              ? IconButton(
                                  onPressed: () {
                                    final announceId = announce.announceId;
                                    print("PAOM${announce.announceTitle}");
                                    if (announceId != null) {
                                      Get.to(
                                        EditAnnounceView(),
                                        arguments: {
                                          'announceId': announceId,
                                          'projectId': projectId,
                                          'tagId': tagId,
                                          'userId': userId,
                                          'announceTitle':
                                              announce.announceTitle,
                                          'announceText': announce.announceText,
                                          'announceDate': announce.announceDate,
                                        },
                                      )?.then((result) {
                                        if (result == true) {
                                          print('Project Form::::::::: Result form get.back() $result');
                                          Future.delayed(Duration.zero,
                                              () async {
                                            await announcecontroller
                                                .fetchAnnounce(projectId);
                                            await controller
                                                .fetchTask(projectId);
                                            // print(announcecontroller.announces.firstWhere((t) => t.announceId == t.announceId).announceText);
                                          });
                                          setState(() {
                                          });
                                        }
                                      });
                                    } else {
                                      print('Announce ID is null');
                                    }
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
        }),
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
                    .contains(searchQuery.toLowerCase()) ||
                  task.tagName
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase());
            }).toList();
            return RefreshIndicator(
              onRefresh: () async {
                taskController.fetchTask(projectId);
                announcecontroller.fetchAnnounce(projectId);
              },
              child: ReorderableListView.builder(
                padding: EdgeInsets.only(bottom: 120),
                shrinkWrap: true,
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final taskList = filteredList[index];
                  final tagColor = HexColor.fromHex(taskList.taskColor);
                  final brightness = tagColor.computeLuminance();
                  final textColor =
                      brightness > 0.5 ? Colors.black : Colors.white;

                  return TextButton(
                      key: ValueKey(taskList.taskId),
                      onPressed: () {
                        // Api Here
                        print(taskList.taskId);
                        Get.to(TaskPageView(taskId: taskList.taskId),
                            arguments: {
                              'projectId': projectId,
                              'taskId': taskList.taskId,
                              'tagId': tagId,
                              /* 'tagColor': taskList.tagColor,
                              'tagName': taskList.tagName, */
                              'taskColor': taskList.taskColor,
                              'userId': userId
                            });
                      },
                      child: Card(
                        color: HexColor(taskList.taskColor),
                        margin: const EdgeInsets.all(0),
                        child: ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  taskList.taskName!, // api
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style:
                                      TextStyle(fontSize: 16, color: textColor),
                                ),
                              ),

                        
                              Text(
                                getUser.membersMap.containsKey(taskList.taskOwner)
                                    ? "Owner: ${getUser.membersMap[taskList.taskOwner]}"
                                    : "Owner: ${taskList.userName}",
                                style: TextStyle(color: textColor),
                              ),

                              SizedBox(
                                height: 10,
                              ),
                              if (taskList.tagId != -1) Flexible(
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  decoration: BoxDecoration(
                                    color: HexColor(
                                        taskList.tagColor), // api color
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    taskList.tagName, // api tag
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                          // subtitle: if u want
                          trailing: AnimatedToggleSwitch<bool>.dual(
                            indicatorSize: const Size.fromWidth(40),
                            active: taskList.taskOwner == project.userId.toInt()
                                ? true
                                : false,
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
                              await TaskController.instance.updateTaskStatus(
                                  taskList.taskId, value, taskList.taskName);
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
                onReorder: (int oldIndex, int newIndex) async {
                  if (userId == currentUserId) {
                    if (newIndex > oldIndex) {
                      newIndex -= 1;
                    }

                    final movedTask = filteredList.removeAt(oldIndex);
                    filteredList.insert(newIndex, movedTask);

                    for (int i = 0; i < filteredList.length; i++) {
                      filteredList[i].taskOrder = i + 1;
                    }
                    await controller.updateTaskOrder(filteredList);

                    await taskController.fetchTask(projectId);
                  }
                },
              ),
            );
          }),
        ),
      ],
    );
  }
}

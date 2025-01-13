import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:collaboration_app_client/controllers/edit_project_controller.dart';
import 'package:collaboration_app_client/controllers/in_project_controller.dart';
import 'package:collaboration_app_client/controllers/new_project_controller.dart';
import 'package:collaboration_app_client/controllers/new_tag_controller.dart';
import 'package:collaboration_app_client/controllers/new_task_controller.dart';
import 'package:collaboration_app_client/controllers/tag_controller.dart';
import 'package:collaboration_app_client/controllers/task_page_controller.dart';
import 'package:collaboration_app_client/models/comment_model.dart';
import 'package:collaboration_app_client/utils/color.dart';
import 'package:collaboration_app_client/views/edit_project_view.dart';
import 'package:collaboration_app_client/views/edit_task_view.dart';
import 'package:collaboration_app_client/views/widgets/comment_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/edit_announce_controller.dart';

class TaskPageForm extends StatefulWidget {
  final int taskId;
  const TaskPageForm({
    super.key,
    required this.taskId,
  });

  @override
  State<TaskPageForm> createState() => _TaskPageFormState();
}

class _TaskPageFormState extends State<TaskPageForm> {
  // final Map<String, dynamic> arguments = Get.arguments;
  final int projectId = Get.arguments['projectId'];
  final int taskId = Get.arguments['taskId'];
  final int tagId = Get.arguments['tagId'];

  @override
  Widget build(BuildContext context) {
    final TaskController taskController = Get.find<TaskController>();

    if (projectId == null || taskId == null) {
      // Handle the error case, such as showing a fallback or navigating back
      print("Missing projectId or taskId");
      return Center(child: Text("Error: Missing projectId or taskId"));
    }



    final controller = Get.put(TaskPageController());
    final taskDetails = Get.put(TaskController());
    final getuser = Get.put(NewProjectController());
    final getTag = Get.put(TagController());

    String taskName = taskDetails.task.value
        .firstWhere((element) => element.taskId == widget.taskId)
        .taskName;
    String taskDetail = taskDetails.task.value
        .firstWhere((element) => element.taskId == widget.taskId)
        .taskDetail;
    String taskEnd = taskDetails.task.value
        .firstWhere((element) => element.taskId == widget.taskId)
        .taskEnd;

    int taskOwner = taskDetails.task.value
        .firstWhere((element) => element.taskId == widget.taskId)
        .taskOwner;

    String userName = taskDetails.task.value
        .firstWhere((element) => element.taskOwner == taskOwner)
        .userName;

    int tag_id = taskDetails.task.value
        .firstWhere((element) => element.taskId == widget.taskId)
        .tagId;
    int task_id = taskDetails.task.value
        .firstWhere((element) => element.taskId == widget.taskId)
        .taskId;

    String tagcolor = taskDetails.task.value
        .firstWhere((element) => element.taskId == widget.taskId)
        .taskColor;

    return Form(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title with Icon
                Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          taskName,
                          style: const TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.edit,
                        size: 30,
                      ),
                      onPressed: () {
                        // api
                        // print(tagId);
                        Get.to(EditTaskView(),
                          arguments: {
                            'projectId': projectId,
                            'taskId': taskId,
                            'tagId': tagId,
                          },);
                      },
                    )
                  ],
                ),
                const SizedBox(height: 20),
                // Details Section
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                    children: [
                      TextSpan(
                        text: "Details: ",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: taskDetail.isNotEmpty ? taskDetail : "NO Data",
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                    children: [
                      const TextSpan(
                        text: "Assigned to : ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: getuser.memberlist[taskOwner - 1],
                        style: const TextStyle(fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    children: [
                      TextSpan(
                        text: "Deadline: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: taskEnd,
                        style: TextStyle(fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  children: [
                    FutureBuilder(
                      future: getTag.fetchTagMap(tag_id),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          final tagColor = HexColor.fromHex(tagcolor);
                          final brightness = tagColor.computeLuminance();
                          final textColor =
                              brightness > 0.5 ? Colors.black : Colors.white;
                          return Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: tagColor, // api color
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              snapshot.data ?? 'No Tag',
                              style: TextStyle(color: textColor),
                            ), // api tag
                          );
                        }
                      },
                    ),
                    const Spacer(),
                    AnimatedToggleSwitch<bool>.dual(
                        height: 40, // Fixed height for toggle
                        current: taskDetails.task.value
                            .firstWhere(
                                (element) => element.taskId == widget.taskId)
                            .taskStatus,
                        first: false,
                        second: true,
                        onChanged: (value) async {
                          // API Here
                          await TaskController.instance
                              .updateTaskStatus(task_id, value);
                          await taskController.fetchTask(projectId);
                          setState(() {
                            taskDetails.task.value
                                .firstWhere((element) =>
                                    element.taskId == widget.taskId)
                                .taskStatus = value;
                          });
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
                                  'Pending',
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
                            : ToggleStyle(
                                backgroundColor: Colors.redAccent,
                                indicatorColor: Colors.white,
                                indicatorBorder: Border.all(
                                  color: Colors.redAccent,
                                  width: 3,
                                ))),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Obx(() {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title with Icon
                  const Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Comment",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(
                    color: Colors.grey,
                    thickness: 2,
                  ),
                  const SizedBox(height: 10),
                  ...controller.comments.map((comment) {
                    return CommentWidget(comment: comment);
                  }),
                ],
              ),
            );
          })
        ],
      ),
    );
  }
}

// Add your existing imports here

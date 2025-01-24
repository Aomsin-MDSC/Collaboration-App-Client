import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:collaboration_app_client/controllers/in_project_controller.dart';
import 'package:collaboration_app_client/controllers/new_project_controller.dart';
import 'package:collaboration_app_client/controllers/project_controller.dart';
import 'package:collaboration_app_client/controllers/task_page_controller.dart';
import 'package:collaboration_app_client/utils/color.dart';
import 'package:collaboration_app_client/views/edit_task_view.dart';
import 'package:collaboration_app_client/views/widgets/comment_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/tag_controller.dart';
import '../../models/task_model.dart';

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
  /* final int tagId = Get.arguments['tagId'];
  final String tagColor = Get.arguments['tagColor'];
  final String tagName = Get.arguments['tagName']; */
  final String taskColor = Get.arguments['taskColor'];
  final int userId = Get.arguments['userId'];
  final bool canEdit = Get.arguments['canEdit'];

  @override
  Widget build(BuildContext context) {
    final TaskController taskController = Get.find<TaskController>();

    final controller = Get.put(TaskPageController());
    final taskDetails = Get.put(TaskController());
    final getuser = Get.put(NewProjectController());
    final project = Get.put(ProjectController());
    final tagController = Get.put(TagController());

    Get.find<ProjectController>();

    return Obx(() {
      final task = taskDetails.task.value.firstWhere(
        (value) => value.taskId == widget.taskId,
        orElse: () => Task(
          taskId: -1,
          taskName: 'Unknown Task',
          taskDetail: '',
          taskEnd: '',
          taskColor: '',
          taskStatus: false,
          userId: 0,
          tagId: -1,
          projectId: 0,
          ownerName: '',
          taskOwner: -1,
          tagName: 'No Tag',
          tagColor: '#808080',
          taskOrder: 0,
        ),
      );

      if (task.taskId == -1) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.back();
        });
        return const SizedBox.shrink();
      }

      final taskId = task.taskId;
      final taskName = task.taskName;
      final taskDetail = task.taskDetail;
      final tagId = task.tagId;
      final taskOwner = task.taskOwner;
      final tagColor = taskController.task
          .firstWhere(
            (value) => value.taskId == widget.taskId,
            orElse: () => task,
          )
          .tagColor;
      final taskOwnerName = task.ownerName == '' ? 'Missing' : task.ownerName;
      final taskEnd = taskController.task
          .firstWhere(
            (f) => f.taskId == widget.taskId,
            orElse: () => task,
          )
          .taskEnd;

      return Column(
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
                    canEdit
                        ? IconButton(
                            icon: const Icon(
                              Icons.edit,
                              size: 30,
                            ),
                            onPressed: () async {
                              await tagController.fetchTagMap(tagId);
                              print('Color is -------------');
                              print('Tag is -------------');
                              Get.to(
                                const EditTaskView(),
                                arguments: {
                                  'projectId': projectId,
                                  'taskId': taskId,
                                  'taskName': taskName,
                                  'taskDetail': taskDetail,
                                  'taskOwner': taskOwnerName,
                                  'tagId': tagId,
                                  'taskEnd': DateTime.parse(taskEnd),
                                  'taskColor': taskColor,
                                  'tagColor': tagColor,
                                  'userId': userId,
                                },
                              )?.then((result) {
                                if (result == true) {
                                  Future.delayed(Duration.zero, () async {
                                    await taskController.fetchTask(projectId);
                                    await getuser.fetchTags();
                                    print("Task Page Form :::: $result");
                                  });
                                  setState(() {});
                                }
                              });
                            },
                          )
                        : Container(), //empty box
                  ],
                ),
                const SizedBox(height: 20),
                // Details Section
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                    children: [
                      const TextSpan(
                        text: "Details: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: taskController.task
                            .firstWhere((f) => f.taskId == widget.taskId)
                            .taskDetail,
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
                        text: taskOwnerName, // value not change when fetch
                        style: const TextStyle(fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                    children: [
                      const TextSpan(
                        text: "Deadline: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: DateFormat('dd/MM/yyyy').format(
                          DateTime.parse(taskEnd),
                        ),
                        style: const TextStyle(fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: HexColor(tagColor), // api color
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          taskController.task
                              .firstWhere((f) => f.taskId == widget.taskId)
                              .tagName,
                          style: TextStyle(
                            color: HexColor(taskController.task
                                            .firstWhere((value) =>
                                                value.taskId == widget.taskId)
                                            .tagColor)
                                        .computeLuminance() >
                                    0.5
                                ? Colors.black
                                : Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ), // api tag
                      ),
                    ),
                    const Spacer(),
                    AnimatedToggleSwitch<bool>.dual(
                        active:
                            taskOwner == project.userId.toInt() ? true : false,
                        height: 40,
                        current: taskDetails.task.value
                            .firstWhere(
                                (value) => value.taskId == widget.taskId)
                            .taskStatus,
                        first: false,
                        second: true,
                        onChanged: (value) async {
                          // API Here
                          await TaskController.instance
                              .updateTaskStatus(taskId, value, taskName);
                          await taskController.fetchTask(projectId);
                          setState(() {
                            taskDetails.task.value
                                .firstWhere(
                                    (value) => value.taskId == widget.taskId)
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
      );
    });
  }
}

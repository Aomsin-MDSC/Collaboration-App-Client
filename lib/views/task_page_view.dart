import 'package:collaboration_app_client/controllers/task_page_controller.dart';
import 'package:collaboration_app_client/views/task_page_assets/task_page_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart';
import 'new_announce_assets/edit_announce_form.dart';

class TaskPageView extends StatefulWidget {
  final int taskId;
  const TaskPageView({super.key, required this.taskId});

  @override
  State<TaskPageView> createState() => _TaskPageViewState();
}

class _TaskPageViewState extends State<TaskPageView> {
  late int projectId;

  @override
  void initState() {
    super.initState();
    final Map<String, dynamic> arguments = Get.arguments;
    projectId = arguments['projectId'];
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TaskPageController());
    controller.fetchComment(widget.taskId);

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text(
            "TASK PAGE",
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TaskPageForm(
                  taskId: widget.taskId,
                  projectId: projectId,
                ),
                Padding(padding: EdgeInsets.only(bottom: 80))
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Expanded(
            child: TextField(
              controller: controller.commentText,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: "Add a comment...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
            ),
                ),
                const SizedBox(width: 8),
                InkWell(
            onTap: () async {
              if (controller.commentText.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Comment cannot be empty")));
              } else {
                await controller.CreateComment(widget.taskId);
                controller.commentText.clear();
                setState(() {});
                print('Task ID: ${widget.taskId}');
              }
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black, 
              ),
              child: const Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

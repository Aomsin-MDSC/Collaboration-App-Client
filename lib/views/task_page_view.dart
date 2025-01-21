import 'package:collaboration_app_client/controllers/in_project_controller.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Taskcontroller = Get.put(TaskController());
    final controller = Get.put(TaskPageController());

    controller.fetchComment(widget.taskId);

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text(
            "TASK PAGE",
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              await Taskcontroller.fetchTask(Taskcontroller.projectId);
              Get.back();
            },
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
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: FilledButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Colors.white),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
              ),
            ),
          ),
          onPressed: () {
            setState(() {
              controller.commentText.text != controller.commentText.text;
            });
            Get.bottomSheet(
              Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Expanded(
            child: TextField(
              autofocus: true,
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
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Comment cannot be empty")),
                );
              } else {
                Get.back();
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
            ).whenComplete(() {
              setState(() 
              {             
            controller.commentText.text != controller.commentText.text;      
              }
            );
            }
          );
          },
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.only(bottom: 20, top: 20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(20),
                 color: Colors.black12,
              ),
              
              padding: const EdgeInsets.all(10.0),
              child: Text(
                controller.commentText.text.isEmpty
              ? 'Add a comment...'
              : controller.commentText.text,
                style: TextStyle(
            color: controller.commentText.text.isEmpty
                ? Colors.grey
                : Colors.black,
            fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () async {
              if (controller.commentText.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Comment cannot be empty")),
                );
              } else {
                await controller.CreateComment(widget.taskId);
                controller.commentText.clear();
                setState(() {});
                print('Task ID: ${widget.taskId}');
              }
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
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
        )
      ),
    );
  }
}

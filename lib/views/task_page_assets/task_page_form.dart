import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:collaboration_app_client/controllers/task_page_controller.dart';
import 'package:collaboration_app_client/utils/color.dart';
import 'package:collaboration_app_client/views/edit_project_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/edit_announce_controller.dart';

class TaskPageForm extends StatefulWidget {
  const TaskPageForm({super.key});

  @override
  State<TaskPageForm> createState() => _TaskPageFormState();
}

class _TaskPageFormState extends State<TaskPageForm> {
  final controller = Get.put(TaskPageController());

  @override
  Widget build(BuildContext context) {
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
                    const Expanded(
                      child: Center(
                        child: Text(
                          "Home Page",
                          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings, size: 30,),
                      onPressed: () {
                        // api
                        Get.to(EditProjectView());
                      },
                    )
                  ],
                ),
                const SizedBox(height: 20),
                // Details Section
                RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    children: [
                      TextSpan(
                        text: "Details : ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: "This page must show all Task of project. Please finish this page within today. If you can't finish, I will finish you.",
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    children: [
                      TextSpan(
                        text: "Assigned to : ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: "You",
                        style: TextStyle(fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    children: [
                      TextSpan(
                        text: "Deadline : ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: "26/12/2024",
                        style: TextStyle(fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.cyanAccent, // api color
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text("Tag1"), // api tag
                    ),
                    const Spacer(),
                    AnimatedToggleSwitch<bool>.dual(
                      height: 40, // Fixed height for toggle
                      current: controller.taskstatus,
                      first: false,
                      second: true,
                      onChanged: (value) {
                        setState(() {
                          controller.taskstatus = value;
                        });
                      },
                      textBuilder: (value) => value
                          ? const Center(
                        child: Text(
                          'Pending',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                          : const Center(
                        child: Text(
                          'Done',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      styleBuilder: (value) => value
                          ? ToggleStyle(
                          backgroundColor: Colors.redAccent,
                          indicatorColor: Colors.white,
                          indicatorBorder: Border.all(
                            color: Colors.redAccent,
                            width: 3,
                          ))
                          : ToggleStyle(
                          backgroundColor: Colors.green,
                          indicatorColor: Colors.white,
                          indicatorBorder: Border.all(
                            color: Colors.green,
                            width: 3,
                          )
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20,),
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
                const Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Comment",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(
                  color: Colors.grey,
                  thickness: 2,
                  // indent: 20,
                  // endIndent: 20,
                ),
                const SizedBox(height: 10),
                Text("@User",style: TextStyle(fontSize: 18),),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 16, color: Colors.black),
                    children: [
                      TextSpan(
                        text: " : ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: " Hurry Up!!! ",
                      ),
                    ],
                  ),
                ),
                Text("24/12/2024 11:00",style: TextStyle(fontSize: 14,color: Colors.grey),),
              ],
            ),
          )
        ],
      ),
    );
  }
}

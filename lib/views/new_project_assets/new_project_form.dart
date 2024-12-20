import 'package:collaboration_app_client/controllers/new_project_controller.dart';
import 'package:collaboration_app_client/controllers/new_tag_controller.dart';
import 'package:collaboration_app_client/views/Login_View.dart';
import 'package:collaboration_app_client/views/home_view.dart';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../new_tag_view.dart';
import '../new_task_view.dart';

class NewProjectForm extends StatefulWidget {
  const NewProjectForm({super.key});

  @override
  State<NewProjectForm> createState() => _NewProjectFormState();
}

class _NewProjectFormState extends State<NewProjectForm> {
  @override
  Widget build(BuildContext context) {
    final List<String> task = [
      "1",
      "2",
      "3",
      "4",
      "5",
      "6",
      "7",
      "8",
      "9",
      "10",
    ];
    final controller = Get.put(NewProjectController());

    return Form(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Project Header
            const SizedBox(height: 30),
            Text(
              "NEW PROJECT".toUpperCase(),
              style: TextStyle(fontSize: 50),
            ),
            const SizedBox(height: 20),
            Text("Project Name", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            TextField(
              controller: controller.projectname,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
            ),

            // Member Dropdown
            const SizedBox(height: 20),
            Text("Member", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Obx(() {
              return DropdownSearch<String>.multiSelection(
                items: controller.memberlist.toList(),
                selectedItems: controller.selectedmember.toList(),
                dropdownDecoratorProps: const DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                )),
                onChanged: (newValue) {
                  controller.selectedmember.clear();
                  controller.selectedmember.addAll(newValue);
                },
              );
            }),

            // Tag Dropdown
            const SizedBox(height: 20),
            Text("Tag", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Obx(() {
              return DropdownSearch<String>(
                  popupProps: PopupProps.menu(
                      title: ElevatedButton(
                          onPressed: () {
                            controller.selectedtag.clear();
                            Get.to(const NewTagView());
                          },
                          child: const Text("Add Tag"))),
                  items: controller.taglist.toList(),
                  dropdownDecoratorProps: const DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                      )),
                  onChanged: (value) {
                    controller.selectedtag.clear();
                    if (value != null) {
                      controller.selectedtag.add(value);
                    }
                    if (value == "Add Tag") {
                      Get.to(NewTagView());
                    }
                  }
              );
            }),

            // Task List
            const SizedBox(height: 20),
            Text("Task", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Column(
              children: [
                Container(
                  height: task.length < 4 ? null : 300,
                  color: Colors.black38,
                  padding: EdgeInsets.all(13),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: task.length,
                    itemBuilder: (context, index) {
                      return TextButton(
                        style: ButtonStyle(
                            padding: WidgetStateProperty.all<EdgeInsets>(
                              EdgeInsets.zero,
                            ),
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                            )
                            // Set padding to zero
                            ),
                        onPressed: () {
                          Get.snackbar('Index', '${task[index]}',
                              duration: Duration(seconds: 1),
                              colorText: Colors.white,
                              backgroundColor: Colors.black54);
                        },
                        child: Card(
                          child: ListTile(
                            title: Text(
                              task[index],
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          Get.to(NewTaskView(),);

                        },
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                        )))
              ],
            ),

            // Save Button
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  controller.createProject();
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  "Save",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
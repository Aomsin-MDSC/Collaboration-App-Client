import 'package:collaboration_app_client/controllers/new_project_controller.dart';
import 'package:collaboration_app_client/models/tag_model.dart';
import 'package:collaboration_app_client/utils/color.dart';
import 'package:collaboration_app_client/views/Login_View.dart';
import 'package:collaboration_app_client/views/home_view.dart';
import 'package:collaboration_app_client/views/project_view.dart';
import 'package:collaboration_app_client/views/widgets/dropdown_tag_widget.dart';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../edit_tag_view.dart';
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
    // final List<String> task = [
    //   "1",
    //   "2",
    //   "3",
    //   "4",
    //   "5",
    //   "6",
    //   "7",
    //   "8",
    //   "9",
    //   "10",
    // ];
    final controller = Get.put(NewProjectController());

    return Form(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Project Header
            // const SizedBox(height: 60),
            const Text("Project Name", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            TextFormField(
              controller: controller.projectname,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    controller.projectname.clear();
                  },
                ),
              ),
              maxLength: 50,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field is required';
                } else if (value.length > 50) {
                  return 'Cannot exceed 50 characters';
                }
                return null;
              },
            ),

            // Member Dropdown
            const SizedBox(height: 50),
            const Text("Member", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
Obx(() {
  return Column(
    children: [
      // Project Managers Dropdown
      DropdownSearch<String>.multiSelection(
        items: controller.memberlist
            .where((member) => !controller.selectedMembers.contains(member)) // Exclude selected members
            .toList(), 
        selectedItems: controller.selectedManagers.toList(), // Selected managers
        dropdownDecoratorProps: const DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(),
            labelText: "Select Project Managers",
          ),
        ),
        popupProps: const PopupPropsMultiSelection.dialog(
          searchDelay: Duration(milliseconds: 200),
          showSearchBox: true
        ),
        onChanged: (newValue) {
          controller.selectedManagers.clear();
          controller.selectedManagers.addAll(newValue);
          controller.selectedMembers.removeWhere((member) => newValue.contains(member)); // Remove duplicates
        },
      ),

      const SizedBox(height: 20),

      // Members Dropdown
      DropdownSearch<String>.multiSelection(
        items: controller.memberlist
            .where((member) => !controller.selectedManagers.contains(member)) // Exclude selected managers
            .toList(), 
        selectedItems: controller.selectedMembers.toList(), // Selected members
        dropdownDecoratorProps: const DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(),
            labelText: "Select Members",
          ),
        ),
        popupProps: const PopupPropsMultiSelection.dialog(
          searchDelay: Duration(milliseconds: 200),
          showSearchBox: true
        ),
        onChanged: (newValue) {
          controller.selectedMembers.clear();
          controller.selectedMembers.addAll(newValue);
          controller.selectedManagers.removeWhere((manager) => newValue.contains(manager)); // Remove duplicates
        },
      ),
    ],
  );
}),

            // Tag Dropdown
            const SizedBox(height: 60),
            const Text("Tag", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Obx(() {
              return DropdownButtonFormField<TagModel>(
                menuMaxHeight: 300,
                iconSize: 35,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      controller.selectedTag = null;
                      setState(() {
                      });
                    },
                  ),
                ),
                icon: Icon(Icons.arrow_drop_down, color: Colors.black54),
                value: controller.selectedTag,
                hint: Text(
                  "Select Tag",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
                isExpanded: true,
                items: [
                  DropdownMenuItem<TagModel>(
                    value: TagModel(tagId: -1, tagName: "null", tagColor: ""),
                    child: Container(
                      color: Colors.amberAccent,
                      child: Center(
                        child: SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero),
                              ),
                            ),
                            onPressed: () {
                              Get.to(NewTagView());
                            },
                            child: Text(
                              "Add Tag",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  ...controller.tags.map((tag) {
                    return DropdownMenuItem<TagModel>(
                      value: tag,
                      child: DropdownTagWidget(tag: tag),
                    );
                  }).toList(),
                ],
                onChanged: (value) {
                  setState(() {
                    if (value != "Add Tag") {
                      if (value != null) {
                        controller.selectedTag = value;
                      }
                    }
                  });
                },
              );
            }),

            // // Task List
            // const SizedBox(height: 20),
            // const Text("Task", style: TextStyle(fontSize: 18)),
            // const SizedBox(height: 10),
            // Column(
            //   children: [
            //     Container(
            //       height: task.length < 4 ? null : 300,
            //       color: Colors.black38,
            //       padding: const EdgeInsets.all(13),
            //       child: ListView.builder(
            //         shrinkWrap: true,
            //         itemCount: task.length,
            //         itemBuilder: (context, index) {
            //           return TextButton(
            //             style: ButtonStyle(
            //                 padding: WidgetStateProperty.all<EdgeInsets>(
            //                   EdgeInsets.zero,
            //                 ),
            //                 shape:
            //                     WidgetStateProperty.all<RoundedRectangleBorder>(
            //                   RoundedRectangleBorder(
            //                     borderRadius: BorderRadius.circular(18.0),
            //                   ),
            //                 )
            //                 // Set padding to zero
            //                 ),
            //             onPressed: () {
            //               Get.snackbar('Index', '${task[index]}',
            //                   duration: const Duration(seconds: 1),
            //                   colorText: Colors.white,
            //                   backgroundColor: Colors.black54);
            //             },
            //             child: Card(
            //               child: ListTile(
            //                 title: Text(
            //                   task[index],
            //                   textAlign: TextAlign.center,
            //                 ),
            //               ),
            //             ),
            //           );
            //         },
            //       ),
            //     ),
            //     SizedBox(
            //         width: double.infinity,
            //         child: ElevatedButton(
            //             style: ElevatedButton.styleFrom(
            //               shape: RoundedRectangleBorder(
            //                 borderRadius: BorderRadius.circular(16),
            //               ),
            //               backgroundColor: Colors.black,
            //               foregroundColor: Colors.white,
            //             ),
            //             onPressed: () {
            //               Get.to(
            //                 //Api Here
            //                 const NewTaskView(),
            //               );
            //             },
            //             child: const Icon(
            //               Icons.add,
            //               color: Colors.white,
            //             )))
            //   ],
            // ),

            // Save Button
            const SizedBox(height: 150),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () async {
                  if (controller.projectname.text.isNotEmpty) {
                    await controller.createProject();
                    Get.back();
                  } else {
                    ScaffoldMessenger.of(Get.context!).showSnackBar(
                      SnackBar(
                        content: const Row(
                          children: [
                            Icon(Icons.cancel, color: Colors.white),
                            SizedBox(width: 8),
                            Text('Create Project Failed.'),
                          ],
                        ),
                        // behavior: SnackBarBehavior.floating,
                        // margin: EdgeInsets.only(bottom: MediaQuery.of(Get.context!).size.height - 180, left: 15, right: 15),
                        action: SnackBarAction(label: "OK", onPressed: () {}), //action
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                  /* // Api Here
                  await controller.createProject();
                  // Get.offAll(()=> HomeView(),arguments: {'refresh':true});
                  // Get.back(result: {'refresh': true});
                  Get.back(); */
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: btcolor,
                ),
                child: const Text(
                  "Create Project",
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

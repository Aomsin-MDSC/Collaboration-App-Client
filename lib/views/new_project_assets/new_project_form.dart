import 'package:collaboration_app_client/controllers/new_project_controller.dart';
import 'package:collaboration_app_client/models/tag_model.dart';
import 'package:collaboration_app_client/utils/color.dart';
import 'package:collaboration_app_client/views/Login_View.dart';
import 'package:collaboration_app_client/views/home_view.dart';
import 'package:collaboration_app_client/views/project_view.dart';

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
            TextField(
              controller: controller.projectname,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
            ),

            // Member Dropdown
            const SizedBox(height: 60),
            const Text("Member", style: const TextStyle(fontSize: 18)),
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
                              // ฟังก์ชันเมื่อกดปุ่ม "Add Tag"
                              Get.off(NewTagView());
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //   SnackBar(content: Text("Add new tag action")
                              //   ),
                              // );
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Chip(
                              label: Text(
                                tag.tagName,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis, // ตัดข้อความด้วย "..."
                              ),
                              backgroundColor: HexColor.fromHex(tag.tagColor),
                              labelStyle: const TextStyle(color: Colors.white),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.black54),
                            onPressed: () {
                              // ฟังก์ชันเมื่อกดปุ่ม "Edit"
                              Get.to(EditTagView(),
                                  arguments: {'tagId': tag.tagId});
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Edit ${tag.tagId} action")),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
                onChanged: (value) {
                  setState(() {
                    if (value != "Add Tag") {
                      // อัปเดตค่า selectedtag
                      if (value != null) {
                        controller.selectedTag = value;
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                "Selected: ${controller.selectedTag!.tagName}")),
                      );
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
                onPressed: () {
                  // Api Here
                  controller.createProject();
                  Get.offAll(HomeView());
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: btcolor,
                ),
                child: const Text(
                  "Save",
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

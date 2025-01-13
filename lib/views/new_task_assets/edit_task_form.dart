import 'package:collaboration_app_client/controllers/edit_task_controller.dart';
import 'package:collaboration_app_client/views/edit_tag_view.dart';
import 'package:collaboration_app_client/views/home_view.dart';
import 'package:collaboration_app_client/views/project_view.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';

import '../../utils/color.dart';
import '../new_tag_view.dart';
import '../task_page_view.dart';

class EditTaskForm extends StatefulWidget {
  const EditTaskForm ({super.key});

  @override
  State<EditTaskForm> createState() => _EditTaskFormState();
}

class _EditTaskFormState extends State<EditTaskForm> {
  final controller = Get.put(EditTaskController());
  final int projectId = Get.arguments['projectId'];
  final int taskId = Get.arguments['taskId'];
  final int tagId = Get.arguments['tagId'];

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // taskname ---------------
            Text("Task Name", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            TextField(
                controller: controller.edittaskname,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  // prefixIcon: Icon(Icons.add),
                  border: OutlineInputBorder(),
                )),

            // detail ---------------
            SizedBox(height: 60,),
            Text("Details", style: TextStyle(fontSize: 18),),
            SizedBox(height: 10,),
            TextField(
              controller: controller.edittaskdetails,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                // prefixIcon: Icon(Icons.abc),
                border: OutlineInputBorder(),
              ),
            ),

            // member ---------------
            SizedBox(height: 60),
            Text("Member", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Obx(() {
              return DropdownSearch<String>(
                items: controller.editmemberlist.toList(),
                onChanged: (newValue) {
                  controller.editselectedmember.clear();
                  controller.editselectedmember.add(newValue!);
                },
                dropdownDecoratorProps: const DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                    )),
              );
            }),

            // Add Tag
            SizedBox(height: 60),
            Text("Tag", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Obx(() {
              return DropdownSearch<String>(
                popupProps: PopupProps.menu(
                    title: ElevatedButton(
                        onPressed: () {
                          controller.editselectedtag.clear();
                          Get.to(const NewTagView());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: btcolor,
                          shape: const RoundedRectangleBorder(
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                        ),
                        child: const Text("Add Tag"))),
                items: controller.edittaglist.toList(),
                dropdownDecoratorProps: const DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                    )),
              );
            }),

            // Text, Icon [Dead line, Color, Add tag]
            SizedBox(height: 60,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text("Dead Line".toUpperCase(), style: TextStyle(fontSize: 18),),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () async {
                        DateTime? selected = await showDatePicker(
                          context: context,
                          initialDate: controller.editselectedDate ?? DateTime.now(), // used selected day
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (selected != null && selected != controller.editselectedDate) {
                          setState(() {
                            controller.editselectedDate = selected; // save day [new selected]
                          });
                        }
                      },
                      child: Tooltip(
                        message: controller.editselectedDate != null
                            ? 'Selected Date: ${controller.editselectedDate!.toLocal()}'
                            : 'No date selected',
                        child: Icon(
                          Icons.date_range,
                          color: controller.editselectedDate != null
                              ? Colors.red
                              : Colors.black,
                          size: 70,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text("Color".toUpperCase(), style: TextStyle(fontSize: 18),),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Pick a Color'),
                              content: SingleChildScrollView(
                                child: ColorPicker( // spectrum color
                                  pickerColor: controller.taskcurrenttagColor,
                                  onColorChanged: (Color color) {
                                    setState(() {
                                      controller.edittaskchangeColor(color);
                                    });
                                  },
                                  showLabel: true,
                                  pickerAreaHeightPercent: 0.8,
                                ),
                                // child: BlockPicker(
                                //   pickerColor: controller.taskcurrenttagColor,
                                //   onColorChanged: (Color color) {
                                //     setState(() {
                                //       controller.taskchangeColor(color);
                                //     });
                                //   },
                                // ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Select'),
                                  onPressed: () {
                                    Get.back();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: CircleAvatar(
                        backgroundColor: controller.taskcurrenttagColor,
                        radius: 35,
                        child: Icon(
                          Icons.color_lens_rounded,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),

            // Save Button
            SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                    SizedBox(
                      width: 150,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          controller.updateTask(projectId, taskId,tagId);
                          Get.to(ProjectView(),arguments: {
                            'projectId': projectId,
                            'tagId': tagId,
                            'refresh': true,
                          }); // action
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          backgroundColor: btcolor,
                        ),
                        child: Text(
                          "SAVE",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 150,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          print("deldeldel"); // action
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          backgroundColor: btcolordelete,
                        ),
                        child: Text(
                          "DELETE",
                          style: TextStyle(fontSize: 18,color: Colors.white),
                        ),
                      ),
                    ),
              ],
            )

            // icon delete task
            // const SizedBox(height: 30,),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     Column(
            //       children: [
            //         Text("Delete Task".toUpperCase(), style: TextStyle(fontSize: 20),),
            //         const SizedBox(height: 10,),
            //         GestureDetector(
            //           onTap: () async {
            //             print("Deletedelete");
            //           },
            //           child: Icon(
            //             Icons.delete,
            //             color: Colors.green,
            //             size: 70,
            //
            //           )
            //         ),
            //       ],
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
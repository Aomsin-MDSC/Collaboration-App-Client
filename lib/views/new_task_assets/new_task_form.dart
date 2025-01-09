import 'package:collaboration_app_client/controllers/new_task_controller.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';

import '../../utils/color.dart';
import '../new_tag_view.dart';
import '../project_view.dart';

class NewTaskForm extends StatefulWidget {
  const NewTaskForm({super.key});

  @override
  State<NewTaskForm> createState() => _NewTaskFormState();
}

class _NewTaskFormState extends State<NewTaskForm> {
  final controller = Get.put(NewTaskController());
  final int projectId = Get.arguments['projectId'];
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
                controller: controller.taskName,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  // prefixIcon: Icon(Icons.add),
                  border: OutlineInputBorder(),
                )),

            // detail ---------------
            SizedBox(
              height: 60,
            ),
            Text(
              "Details",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: controller.taskdetails,
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
                items: controller.memberlist.toList(),
                onChanged: (newValue) {
                  controller.selectedmember.clear();
                  controller.selectedmember.add(newValue!);
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
                          controller.selectedtag.clear();
                          Get.to(const NewTagView());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: btcolor,
                          shape: const RoundedRectangleBorder(),
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 20),
                        ),
                        child: const Text("Add Tag"))),
                items: controller.taglist.toList(),
                onChanged: (newValue) {
                  controller.selectedtag.clear();
                  controller.selectedtag.add(newValue!);
                },
                dropdownDecoratorProps: const DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                )),
              );
            }),

            // Text, Icon [Dead line, Color, Add tag]
            SizedBox(
              height: 60,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      "Dead Line".toUpperCase(),
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () async {
                        DateTime? selected = await showDatePicker(
                          context: context,
                          initialDate: controller.selectedDate ??
                              DateTime.now(), // used selected day
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (selected != null &&
                            selected != controller.selectedDate) {
                          setState(() {
                            controller.selectedDate =
                                selected; // save day [new selected]
                          });
                        }
                      },
                      child: Tooltip(
                        message: controller.selectedDate != null
                            ? 'Selected Date: ${controller.selectedDate!.toLocal()}'
                            : 'No date selected',
                        child: Icon(
                          Icons.date_range,
                          color: controller.selectedDate != null
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
                    Text(
                      "Color".toUpperCase(),
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Pick a Color'),
                              content: SingleChildScrollView(
                                child: ColorPicker(
                                  // spectrum color
                                  pickerColor: controller.taskcurrenttagColor,
                                  onColorChanged: (Color color) {
                                    setState(() {
                                      controller.taskchangeColor(color);
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
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  controller.createTask(projectId);
                  Get.off(ProjectView(), arguments: {
                    'projectId': projectId,
                    'tagId': tagId
                  }); // action
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: btcolor,
                ),
                child: Text(
                  "Make a Task",
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

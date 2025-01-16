import 'package:collaboration_app_client/controllers/new_task_controller.dart';
import 'package:collaboration_app_client/models/tag_model.dart';
import 'package:collaboration_app_client/views/widgets/dropdown_tag_widget.dart';
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
  final int userId = Get.arguments['userId'];

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // taskname ---------------
            const Text("Task Name", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            TextFormField(
              controller: controller.taskName,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                // prefixIcon: Icon(Icons.add),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    controller.taskName.clear();
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

            // detail ---------------
            const SizedBox(
              height: 60,
            ),
            const Text(
              "Details",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: controller.taskdetails,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                // prefixIcon: Icon(Icons.abc),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    controller.taskdetails.clear();
                  },
                ),
              ),
              maxLength: 200,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field is required';
                } else if (value.length > 200) {
                  return 'Cannot exceed 200 characters';
                }
                return null;
              },
            ),

            // member ---------------
            const SizedBox(height: 60),
            const Text("Member", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
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

            // Dropdown Tag
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
                icon: const Icon(Icons.arrow_drop_down, color: Colors.black54),
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
                                const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero),
                              ),
                            ),
                            onPressed: () {
                              // ฟังก์ชันเมื่อกดปุ่ม "Add Tag"
                              Get.to(const NewTagView());
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //   SnackBar(content: Text("Add new tag action")
                              //   ),
                              // );
                            },
                            child: const Text(
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

            // Text, Icon [Dead line, Color, Add tag]
            const SizedBox(
              height: 60,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      "Dead Line".toUpperCase(),
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 10),
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
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Pick a Color'),
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
                        child: const Icon(
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
            const SizedBox(height: 60),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  if (controller.selectedDate != null &&
                      controller.taskName.text.isNotEmpty &&
                      controller.taskdetails.text.isNotEmpty &&
                      controller.selectedmember.isNotEmpty &&
                      controller.selectedTag != null) {
                    controller.createTask(projectId);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Task created successfully!',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                    Get.back();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Please fill all the fields and set datetime!',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  }
                  //controller.createTask(projectId);
                  //Get.back(); // action
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: btcolor,
                ),
                child: const Text(
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

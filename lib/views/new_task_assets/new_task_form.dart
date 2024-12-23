import 'package:collaboration_app_client/controllers/new_task_controller.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';

import '../new_tag_view.dart';

class NewTaskForm extends StatefulWidget {
  const NewTaskForm ({super.key});

  @override
  State<NewTaskForm> createState() => _NewTaskFormState();
}

class _NewTaskFormState extends State<NewTaskForm> {
  final controller = Get.put(NewTaskController());

  @override
  Widget build(BuildContext context) {
    final screenres = MediaQuery.of(context).size.width; // responsive
    return Form(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: screenres * 0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // taskname ---------------
            Text("Task Name", style: TextStyle(fontSize: screenres * 0.05)),
            SizedBox(height: screenres * 0.05),
            TextField(
                controller: controller.taskName,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  // prefixIcon: Icon(Icons.add),
                  border: OutlineInputBorder(),
                )),

            // detail ---------------
            SizedBox(height: screenres * 0.05,),
            Text("Details", style: TextStyle(fontSize: screenres * 0.05),),
            SizedBox(height: screenres * 0.05,),
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
            SizedBox(height: screenres * 0.05),
            Text("Member", style: TextStyle(fontSize: screenres * 0.05)),
            SizedBox(height: screenres * 0.05),
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
              );
            }),

            // Add Tag
            SizedBox(height: screenres * 0.05),
            Text("Tag", style: TextStyle(fontSize: screenres * 0.05)),
            SizedBox(height: screenres * 0.05),
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
                  if (value == "Add Tag") {
                    Get.to(NewTagView());
                  }
                },
              );
            }),

            // Text, Icon [Dead line, Color, Add tag]
            SizedBox(height: screenres * 0.05,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text("Dead Line".toUpperCase(), style: TextStyle(fontSize: screenres * 0.04),),
                    SizedBox(height: screenres * 0.05,),
                    GestureDetector(
                      onTap: () async {
                        DateTime? selected = await showDatePicker(
                          context: context,
                          initialDate: controller.selectedDate ?? DateTime.now(), // used selected day
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (selected != null && selected != controller.selectedDate) {
                          setState(() {
                            controller.selectedDate = selected; // save day [new selected]
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
                          size: screenres * 0.19,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text("Color".toUpperCase(), style: TextStyle(fontSize: screenres * 0.04),),
                    SizedBox(height: screenres * 0.05,),
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
                                      controller.taskchangeColor(color);
                                    });
                                  },
                                  showLabel: true,
                                  pickerAreaHeightPercent: screenres * 0.002,
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
                                  child: Text('Select'),
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
                        radius: screenres * 0.095,
                        child: Icon(
                          Icons.color_lens_rounded,
                          color: Colors.white,
                          size: screenres * 0.15,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),

            // Save Button
            SizedBox(height: screenres * 0.05),
            SizedBox(
              width: double.infinity,
              height: screenres * 0.15,
              child: ElevatedButton(
                onPressed: () {
                  // controller.createTask(); // action
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(screenres * 0.03),
                  ),
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  "Make a Task",
                  style: TextStyle(fontSize: screenres * 0.05),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
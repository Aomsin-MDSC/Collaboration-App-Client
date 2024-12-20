import 'package:collaboration_app_client/controllers/edit_task_controller.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';

import '../new_tag_view.dart';

class EditTaskForm extends StatefulWidget {
  const EditTaskForm ({super.key});

  @override
  State<EditTaskForm> createState() => _EditTaskFormState();
}

class _EditTaskFormState extends State<EditTaskForm> {
  final controller = Get.put(EditTaskController());
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // taskname ---------------
            const SizedBox(height: 30,),
            Text("EDIT TASK".toUpperCase(), style: TextStyle(fontSize: 50), ),
            const SizedBox(height: 20),
            Text("Task Name", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            TextField(
                controller: controller.edittaskname,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  // prefixIcon: Icon(Icons.add),
                  border: OutlineInputBorder(),
                )
            ),

            // detail ---------------
            const SizedBox(height: 20,),
            Text("Details", style: TextStyle(fontSize: 18),),
            const SizedBox(height: 10,),
            TextField(
              controller: controller.edittaskdetails,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                // prefixIcon: Icon(Icons.abc),
                border: OutlineInputBorder(),
              ),
              maxLines: null,
            ),

            // member ---------------
            const SizedBox(height: 20),
            Text("Member", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Obx(() {
              return DropdownSearch<String>.multiSelection(
                items: controller.editmemberlist.toList(),
                selectedItems: controller.editselectedmember.toList(),
                dropdownDecoratorProps: const DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                    )),
              );
            }),

            // Add Tag
            const SizedBox(height: 20),
            Text("Tag", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Obx(() {
              return DropdownSearch<String>(
                items: controller.edittaglist.toList(),
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
            const SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text("Dead Line".toUpperCase(), style: TextStyle(fontSize: 20),),
                    const SizedBox(height: 10,),
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
                          color: controller.editselectedDate != null ? Colors.red : Colors.black,
                          size: 70,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text("Color".toUpperCase(), style: TextStyle(fontSize: 20),),
                    const SizedBox(height: 10,),
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
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                    SizedBox(
                      width: 150,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          print("makemakemake"); // action
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                        ),
                        child: Text(
                          "SAVE",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 157,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          print("deldeldel"); // action
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                        ),
                        child: Text(
                          "DELETE",
                          style: TextStyle(fontSize: 18),
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
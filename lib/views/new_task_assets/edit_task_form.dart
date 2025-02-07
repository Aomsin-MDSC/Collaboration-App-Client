import 'package:collaboration_app_client/controllers/edit_task_controller.dart';
import 'package:collaboration_app_client/controllers/tag_controller.dart';
import 'package:collaboration_app_client/models/tag_model.dart';
import 'package:collaboration_app_client/views/widgets/dropdown_tag_widget.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import '../../utils/color.dart';
import '../new_tag_view.dart';

class EditTaskForm extends StatefulWidget {
  const EditTaskForm({super.key});

  @override
  State<EditTaskForm> createState() => _EditTaskFormState();
}

class _EditTaskFormState extends State<EditTaskForm> {
  final tagController = Get.put(TagController());
  final controller = Get.put(EditTaskController());
  final int projectId = Get.arguments['projectId'];
  final int taskId = Get.arguments['taskId'];
  final String taskName = Get.arguments['taskName'];
  final String taskDetail = Get.arguments['taskDetail'];
  final String taskOwner = Get.arguments['taskOwner'];
  final int tagId = Get.arguments['tagId'];
  final int userId = Get.arguments['userId'];
  final DateTime taskEnd = Get.arguments['taskEnd'];
  final String taskColor = Get.arguments['taskColor'];
  final String tagcolor = Get.arguments['tagColor'];

  bool _emptytaskname = false;
  bool _emptytaskdetail = false;
  bool _emptytaskmember = false;
  bool _emptydetatime = false;

  @override
  void initState() {
    super.initState();
    controller.edittaskname.text = taskName;
    controller.edittaskdetails.text = taskDetail;
    controller.editselectedDate = taskEnd;
    controller.edittaskcolor = taskColor;
    tagController.selectedTag =
        tagController.tags.firstWhereOrNull((tag) => tag.tagId == tagId);
  }

  @override
  Widget build(BuildContext context) {
    print("Selected Tag: ${controller.selectedTag?.tagName}");

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
              controller: controller.edittaskname,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                // prefixIcon: Icon(Icons.add),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    controller.edittaskname.clear();
                    setState(() {
                      _emptytaskname = true;
                    });
                  },
                ),
              ),
              maxLength: 50,
              onChanged: (value) {
                setState(() {
                  _emptytaskname = value.isEmpty;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field is required';
                } else if (value.length > 50) {
                  return 'Cannot exceed 50 characters';
                }
                return null;
              },
            ),
            if (_emptytaskname)
              const Text(
                'Please enter taskname',
                style: TextStyle(color: Colors.red, fontSize: 14),
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
              controller: controller.edittaskdetails,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                // prefixIcon: Icon(Icons.abc),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    controller.edittaskdetails.clear();
                    setState(() {
                      _emptytaskdetail = true;
                    });
                  },
                ),
              ),
              maxLines: null,
              maxLength: 200,
              onChanged: (value) {
                setState(() {
                  _emptytaskdetail = value.isEmpty;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field is required';
                } else if (value.length > 200) {
                  return 'Cannot exceed 200 characters';
                }
                return null;
              },
            ),
            if (_emptytaskdetail)
              const Text(
                'Please enter details',
                style: TextStyle(color: Colors.red, fontSize: 14),
              ),

            // member ---------------
            const SizedBox(height: 60),
            const Text("Member", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Obx(() {
              return DropdownSearch<String>(
                items: controller.edit_selected_members_map.toList(),
                selectedItem: taskOwner,
                onChanged: (newValue) {
                  controller.editselectedmember.clear();
                  controller.editselectedmember.add(newValue!);
                  _emptytaskmember = newValue.isEmpty;
                },
                dropdownDecoratorProps: const DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                )),
                popupProps: PopupProps.menu(
                  constraints: BoxConstraints(
                    maxHeight: controller.edit_selected_members_map.length *
                                100.0 >
                            200
                        ? 200
                        : controller.edit_selected_members_map.length * 100.0,
                  ),
                ),
              );
            }),
            if (_emptytaskmember)
              const Text(
                'Please assign member',
                style: TextStyle(color: Colors.red, fontSize: 14),
              ),

            // Add Tag
            const SizedBox(height: 60),
            const Text("Tag", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Obx(() {
              if (tagController.selectedTag != null &&
                  !tagController.tags.any(
                      (tag) => tag.tagId == tagController.selectedTag!.tagId)) {
                tagController.selectedTag = null;
              }
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
                      tagController.selectedTag = null;
                      setState(() {});
                    },
                  ),
                ),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.black54),
                value: tagController.selectedTag?.tagId == -1
                    ? null
                    : tagController.selectedTag,
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
                              shape: WidgetStateProperty.all(
                                const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero),
                              ),
                            ),
                            onPressed: () {
                              Get.to(const NewTagView());
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
                  ...tagController.tags.map((tag) {
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
                        tagController.selectedTag = value;
                      }
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
                          initialDate: controller.editselectedDate ??
                              DateTime.now(), // used selected day
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (selected != null &&
                            selected != controller.editselectedDate) {
                          setState(() {
                            _emptydetatime = false;
                            controller.editselectedDate =
                                selected; // save day [new selected]
                          });
                        } else if (selected == null) {
                          setState(() {
                            _emptydetatime = true;
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
                              ? Colors.green
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
                                  pickerColor: Color(int.parse(controller
                                      .edittaskcolor
                                      .replaceFirst('#', '0xff'))),
                                  onColorChanged: (Color color) {
                                    setState(() {
                                      controller.edittaskchangeColor(color);
                                    });
                                  },
                                  showLabel: true,
                                  pickerAreaHeightPercent: 0.8,
                                ),
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
            SizedBox(height: 10,),
            if (_emptydetatime)
              const Text(
                'Please select datetime.',
                style: TextStyle(color: Colors.red, fontSize: 14),
              ),

            // Save Button
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 150,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (controller.edittaskname.text.isNotEmpty &&
                          controller.edittaskdetails.text.isNotEmpty) {
                        print("Edit task page : taskOwner = $taskOwner");
                        await controller.updateTask(
                            projectId, taskId, tagId, taskOwner);
                        Get.back();
                      } else {
                        ScaffoldMessenger.of(Get.context!).showSnackBar(
                          SnackBar(
                            content: const Row(
                              children: [
                                Icon(Icons.cancel, color: Colors.white),
                                SizedBox(width: 8),
                                Text('Edit Task Failed.'),
                              ],
                            ),
                            // behavior: SnackBarBehavior.floating,
                            // margin: EdgeInsets.only(bottom: MediaQuery.of(Get.context!).size.height - 260, left: 15, right: 15),
                            action: SnackBarAction(
                                label: "OK", onPressed: () {}), //action
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            duration: const Duration(seconds: 3),
                          ),
                        );
                      }
                      // Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      backgroundColor: btcolor,
                    ),
                    child: const Text(
                      "SAVE",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                SizedBox(
                  width: 150,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        await controller.deleteTask(taskId, projectId);
                        Get.back();
                      } catch (e) {
                        if (e.toString().contains("Bad state: No element")) {
                          Get.back();
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      backgroundColor: btcolordelete,
                    ),
                    child: const Text(
                      "DELETE",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

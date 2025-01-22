import 'package:collaboration_app_client/controllers/tag_controller.dart';
import 'package:collaboration_app_client/models/tag_model.dart';
import 'package:collaboration_app_client/views/home_view.dart';
import 'package:collaboration_app_client/controllers/project_controller.dart';
import 'package:collaboration_app_client/views/widgets/dropdown_tag_widget.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/edit_project_controller.dart';
import '../../utils/color.dart';
import '../new_tag_view.dart';
import '../new_task_view.dart';

class EditProjectForm extends StatefulWidget {
  const EditProjectForm({super.key});

  @override
  State<EditProjectForm> createState() => _EditProjectFormState();
}

class _EditProjectFormState extends State<EditProjectForm> {
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

    final controller = Get.put(EditProjectController());
    final tagController = Get.put(TagController());

    final projectids = Get.put(ProjectController());

    final int projectId = Get.arguments['projectId'];
    final int tagId = Get.arguments['tagId'];

    //final String projectName = Get.arguments['projectName'];

    controller.editprojectname.text = projectids.project.value
        .firstWhere((element) => element.projectId == projectId)
        .projectName;

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
              controller: controller.editprojectname,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    controller.editprojectname.clear();
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
            const Text("Member", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Obx(() {
              return Column(
                children: [
                  // Project Managers Dropdown
                  DropdownSearch<String>.multiSelection(
                    items: controller.editmemberlist
                        .where((member) => !controller.edit_selected_members_map
                            .contains(member)) // Exclude selected members
                        .toList(),
                    selectedItems: controller.edit_selected_manager_map
                        .toList(), // Selected managers
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
                        dialogProps: DialogProps(
                          backgroundColor: Colors.white,
                        ),
                        showSearchBox: true,
                        searchFieldProps: TextFieldProps(
                          decoration: InputDecoration(
                              hintText: "Search Project Managers"),
                        )),
                    onChanged: (newValue) {
                      controller.edit_selected_manager_map.clear();
                      controller.edit_selected_manager_map.addAll(newValue);
                      controller.edit_selected_members_map.removeWhere(
                          (member) =>
                              newValue.contains(member)); // Remove duplicates
                    },
                  ),

                  const SizedBox(height: 20),

                  // Members Dropdown
                  DropdownSearch<String>.multiSelection(
                    items: controller.editmemberlist
                        .where((member) => !controller.edit_selected_manager_map
                            .contains(member)) // Exclude selected members
                        .toList(),
                    selectedItems: controller.edit_selected_members_map
                        .toList(), // Selected members
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
                        dialogProps: DialogProps(
                          backgroundColor: Colors.white,
                        ),
                        showSearchBox: true,
                        searchFieldProps: TextFieldProps(
                          decoration:
                              InputDecoration(hintText: "Search Members"),
                        )),
                    onChanged: (newValue) {
                      controller.edit_selected_members_map.clear();
                      controller.edit_selected_members_map.addAll(newValue);
                      controller.edit_selected_manager_map.removeWhere(
                          (manager) =>
                              newValue.contains(manager)); // Remove duplicates
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
              if (tagController.selectedTag != null &&
                  !tagController.tags.any(
                      (tag) => tag.tagId == tagController.selectedTag!.tagId)) {
                tagController.selectedTag = null;
                print(
                    "Edit Project Form ::::${tagController.selectedTag?.tagName}");
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
                value: tagController.selectedTag,
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
                      /* ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                "Selected: ${controller.selectedTag!.tagName}")),
                      ); */
                    }
                  });
                },
              );
            }),

            // Task List
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
            //               Get.to(const NewTaskView());
            //             },
            //             child: const Icon(
            //               Icons.add,
            //               color: Colors.white,
            //             )))
            //   ],
            // ),

            // Save Button
            const SizedBox(height: 150),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 150,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (controller.editprojectname.text.isNotEmpty) {
                        //print(controller.editselectedtag);
                        await controller.updateProject(projectId, tagId);
                        Get.back();
                      }
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
                      await controller.deleteProject(projectId);
                      Get.back();
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

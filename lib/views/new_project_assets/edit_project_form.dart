import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/edit_project_controller.dart';
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
    final controller = Get.put(EditProjectController());

    return Form(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Project Header
            Text(
              "EDIT PROJECT".toUpperCase(),
              style: const TextStyle(fontSize: 50),
            ),

            // Member Dropdown
            const SizedBox(height: 20),
            const Text("Member", style: TextStyle(fontSize: 18)),
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
                onChanged: (newValue) {
                  controller.editselectedmember.clear();
                  controller.editselectedmember.addAll(newValue);
                },
              );
            }),

            // Tag Dropdown
            const SizedBox(height: 20),
            const Text("Tag", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Obx(() {
              return DropdownSearch<String>(
                  popupProps: PopupProps.menu(
                      title: ElevatedButton(
                          onPressed: () {
                            controller.editselectedtag.clear();
                            Get.to(const NewTagView());
                          },
                          child: const Text("Add Tag"))),
                  items: controller.edittaglist.toList(),
                  selectedItem: controller.editselectedtag.isNotEmpty
                      ? controller.editselectedtag.first
                      : null,
                  dropdownDecoratorProps: const DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  )),
                  onChanged: (value) {
                    controller.editselectedtag.clear();
                    if (value != null) {
                      controller.editselectedtag.add(value);
                    }
                  });
            }),

            // Task List
            const SizedBox(height: 20),
            const Text("Task", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Column(
              children: [
                Container(
                  height: task.length < 4 ? null : 300,
                  color: Colors.black38,
                  padding: const EdgeInsets.all(13),
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
                              duration: const Duration(seconds: 1),
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
                          Get.to(const NewTaskView());
                        },
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                        )))
              ],
            ),

            // Save Button
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 150,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      // controller.updateProject(); // action
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
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
                    child: const Text(
                      "DELETE",
                      style: TextStyle(fontSize: 18),
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

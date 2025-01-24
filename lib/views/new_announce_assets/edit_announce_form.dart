import 'package:collaboration_app_client/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/edit_announce_controller.dart';

class EditAnnounceForm extends StatefulWidget {
  const EditAnnounceForm({super.key});

  @override
  State<EditAnnounceForm> createState() => _EditAnnounceFormState();
}

class _EditAnnounceFormState extends State<EditAnnounceForm> {
  final controller = Get.put(EditAnnounceController());

  @override
  void initState() {
    super.initState();
    final arguments = Get.arguments as Map<String, dynamic>?;

    if (arguments != null) {
      final String announceTitle = arguments['announceTitle'];
      final String announceText = arguments['announceText'];
      final String announceDate = arguments['announceDate'];

      controller.editannouncename.text = announceTitle;
      controller.editannouncedetail.text = announceText;
      controller.editselectedDate = DateTime.parse(announceDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final int projectId = Get.arguments['projectId'];
    final arguments = Get.arguments ?? {};
    if (arguments == null || arguments is! Map<String, dynamic>) {
      print('Invalid or missing arguments');
      return const Center(
        child: Text('Error: Missing or invalid arguments'),
      );
    }
    final int announceId = arguments['announceId'];

    return Form(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // title
            const Text(
              "Title",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: controller.editannouncename,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                //prefixIcon: Icon(Icons.person),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    controller.editannouncename.clear();
                  },
                ),
              ),
              maxLength: 100,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field is required';
                } else if (value.length > 100) {
                  return 'Cannot exceed 100 characters';
                }
                return null;
              },
            ),

            // details
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
              controller: controller.editannouncedetail,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                // prefixIcon: Icon(Icons.abc),
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 20,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    controller.editannouncedetail.clear();
                  },
                ),
              ),
              maxLines: null,
              textAlignVertical: TextAlignVertical.top,
              maxLength: 100,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field is required';
                } else if (value.length > 100) {
                  return 'Cannot exceed 100 characters';
                }
                return null;
              },
            ),

            // text icon [etc.]
            const SizedBox(
              height: 60,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      "Set DateTime".toUpperCase(),
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () async {
                        DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate:
                              controller.editselectedDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (selectedDate != null) {
                          TimeOfDay? selectedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(
                                controller.editselectedDate ?? DateTime.now()),
                          );
                          if (selectedTime != null) {
                            setState(() {
                              controller.editselectedDate = DateTime(
                                selectedDate.year,
                                selectedDate.month,
                                selectedDate.day,
                                selectedTime.hour,
                                selectedTime.minute,
                              );
                              print("Selected DateTime: ${controller.editselectedDate}");

                              print("object");
                            });
                          }
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
                    )
                  ],
                )
              ],
            ),

            // button set announce
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 150,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () async{
                      if (controller.editannouncename.text.isNotEmpty && controller.editannouncedetail.text.isNotEmpty) {
                        print("PBANK${announceId}");
                        await controller.updateAnnounce(announceId);
                        print("Selected DateTime: ${controller.editselectedDate}");
                        Get.back(result: true);
                      } else {
                        ScaffoldMessenger.of(Get.context!).showSnackBar(
                          SnackBar(
                            content: const Row(
                              children: [
                                Icon(Icons.cancel, color: Colors.white),
                                SizedBox(width: 8),
                                Text('Edit Announce Failed.'),
                              ],
                            ),
                            // behavior: SnackBarBehavior.floating,
                            // margin: EdgeInsets.only(bottom: MediaQuery.of(Get.context!).size.height - 260, left: 15, right: 15),
                            action: SnackBarAction(label: "OK", onPressed: () {}), //action
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            duration: const Duration(seconds: 3),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
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
                    onPressed: () async{
                      await controller.deleteAnnounce(announceId, projectId);
                      Get.back(result: true);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
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

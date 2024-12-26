import 'package:collaboration_app_client/utils/color.dart';
import 'package:collaboration_app_client/views/project_view.dart';
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
  Widget build(BuildContext context) {
    final int projectId = Get.arguments['projectId'];
    final arguments = Get.arguments  ?? {};
    if (arguments == null || arguments is! Map<String, dynamic>) {
      print('Invalid or missing arguments');
      return Center(
        child: Text('Error: Missing or invalid arguments'),
      );
    }

    final int announceId = arguments['announceId'] ?? 0;
    if (announceId == null) {
      print('Announce ID is null');
      return Center(
        child: Text('Error: Announce ID is missing'),
      );
    }

    return Form(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // title
            const Text(
              "Title",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: controller.editannouncename,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                //prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
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
            TextField(
              controller: controller.editannouncedetail,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                // prefixIcon: Icon(Icons.abc),
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 20,
                ),
              ),
              maxLines: null,
              textAlignVertical: TextAlignVertical.top,
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
                              ? Colors.red
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
                    onPressed: () {
                      print("PBANK${announceId}");
                      controller.updateAnnounce(announceId);
                      Get.to(ProjectView(),arguments: {'projectId': projectId} );
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
                    onPressed: () {
                      controller.deleteAnnounce(announceId);
                      Get.to(ProjectView(),arguments: {'projectId': projectId} );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: btcolordelete,
                    ),
                    child: const Text(
                      "DELETE",
                      style: TextStyle(fontSize: 18,color: Colors.white),
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

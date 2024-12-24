import 'package:collaboration_app_client/controllers/new_announce_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewAnnounceForm extends StatefulWidget {
  const NewAnnounceForm ({super.key});

  @override
  State<NewAnnounceForm> createState() => _NewAnnounceFormState(); 
}

class _NewAnnounceFormState extends State<NewAnnounceForm> {
  final controller = Get.put(NewAnnounceController());
  @override
  Widget build(BuildContext context) {
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
              controller: controller.announcename,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                //prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),

            // details
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Details",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: controller.announcedetail,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                // prefixIcon: Icon(Icons.abc),
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.only(
                  top: 50,
                  left: 10,
                  right: 10,
                ),
              ),
              maxLines: null,
            ),

            // text icon [etc.]
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      "Set DateTime".toUpperCase(),
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () async {
                        DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate:
                          controller.selectedDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (selectedDate != null) {
                          TimeOfDay? selectedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(
                                controller.selectedDate ?? DateTime.now()),
                          );
                          if (selectedTime != null) {
                            setState(() {
                              controller.selectedDate = DateTime(
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
                    )
                  ],
                )
              ],
            ),

            // button set announce
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  print("setsetset"); // action
                  // Get.to(NewAnnounceView());
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  "Set an Announcement",
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
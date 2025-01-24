import 'package:collaboration_app_client/controllers/new_announce_controller.dart';
import 'package:collaboration_app_client/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewAnnounceForm extends StatefulWidget {
  const NewAnnounceForm({super.key});

  @override
  State<NewAnnounceForm> createState() => _NewAnnounceFormState();
}

class _NewAnnounceFormState extends State<NewAnnounceForm> {
  bool _emptytitle = true;
  bool _emptytext = true;
  bool _emptydate = true;

  final projectId = Get.arguments['projectId'];
  final tagId = Get.arguments['tagId'];
  final userId = Get.arguments['userId'];
  final controller = Get.put(NewAnnounceController());

  @override
  void initState() {
    super.initState();

  }

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
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: controller.announceTitle,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                //prefixIcon: Icon(Icons.person),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    controller.announceTitle.clear();
                    setState(() {
                      _emptytitle = true;
                    });
                  },
                ),
              ),
              maxLength: 100,
              onChanged: (value) {
                setState(() {
                  _emptytitle = value.isEmpty;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field is required';
                } else if (value.length > 100) {
                  return 'Cannot exceed 100 characters';
                }
                return null;
              },
            ),
            if (_emptytitle)
              const Text(
                "Please enter announce title.",
                style: TextStyle(color: Colors.red, fontSize: 14),
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
              controller: controller.announceText,
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
                    controller.announceText.clear();
                    setState(() {
                      _emptytext = true;
                    });
                  },
                ),
              ),
              maxLines: null,
              textAlignVertical: TextAlignVertical.top,
              maxLength: 100,
              onChanged: (value) {
                setState(() {
                  _emptytext = value.isEmpty;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field is required';
                } else if (value.length > 100) {
                  return 'Cannot exceed 100 characters';
                }
                return null;
              },
            ),
            if (_emptytext)
              const Text(
                "Please enter announce details.",
                style: TextStyle(color: Colors.red, fontSize: 14),
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
                              controller.selectedDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (selectedDate != null) {
                          setState(() {
                            _emptydate = false;
                          });
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
                        } else if (selectedDate == null) {
                          setState(() {
                            _emptydate = true;
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
                              ? Colors.green
                              : Colors.black,
                          size: 70,
                        ),
                      ),
                    ),
                    if (_emptydate)
                      const Text(
                        "Please select Datetime.",
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      ),
                  ],
                )
              ],
            ),

            // button set announce
            const SizedBox(height: 60),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  if (controller.selectedDate != null &&
                      controller.announceTitle.text.isNotEmpty &&
                      controller.announceText.text.isNotEmpty) {
                    controller.createAnnounce(projectId);
                    Get.back();
                  } else {
                    ScaffoldMessenger.of(Get.context!).showSnackBar(
                      SnackBar(
                        content: const Row(
                          children: [
                            Icon(Icons.cancel, color: Colors.white),
                            SizedBox(width: 8),
                            Text('Create Announce Failed.'),
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
                  // } else if (controller.announceTitle.text.isEmpty) {
                  //   // setState(() {
                  //   //   _emptytitle = true;
                  //   //   _emptytext = false;
                  //   //   _emptydate = false;
                  //   // });
                  //   ScaffoldMessenger.of(Get.context!).showSnackBar(
                  //     SnackBar(
                  //       content: const Row(
                  //         children: [
                  //           Icon(Icons.cancel, color: Colors.white),
                  //           SizedBox(width: 8),
                  //           Text('Please enter announce title.'),
                  //         ],
                  //       ),
                  //       // behavior: SnackBarBehavior.floating,
                  //       // margin: EdgeInsets.only(bottom: MediaQuery.of(Get.context!).size.height - 260, left: 15, right: 15),
                  //       action: SnackBarAction(label: "OK", onPressed: () {}), //action
                  //       backgroundColor: Colors.red,
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(10),
                  //       ),
                  //       duration: Duration(seconds: 3),
                  //     ),
                  //   );
                  // } else if (controller.announceText.text.isEmpty) {
                  //   // setState(() {
                  //   //   _emptytitle = false;
                  //   //   _emptytext = true;
                  //   //   _emptydate = false;
                  //   // });
                  //   ScaffoldMessenger.of(Get.context!).showSnackBar(
                  //     SnackBar(
                  //       content: const Row(
                  //         children: [
                  //           Icon(Icons.cancel, color: Colors.white),
                  //           SizedBox(width: 8),
                  //           Text('Please enter announce details.'),
                  //         ],
                  //       ),
                  //       // behavior: SnackBarBehavior.floating,
                  //       // margin: EdgeInsets.only(bottom: MediaQuery.of(Get.context!).size.height - 260, left: 15, right: 15),
                  //       action: SnackBarAction(label: "OK", onPressed: () {}), //action
                  //       backgroundColor: Colors.red,
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(10),
                  //       ),
                  //       duration: Duration(seconds: 3),
                  //     ),
                  //   );
                  // } else if (controller.selectedDate == null) {
                  //   // setState(() {
                  //   //   _emptytitle = false;
                  //   //   _emptytext = false;
                  //   //   _emptydate = true;
                  //   // });
                  //   ScaffoldMessenger.of(Get.context!).showSnackBar(
                  //     SnackBar(
                  //       content: const Row(
                  //         children: [
                  //           Icon(Icons.cancel, color: Colors.white),
                  //           SizedBox(width: 8),
                  //           Text('Please select Datetime.'),
                  //         ],
                  //       ),
                  //       // behavior: SnackBarBehavior.floating,
                  //       // margin: EdgeInsets.only(bottom: MediaQuery.of(Get.context!).size.height - 260, left: 15, right: 15),
                  //       action: SnackBarAction(label: "OK", onPressed: () {}), //action
                  //       backgroundColor: Colors.red,
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(10),
                  //       ),
                  //       duration: Duration(seconds: 3),
                  //     ),
                  //   );
                  // }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: btcolor,
                ),
                child: const Text(
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/edit_announce_controller.dart';

class EditAnnounceForm extends StatefulWidget {
  const EditAnnounceForm ({super.key});

  @override
  State<EditAnnounceForm> createState() => _EditAnnounceFormState();
}

class _EditAnnounceFormState extends State<EditAnnounceForm> {
  final controller = Get.put(EditAnnounceController());
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            // title
            const SizedBox(height: 30,),
            Text("EDIT ANNOUNCE".toUpperCase(),style: TextStyle(fontSize: 44),),
            const SizedBox(height: 20,),
            Text("Title",style: TextStyle(fontSize: 18),),
            const SizedBox(height: 10,),
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
            const SizedBox(height: 20,),
            Text("Details", style: TextStyle(fontSize: 18),),
            const SizedBox(height: 10,),
            TextField(
              controller: controller.editannouncedetail,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                // prefixIcon: Icon(Icons.abc),
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.only(top: 50, left: 10, right: 10,),
              ),
              maxLines: null,
            ),

            // text icon [etc.]
            const SizedBox(height: 50,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text("Set DateTime".toUpperCase(), style: TextStyle(fontSize: 20),),
                    const SizedBox(height: 10,),
                    GestureDetector(
                      onTap: () async {
                        DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: controller.editselectedDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (selectedDate != null) {
                          TimeOfDay? selectedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(controller.editselectedDate ?? DateTime.now()),
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
                            :  'No date selected',
                        child: Icon(
                          Icons.date_range,
                          color: controller.editselectedDate != null ? Colors.red : Colors.black,
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
          ],
        ),
      ),
    );
  }
}
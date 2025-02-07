import 'package:collaboration_app_client/controllers/new_project_controller.dart';
import 'package:collaboration_app_client/controllers/new_tag_controller.dart';
import 'package:collaboration_app_client/controllers/tag_controller.dart';
import 'package:collaboration_app_client/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';

class NewTagForm extends StatefulWidget {
  const NewTagForm({super.key});

  @override
  State<NewTagForm> createState() => _NewTagFormState();
}

class _NewTagFormState extends State<NewTagForm> {
  void _spectrumColorPicker(BuildContext context) {
    final tagcontroller = Get.find<NewTagController>();
    //
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Pick a Color"),
          content: SingleChildScrollView(
            child: ColorPicker(
              // spectrum color
              pickerColor: tagcontroller.currenttagColor,
              onColorChanged: (Color color) {
                tagcontroller.changeColor(color);
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // update color controller
                Get.back();
              },
              child: const Text("Select"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final tagcontroller = Get.put(NewTagController());
    final tagRefresher = Get.find<TagController>();

    return Form(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // tag name ---------------
            const Text(
              "Tag Name",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: tagcontroller.tagname,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                //prefixIcon: Icon(Icons.person),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    tagcontroller.tagname.clear();
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
              onChanged: (value) {
                tagcontroller.updateTagName(
                    tagcontroller.tagname.text); // Update tag name
              },
            ),
            //select color ---------------
            const SizedBox(
              height: 60,
            ),
            ElevatedButton(
              onPressed: () => _spectrumColorPicker(context),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: const Size(200, 50),
                backgroundColor: btcolor,
              ),
              child: const Text("Select Color"),
            ),

            // Tag review
            const SizedBox(height: 60),
            Text("Tag Preview :",style: TextStyle(fontSize: 22,color: Colors.black,),),
            const SizedBox(height: 20,),
            GetBuilder<NewTagController>(builder: (controller) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                decoration: BoxDecoration(
                  color: controller.currenttagColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  controller.tagname.text.isNotEmpty
                      ? controller.tagname.text
                      : "Your Tag",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }),

            // Save Button
            const SizedBox(height: 70),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () async {
                  if (tagcontroller.tagname.text.isNotEmpty) {
                    await tagcontroller.createTag(onCompleted: () async {
                      await tagRefresher.fetchTag();
                      Get.back();
                    });
                  } else {
                    ScaffoldMessenger.of(Get.context!).showSnackBar(
                      SnackBar(
                        content: const Row(
                          children: [
                            Icon(Icons.cancel, color: Colors.white),
                            SizedBox(width: 8),
                            Text('Create Tag Failed.'),
                          ],
                        ),
                        action: SnackBarAction(label: "OK", onPressed: () {}), //action
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        duration: Duration(seconds: 3),
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
                  "Create Tag",
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

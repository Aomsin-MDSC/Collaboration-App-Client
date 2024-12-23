import 'package:collaboration_app_client/controllers/new_tag_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import '../../controllers/edit_tag_controller.dart';

class EditTagForm extends StatefulWidget {
  const EditTagForm({super.key});

  @override
  State<EditTagForm> createState() => _EditTagFormState();
}

class _EditTagFormState extends State<EditTagForm> {
  void _spectrumColorPicker(BuildContext context) {
    final tagcontroller = Get.find<EditTagController>();
    final screenres = MediaQuery.of(context).size.width;
    //
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Pick a Color"),
          content: SingleChildScrollView(
            child: ColorPicker(
              // spectrum color
              pickerColor: tagcontroller.editcurrenttagColor,
              onColorChanged: (Color color) {
                tagcontroller.editchangeColor(color);
              },
              showLabel: true,
              pickerAreaHeightPercent: screenres * 0.002,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {// update color controller
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
    final tagcontroller = Get.put(EditTagController());
    final screenres = MediaQuery.of(context).size.width;
    return Form(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: screenres * 0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // tag name ---------------
            Text(
              "Tag Name",
              style: TextStyle(fontSize: screenres * 0.05),
            ),
            SizedBox(
              height: screenres * 0.02,
            ),
            TextField(
              controller: tagcontroller.edittagname,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                //prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                tagcontroller.editupdateTagName(
                    tagcontroller.edittagname.text); // Update tag name
              },
            ),

            // circle color ---------------
            SizedBox(
              height: screenres * 0.1,
            ),
            GetBuilder<EditTagController>(builder: (controller) {
              return CircleAvatar(
                radius: screenres * 0.1,
                backgroundColor: controller.editcurrenttagColor,
              );
            }),

            //select color ---------------
            SizedBox(
              height: screenres * 0.05,
            ),
            ElevatedButton(
              onPressed: () => _spectrumColorPicker(context),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(screenres * 0.02),
                ),
                minimumSize: Size(screenres * 0.1, screenres * 0.1),
              ),
              child: const Text("Select Color"),
            ),

            // Tag review
            SizedBox(height: screenres * 0.15),
            GetBuilder<EditTagController>(builder: (controller) {
              // preview [container] Taxt
              return Container(
                padding:
                EdgeInsets.symmetric(vertical: screenres * 0.02, horizontal: screenres * 0.05),
                decoration: BoxDecoration(
                  color: controller.editcurrenttagColor,
                  borderRadius: BorderRadius.circular(screenres * 0.02),
                ),
                child: Text(
                  controller.edittagname.text.isNotEmpty
                      ? controller.edittagname.text
                      : "Tag Preview",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenres * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );

              // preview snackbar {tag name & color #}
              // return ElevatedButton(
              //   onPressed: () {
              //     Get.snackbar(
              //       "Tag Preview",
              //       "Tag Name: ${controller.tagname.text.isNotEmpty
              //           ? controller.tagname.text
              //           : 'No Tag Name'}\nColor: ${controller.tagcolor}",
              //       colorText: Colors.white,
              //       margin: const EdgeInsets.all(10),
              //     );
              //   },
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: controller.currenttagColor,
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //     minimumSize: const Size(300, 50),
              //   ),
              //   child: Text(
              //     controller.tagname.text.isNotEmpty
              //         ? controller.tagname.text
              //         : "Tag Preview",
              //     style: const TextStyle(
              //       color: Colors.white,
              //       fontSize: 18,
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // );
            }),

            // Save Button
            SizedBox(height: screenres * 0.15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: screenres * 0.35,
                  height: screenres * 0.15,
                  child: ElevatedButton(
                    onPressed: () {
                      print("makemakemake"); // action
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(screenres * 0.03),
                      ),
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(
                      "SAVE",
                      style: TextStyle(fontSize: screenres * 0.05),
                    ),
                  ),
                ),
                SizedBox(
                  width: screenres * 0.35,
                  height: screenres * 0.15,
                  child: ElevatedButton(
                    onPressed: () {
                      print("deldeldel"); // action
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(screenres * 0.03),
                      ),
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(
                      "DELETE",
                      style: TextStyle(fontSize: screenres * 0.05),
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

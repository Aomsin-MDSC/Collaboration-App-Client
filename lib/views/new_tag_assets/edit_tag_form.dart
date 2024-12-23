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
    final tagcontroller = Get.put(EditTagController());
    return Form(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
            ),
            Text(
              "EDIT TAG",
              style: TextStyle(fontSize: 50),
            ),
            const SizedBox(
              height: 20,
            ),

            // tag name ---------------
            Text(
              "Tag Name",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(
              height: 10,
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
            const SizedBox(
              height: 50,
            ),
            GetBuilder<EditTagController>(builder: (controller) {
              return CircleAvatar(
                radius: 40,
                backgroundColor: controller.editcurrenttagColor,
              );
            }),

            //select color ---------------
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () => _spectrumColorPicker(context),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                minimumSize: const Size(200, 50),
              ),
              child: const Text("Select Color"),
            ),

            // Tag review
            const SizedBox(height: 50),
            GetBuilder<EditTagController>(builder: (controller) {
              // preview [container] Taxt
              return Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  color: controller.editcurrenttagColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  controller.edittagname.text.isNotEmpty
                      ? controller.edittagname.text
                      : "Tag Preview",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
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

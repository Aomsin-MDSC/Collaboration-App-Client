import 'package:collaboration_app_client/controllers/new_tag_controller.dart';
import 'package:collaboration_app_client/controllers/tag_controller.dart';
import 'package:collaboration_app_client/utils/color.dart';
import 'package:collaboration_app_client/views/new_project_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import '../../controllers/edit_tag_controller.dart';
import '../../controllers/new_project_controller.dart';

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
    final tagId = Get.arguments['tagId'];
    final tagName = Get.arguments['tagName'];
    final tagColor = Get.arguments['tagColor'];

    tagcontroller.edittagname.text = tagName;
    tagcontroller.tagcolor = tagColor;

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
              controller: tagcontroller.edittagname,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    tagcontroller.edittagname.clear();
                  },
                ),
                border: const OutlineInputBorder(),
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
                tagcontroller.editupdateTagName(
                    tagcontroller.edittagname.text); // Update tag name
              },
            ),

            // circle color ---------------
            const SizedBox(
              height: 60,
            ),
            GetBuilder<EditTagController>(builder: (controller) {
              return CircleAvatar(
                radius: 40,
                backgroundColor: controller.editcurrenttagColor,
              );
            }),

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
            GetBuilder<EditTagController>(builder: (controller) {
              // preview [container] Taxt
              return Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                decoration: BoxDecoration(
                  color: controller.editcurrenttagColor,
                  borderRadius: BorderRadius.circular(30),
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

            const SizedBox(height: 70),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 150,
                  height: 60,
                  child: ElevatedButton(
                      onPressed: () async {
                        if (tagcontroller.edittagname.text.isNotEmpty) {
                          await tagcontroller.updateTag(tagId, onCompleted: () {
                            Get.back(result: true);
                          });
                        }
                        else{
                          ScaffoldMessenger.of(Get.context!).showSnackBar(
                            SnackBar(
                              content:  Row(
                                children: [
                                  Icon(Icons.cancel, color: Colors.white),
                                  SizedBox(width: 8),
                                  Text('Save Tag Failed.'),
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
                      await tagcontroller.deleteTag(tagId);
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

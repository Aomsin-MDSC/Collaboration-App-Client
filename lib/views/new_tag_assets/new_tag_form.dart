import 'package:collaboration_app_client/controllers/new_tag_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';

class NewTagForm extends StatefulWidget {
  const NewTagForm ({super.key});

  @override
  State<NewTagForm> createState() => _NewTagFormState();
}

class _NewTagFormState extends State<NewTagForm> {
  void _spectrumColorPicker(BuildContext context) {
    final tagcontroller = Get.find<NewTagController>();
    Color currentColor = tagcontroller.currenttagColor; // get update color

    //
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Pick a Color"),
          content: SingleChildScrollView(
            child: ColorPicker( // spectrum color
              pickerColor: currentColor,
              onColorChanged: (Color color) {
                currentColor = color;
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {

                Get.back();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                tagcontroller.changeColor(currentColor); // update color controller
                Get.back();
              },
              child: const Text("Select"),
            ),
          ],
        );
      }
    );
  }


  @override
  Widget build(BuildContext context) {
    final tagcontroller = Get.put(NewTagController());
    return Form(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30,),
            Text("NEW TAG",style: TextStyle(fontSize: 50),),
            const SizedBox(height: 20,),

            // tag name ---------------
            Text("Tag Name",style: TextStyle(fontSize: 18),),
            const SizedBox(height: 10,),
            TextField(
              controller: tagcontroller.tagname,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                //prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),

            // circle color ---------------
            const SizedBox(height: 50,),
            GetBuilder<NewTagController>(builder: (controller) {
              return CircleAvatar(
                radius: 40,
                backgroundColor: controller.currenttagColor,
              );
            }),

            //select color ---------------
            const SizedBox(height: 30,),
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
            GetBuilder<NewTagController>(builder: (controller) {

              // preview [container] Taxt
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  color: controller.currenttagColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                controller.tagname.text.isNotEmpty ? controller.tagname.text : "Tag Preview",
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
          ],
        ),
      ),
    );
  }
}
import 'package:collaboration_app_client/controllers/new_tag_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewTagForm extends StatefulWidget {
  const NewTagForm ({super.key});

  @override
  State<NewTagForm> createState() => _NewTagFormState();
}

class _NewTagFormState extends State<NewTagForm> {
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
                backgroundColor: controller.tagcolor,
              );
            }),

            //select color ---------------
            const SizedBox(height: 30,),
            ElevatedButton(
              onPressed: () {
                print("select");
              },
              child: Text("Select Color"),
            )
          ],
        ),
      ),
    );
  }
}
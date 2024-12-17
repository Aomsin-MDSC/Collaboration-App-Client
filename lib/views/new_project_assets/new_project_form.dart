import 'package:collaboration_app_client/controllers/new_project_controller.dart';
import 'package:collaboration_app_client/controllers/new_tag_controller.dart';
import 'package:collaboration_app_client/views/Login_View.dart';
import 'package:collaboration_app_client/views/home_view.dart';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewProjectForm extends StatefulWidget {
  const NewProjectForm({super.key});

  @override
  State<NewProjectForm> createState() => _NewProjectFormState();
}

class _NewProjectFormState extends State<NewProjectForm> {
  @override
  Widget build(BuildContext context) {
    final projectcontroller = Get.put(NewProjectController());
    final tagcontroller = Get.put(NewTagController());
    return Form(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30,),
            Text("NEW PROJECT".toUpperCase(),style: TextStyle(fontSize: 50),),
            const SizedBox(height: 30,),
            Text("Project Name",style: TextStyle(fontSize: 18),),
            const SizedBox(height: 30,),
            TextField(
              controller: projectcontroller.projectname,
              decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  //prefixIcon: Icon(Icons.person), //pick icon
                  border: OutlineInputBorder(),
              ),
            ),

            //Member
            const SizedBox(height: 30,),
            Text("Member",style: TextStyle(fontSize: 18),),
            const SizedBox(height: 10,),
            Obx(() {
              return DropdownSearch<String>.multiSelection(
                items: projectcontroller.memberlist.toList(),
                selectedItems: projectcontroller.selectedmember.toList(),
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    //labelText: "Select Member",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  )
                ),
                //--------------------
                // For Search
                //popupProps: PopupPropsMultiSelection.menu(
                //  showSelectedItems: true,
                //  showSearchBox: true,
                //  searchFieldProps: TextFieldProps(
                //    decoration: InputDecoration(
                //      filled: true,
                //      fillColor: Colors.white,
                //      hintText: "Search",
                //      border: OutlineInputBorder(),
                //    ),
                //  ),
                //),
                // --------------------
              );
            }),
            const SizedBox(height: 30,),
            Text("Tag",style: TextStyle(fontSize: 18),),
            const SizedBox(height: 10,),
            Obx(() {
              return DropdownSearch<String>(
                items: tagcontroller.taglist.toList(),
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  )
                ),
                onChanged: (value){
                  if (value == "Add Tag"){
                    Get.to(HomeView());
                  }
                },
              );
            }),
            const SizedBox(height: 30),
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min, // ใช้ MainAxisSize.min เพื่อลดปัญหา infinite size
                children: [

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
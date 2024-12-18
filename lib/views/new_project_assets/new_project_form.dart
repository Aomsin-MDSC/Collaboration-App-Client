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
            //  Project --------------------
            const SizedBox(height: 30,),
            Text("NEW PROJECT".toUpperCase(),style: TextStyle(fontSize: 50),),
            const SizedBox(height: 20,),
            Text("Project Name",style: TextStyle(fontSize: 18),),
            const SizedBox(height: 10,),
            TextField(
              controller: projectcontroller.projectname,
              decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  //prefixIcon: Icon(Icons.person), //pick icon
                  border: OutlineInputBorder(),
              ),
            ),

            //  Member  --------------------
            const SizedBox(height: 20,),
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
                // // --------------------
                // popupProps: PopupProps.menu(
                //
                // ),
              );
            }),

            //  Tag --------------------
            const SizedBox(height: 20,),
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

            //  Task  --------------------
            const SizedBox(height: 20),
            Text("Task", style: TextStyle(fontSize: 18),),
            const SizedBox(height: 10,),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 130, child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(13),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row( // Example 1
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Task 1 etc.", style: TextStyle(fontSize: 16),),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                print("delete task");
                              },
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Container(
                        padding: const EdgeInsets.all(13),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row( // Example 2
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Task 2 etc.", style: TextStyle(fontSize: 16),),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                print("delete task");
                              },
                            )
                          ],
                        ),
                      ),

                      // button add task
                      const SizedBox(height: 10,),
                      Container(
                        padding: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              print("AddTask");
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),)
              ],
            ),

            // button Save New project page
            const SizedBox(height: 40,),
            SizedBox(
              width: double.infinity, 
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  print("gogogo");
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                child: Text("Save",style: TextStyle(fontSize: 18),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
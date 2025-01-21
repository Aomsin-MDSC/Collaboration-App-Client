import 'package:collaboration_app_client/controllers/edit_tag_controller.dart';
import 'package:collaboration_app_client/controllers/edit_task_controller.dart';
import 'package:collaboration_app_client/controllers/new_project_controller.dart';
import 'package:collaboration_app_client/controllers/tag_controller.dart';
import 'package:collaboration_app_client/models/tag_model.dart';
import 'package:collaboration_app_client/utils/color.dart';
import 'package:collaboration_app_client/views/edit_tag_view.dart';
import 'package:collaboration_app_client/views/new_tag_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../controllers/in_project_controller.dart';
import '../../controllers/new_task_controller.dart';

class DropdownTagWidget extends StatefulWidget {
  const DropdownTagWidget({super.key, required this.tag});

  final TagModel tag;

  @override
  State<DropdownTagWidget> createState() => _DropdownTagWidgetState();
}

class _DropdownTagWidgetState extends State<DropdownTagWidget> {
  @override
  Widget build(BuildContext context) {
      final controller = Get.put(NewProjectController());
      final edittagcontroller = Get.put(TagController());
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Chip(
            label: Text(
              widget.tag.tagName,
              style: const TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis, // ตัดข้อความด้วย "..."
            ),
            backgroundColor: HexColor.fromHex(widget.tag.tagColor),
            labelStyle: TextStyle(color: Colors.white),
          ),
        ),
        IconButton(
          icon: Icon(Icons.edit, color: Colors.black54),
          onPressed:  () async {
            // ฟังก์ชันเมื่อกดปุ่ม "Edit"
         await  Get.to(EditTagView(), arguments: {
              'tagId': widget.tag.tagId,
              'tagName': widget.tag.tagName,
              'tagColor': widget.tag.tagColor
            })?.then((result) async {
             if (controller.selectedTag != null &&
                !controller.tags
                    .any((tag) => tag.tagId == controller.selectedTag!.tagId)) {
              controller.selectedTag = null;
            }
              if (result == true) {
                await controller.fetchTags();
                await edittagcontroller.fetchTagMap(widget.tag.tagId!);
              } else {
                print("Result from DropdownTagWidget ::: $result");
              }
            });
        
          },
        ),
      ],
    );
  }
}

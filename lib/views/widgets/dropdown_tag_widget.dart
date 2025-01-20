import 'package:collaboration_app_client/controllers/new_project_controller.dart';
import 'package:collaboration_app_client/models/tag_model.dart';
import 'package:collaboration_app_client/utils/color.dart';
import 'package:collaboration_app_client/views/edit_tag_view.dart';
import 'package:collaboration_app_client/views/new_tag_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

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
      final controller = Get.put(NewTaskController());

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
          onPressed: () {
            // ฟังก์ชันเมื่อกดปุ่ม "Edit"
            Get.to(EditTagView(), arguments: {
              'tagId': widget.tag.tagId,
              'tagName': widget.tag.tagName,
              'tagColor': widget.tag.tagColor
            })?.then((result) async {
              result == true? await controller.fetchTags():print("Result form DropdownTagWidget ::: $result");
            });
          },
        ),
      ],
    );
  }
}

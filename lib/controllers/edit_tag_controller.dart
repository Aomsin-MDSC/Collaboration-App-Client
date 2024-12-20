import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditTagController extends GetxController {
  static EditTagController get instance => Get.find();

  final edittagname = TextEditingController(); //get tag name
  String tagcolor = "#808080";

  void editchangeColor(Color color) {
    tagcolor = "#${color.value.toRadixString(16).substring(2)}";
    update();
  }

  void editupdateTagName(String name) {
    edittagname.text = name;
    update();
  }

  Color get editcurrenttagColor =>
      Color(int.parse(tagcolor.replaceFirst('#', '0xff')));
}

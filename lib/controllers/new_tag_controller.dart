import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewTagController extends GetxController {
  static NewTagController get instance => Get.find();

  final tagname = TextEditingController(); //get tag name
  String tagcolor = "#808080";

  void changeColor(Color color) {
    tagcolor = "#${color.value.toRadixString(16).substring(2)}";
    update();
  }

  Color get currenttagColor => Color(int.parse(tagcolor.replaceFirst('#','0xff')));
}
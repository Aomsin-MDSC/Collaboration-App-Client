import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewTagController extends GetxController {
  static NewTagController get instance => Get.find();

  final tagname = TextEditingController(); //get tag name
  Color tagcolor = Colors.grey;

  void changeColor(Color color) {
    tagcolor = color;
    update();
  }

}
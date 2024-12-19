import 'package:get/get.dart';
import 'package:flutter/material.dart';

class NewTaskController extends GetxController {
  static NewTaskController get instance => Get.find();

  final taskname = TextEditingController();
  final taskdetails = TextEditingController();
  String taskcolor = "#808080";
  DateTime? selectedDate; // get day selected

  var memberlist = <String>[
    'shouta',
    'thank',
    'pob',
    'fam',
    'who',
    'who1',
    'who2',
    'who3',
  ].obs;

  // get memberlist for show
  var selectedmember = <String>[].obs;

  var taglist = <String>[
    'work',
    'job',
    'present',
    'Add Tag',
  ].obs;

  // get tag for show
  var selectedtag = <String>[].obs;

  void taskchangeColor(Color color) {
    taskcolor = "#${color.value.toRadixString(16).substring(2)}";
    update();
  }

  Color get taskcurrenttagColor => Color(int.parse(taskcolor.replaceFirst('#','0xff')));
}
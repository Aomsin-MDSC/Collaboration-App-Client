import 'package:get/get.dart';
import 'package:flutter/material.dart';

class EditTaskController extends GetxController {
  static EditTaskController get instance => Get.find();

  final edittaskname = TextEditingController();
  final edittaskdetails = TextEditingController();
  String edittaskcolor = "#808080";
  DateTime? editselectedDate; // get day selected

  // member
  var editmemberlist = <String>[
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
  var editselectedmember = <String>[].obs;

  // tag
  var edittaglist = <String>[
    'work',
    'job',
    'present',
    'Add Tag',
  ].obs;

  // get tag for show
  var editselectedtag = <String>[].obs;


  // colors
  void edittaskchangeColor(Color color) {
    edittaskcolor = "#${color.value.toRadixString(16).substring(2)}";
    update();
  }

  Color get taskcurrenttagColor => Color(int.parse(edittaskcolor.replaceFirst('#','0xff')));
}
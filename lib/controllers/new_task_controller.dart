import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'new_project_controller.dart';

class NewTaskController extends GetxController {
  static NewTaskController get instance => Get.find();
  var isLoading = true.obs;
  final controller = Get.put(NewProjectController());

  final taskName = TextEditingController();
  final taskdetails = TextEditingController();
  String taskcolor = "#808080";

  DateTime? selectedDate; // get day selected

  // member
  var memberlist = <String>[
    'shouta',
    'thank',
    'pob',
    'fam',
  ].obs;

  // get memberlist for show
  var selectedmember = <String>[].obs;
  var membersMap = <String, int>{}.obs;

  // tag
  var taglist = <String>[
    'work',
    'job',
    'present',
    'Add Tag',
  ].obs;

  final taskList = RxList<Task>([
    Task(taskName: 'Task 1', isToggled: false),
    Task(taskName: 'Task 2', isToggled: false),
    Task(taskName: 'Task 3', isToggled: false),
    Task(taskName: 'Task 4', isToggled: false),
    Task(taskName: 'Task 5', isToggled: false),
    Task(taskName: 'Task 6', isToggled: false),
  ]);

  // get tag for show
  var selectedtag = <String>[].obs;

  // colors
  void taskchangeColor(Color color) {
    taskcolor = "#${color.value.toRadixString(16).substring(2)}";
    update();
  }

  Color get taskcurrenttagColor =>
      Color(int.parse(taskcolor.replaceFirst('#', '0xff')));
}

class Task {
  final String? taskName;
  late bool isToggled;

  Task({
    required this.taskName,
    required this.isToggled,
  });
}

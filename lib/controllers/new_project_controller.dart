import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class NewProjectController extends GetxController {
  static NewProjectController get instance => Get.find();

  final projectname = TextEditingController();
  //final memberlist = TextEditingController();
  var memberlist = <String>[
    'shouta',
    'thank',
    'pob',
    'fam'
  ].obs;

  // get memberlist for show
  var selectedmember = <String>[].obs;
}
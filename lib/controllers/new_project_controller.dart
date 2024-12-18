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
}
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class NewTagController extends GetxController {
  static NewTagController get instance => Get.find();

  var taglist = <String>[
    'work',
    'job',
    'present',
    'Add Tag',
  ].obs;

  // get tag for show
  var selectedtag = <String>[].obs;
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewAnnounceController extends GetxController {
  static NewAnnounceController get instance => Get.find();

  final announcename = TextEditingController();
  final announcedetail = TextEditingController();
  DateTime? selectedDate;
}
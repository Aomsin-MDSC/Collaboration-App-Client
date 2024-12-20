import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditAnnounceController extends GetxController {
  static EditAnnounceController get instance => Get.find();

  final editannouncename = TextEditingController();
  final editannouncedetail = TextEditingController();
  DateTime? editselectedDate;
}
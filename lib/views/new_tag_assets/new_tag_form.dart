

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewTagForm extends StatefulWidget {
  const NewTagForm ({super.key});

  @override
  State<NewTagForm> createState() => _NewTagFormState();
}

class _NewTagFormState extends State<NewTagForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("Text")
      ],
    );
  }
}
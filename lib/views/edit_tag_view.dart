import 'package:flutter/material.dart';
import 'new_tag_assets/edit_tag_form.dart';

class EditTagView extends StatelessWidget {
  const EditTagView ({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(255, 237, 122, 1),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [EditTagForm()],
            ),
          ),
        ),
      ),
    );
  }
}
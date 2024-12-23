import 'package:flutter/material.dart';
import 'new_announce_assets/edit_announce_form.dart';

class EditAnnounceView extends StatelessWidget {
  const EditAnnounceView ({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
        ),
        backgroundColor: const Color.fromRGBO(161, 182, 255, 1),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [EditAnnounceForm()],
            ),
          ),
        ),
      ),
    );
  }
}
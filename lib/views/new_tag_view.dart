import 'package:flutter/material.dart';
import 'package:collaboration_app_client/views/new_tag_assets/new_tag_form.dart';

class NewTagView extends StatelessWidget {
  const NewTagView ({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          title: const Text("NEW TAG",
            style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        backgroundColor: const Color.fromRGBO(255, 237, 122, 1),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [NewTagForm()],
            ),
          ),
        ),
      ),
    );
  }
}
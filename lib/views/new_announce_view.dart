import 'package:flutter/material.dart';
import 'new_announce_assets/new_announce_form.dart';

class NewAnnounceView extends StatelessWidget {
  const NewAnnounceView ({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(161, 182, 255, 1),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [NewAnnounceForm()],
            ),
          ),
        ),
      ),
    );
  }
}
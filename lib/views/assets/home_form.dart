import 'package:collaboration_app_client/models/testmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controllers/testfetchcontroller.dart';

class ProjectCard extends StatelessWidget {
  final Product product;

  const ProjectCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ListTile(
                title: Text(product.title),
                subtitle: Text('${product.price} \$'),
                trailing: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.settings),
                  iconSize: 30,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

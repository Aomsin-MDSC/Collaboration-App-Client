import 'package:collaboration_app_client/models/testmodel.dart';
import 'package:flutter/material.dart';

class ProjectCard extends StatelessWidget {
  final Project product;

  const ProjectCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        // padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero), // Set padding to zero
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        ),
      ),
      onPressed: (){},
      child: Card(
        // margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ListTile(
                title: Text(product.projectName),
                subtitle: Text('${product.tagName} \$'),
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

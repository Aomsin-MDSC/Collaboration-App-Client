import 'package:collaboration_app_client/views/new_project_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:get/get.dart';

// import 'assets/home_footer.dart';
import '../controllers/testfetchcontroller.dart';
import '../models/testmodel.dart';
import 'assets/home_form.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    // Initialize the ProductController
    Get.put(ProductController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ProductController productController = Get.find<ProductController>();

    return SafeArea(
        child: Scaffold(
            // floatingActionButtonLocation:
            //     FloatingActionButtonLocation.centerFloat,
            // floatingActionButton: FloatingActionButton.large(
            //     child: const Icon(Icons.add), onPressed: ()=> (Get.to(NewProjectView()))),
            floatingActionButtonLocation: ExpandableFab.location,
            floatingActionButton: ExpandableFab(
              openButtonBuilder: RotateFloatingActionButtonBuilder(fabSize: ExpandableFabSize.large, child: const Icon(Icons.add)),
              pos: ExpandableFabPos.center,
              children: [
                FloatingActionButton.small(
                  heroTag: null,
                  child: const Icon(Icons.edit),
                  onPressed: () => (Get.to(NewProjectView())),
                ),
                FloatingActionButton.small(
                  heroTag: null,
                  child: const Icon(Icons.search),
                  onPressed: () {},
                ),
              ],
            ),
            appBar: AppBar(
              title: const Text("Home Page"),
            ),
            body: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Obx(() {
                if (productController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                } else if (productController.products.isEmpty) {
                  return const Center(child: Text('No products found'));
                } else {
                  return ListView.builder(
                    primary: false,
                    itemCount: productController.products.length,
                    itemBuilder: (context, index) {
                      return ProjectCard(
                          product: productController.products[index]);
                    },
                  );
                }
              }),
            )
        )
    );
  }
}

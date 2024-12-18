import 'package:collaboration_app_client/views/new_project_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:get/get.dart';
import '../controllers/testfetchcontroller.dart'; // Adjust the import paths as needed
import '../models/testmodel.dart';
import 'assets/home_form.dart'; // Adjust the import paths as needed
// import 'project_card.dart'; // Ensure your ProjectCard widget is correctly imported

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
        appBar: AppBar(
          title: const Text("Home Page"),
        ),
        floatingActionButtonLocation: ExpandableFab.location,
        floatingActionButton: ExpandableFab(
            distance: 120,
            type: ExpandableFabType.up,
            openButtonBuilder: RotateFloatingActionButtonBuilder(
                fabSize: ExpandableFabSize.large, child: const Icon(Icons.add)),
            closeButtonBuilder: RotateFloatingActionButtonBuilder(
                fabSize: ExpandableFabSize.large,
                child: const Icon(Icons.close)),
            pos: ExpandableFabPos.center,
            children: [
              Column(
                children: [
                  const Text(
                    "New Project",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  FloatingActionButton.large(
                    heroTag: null,
                    child: const Icon(Icons.edit),
                    onPressed: () => (Get.to(const NewProjectView())),
                  ),
                ],
              ),
            ]),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Obx(() {
            if (productController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            } else if (productController.products.isEmpty) {
              return const Center(child: Text('No products found'));
            } else {
              return RefreshIndicator(
                onRefresh: productController.fetchApi,
                child: ReorderableListView.builder(
                  itemCount: productController.products.length,
                  padding: const EdgeInsets.only(bottom: 120),
                  itemBuilder: (context, index) {
                    final product = productController.products[index];
                    return ProjectCard(
                      key: ValueKey(product.id),
                      product: product,
                    );
                  },
                  proxyDecorator:
                      (Widget child, int index, Animation<double> animation) {
                    return Material(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(18),
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Colors.black26,
                          //     blurRadius: 10,
                          //     offset: Offset(0, 5),
                          //   ),
                          // ],
                        ),
                        child: child,
                      ),
                    );
                  },
                  onReorder: (int oldIndex, int newIndex) {
                    if (newIndex > oldIndex) {
                      newIndex -= 1;
                    }
                    final items = productController.products.removeAt(oldIndex);
                    productController.products.insert(newIndex, items);
                    productController.updateReorder();
                  },
                ),
              );
            }
          }),
        ),
      ),
    );
  }
}

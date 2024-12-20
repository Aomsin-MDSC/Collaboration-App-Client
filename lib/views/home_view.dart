import 'package:collaboration_app_client/controllers/authentication_controller.dart';
import 'package:collaboration_app_client/views/new_project_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:get/get.dart';
import '../controllers/project_controller.dart';// Adjust the import paths as needed
import 'assets/home_form.dart'; // Adjust the import paths as needed

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    Get.put(ProjectController());
  }

  @override
  Widget build(BuildContext context) {
    final ProjectController projectController = Get.find<ProjectController>();
    final AuthenticationController authentication_controller =
        Get.put(AuthenticationController());

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          title: const Text("Home Page"),
          actions: [
            IconButton(
                onPressed: () {
                  authentication_controller.logout();
                },
                icon: Icon(
                  Icons.logout,
                  size: 30,
                ))
          ],
        ),
        floatingActionButtonLocation: ExpandableFab.location,
        floatingActionButton: ExpandableFab(
          distance: 120,
          type: ExpandableFabType.up,
          openButtonBuilder: RotateFloatingActionButtonBuilder(
            fabSize: ExpandableFabSize.large,
            child: const Icon(Icons.add),
          ),
          closeButtonBuilder: RotateFloatingActionButtonBuilder(
            fabSize: ExpandableFabSize.large,
            child: const Icon(Icons.close),
          ),
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
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Obx(() {
            if (projectController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            } else if (projectController.project.isEmpty) {
              return const Center(child: Text('No project found'));
            } else {
              return RefreshIndicator(
                onRefresh: () async {
                  final String? token = await projectController.getToken();
                  if (token != null && token.isNotEmpty) {
                    projectController.fetchApi(token);
                  } else {
                    print("Token not found");
                  }
                },
                child: ReorderableListView.builder(
                  itemCount: projectController.project.length,
                  padding: const EdgeInsets.only(bottom: 120),
                  itemBuilder: (context, index) {
                    final product = projectController.project[index];
                    return ProjectCard(
                      key: ValueKey(product.projectId),
                      project: product,
                    );
                  },
                  proxyDecorator:
                      (Widget child, int index, Animation<double> animation) {
                    return Material(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: child,
                      ),
                    );
                  },
                  onReorder: (int oldIndex, int newIndex) {
                    if (newIndex > oldIndex) {
                      newIndex -= 1;
                    }
                    final items = projectController.project.removeAt(oldIndex);
                    projectController.project.insert(newIndex, items);
                    projectController.updateReorder();
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

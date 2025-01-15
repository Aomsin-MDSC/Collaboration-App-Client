import 'package:collaboration_app_client/controllers/authentication_controller.dart';
import 'package:collaboration_app_client/utils/color.dart';
import 'package:collaboration_app_client/views/new_project_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/project_controller.dart';
import '../controllers/tag_controller.dart';
import 'assets/home_form.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

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
    final AuthenticationController authenticationController =
        Get.put(AuthenticationController());

    final refresh = Get.arguments?['refresh'] ?? false;

    if (refresh) {
      Future.delayed(Duration.zero, () async {
        final String? token = await projectController.getToken();
        if (token != null && token.isNotEmpty) {
          projectController.fetchApi(token);
        } else {
          print("Token not found");
        }
      });
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Home Page"),
          actions: [
            IconButton(
              onPressed: () {
                authenticationController.logout();
              },
              icon: const Icon(
                Icons.logout,
                size: 30,
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 20,right: 20),
          child: FloatingActionButton.extended(
            backgroundColor: btcolor,
            onPressed: (){Get.to(NewProjectView());},
            label: Text("New Project",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
            icon: Icon(Icons.edit),
            ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Obx(
            () {
              if (projectController.userId.value == -1) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return Obx(() {
                  if (projectController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (projectController.project.isEmpty) {
                    return const Center(child: Text('No project found'));
                  } else {
                    return RefreshIndicator(
                      onRefresh: () async {
                        final String? token =
                            await projectController.getToken();
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
                          // print( "keyPAOM${ValueKey(product.projectId).value}");
                          // print("currentPAOM${projectController.userId.value}");
                          // print("Project ID: ${product.projectId}, Project User ID: ${product.userId}, Current User ID: $userId");
                          return ProjectCard(
                            key: ValueKey(product.projectId),
                            project: product,
                            currentUserId: projectController.userId.value,
                            // ใช้ userId จาก snapshot
                          );
                        },
                        proxyDecorator: (Widget child, int index,
                            Animation<double> animation) {
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
                          final items =
                              projectController.project.removeAt(oldIndex);
                          projectController.project.insert(newIndex, items);
                          projectController.updateReorder();
                        },
                      ),
                    );
                  }
                });
              }
            },
          ),
        ),
      ),
    );
  }
}

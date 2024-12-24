import 'package:collaboration_app_client/utils/color.dart';
import 'package:collaboration_app_client/views/Login_View.dart';
import 'package:collaboration_app_client/views/home_view.dart';
import 'package:collaboration_app_client/views/new_announce_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final bool hasToken = await checkToken();
  runApp(MyApp(hasToken: hasToken));
}

Future<bool> checkToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('jwt_token');
  return token != null && token.isNotEmpty;
}

class MyApp extends StatelessWidget {
  final bool hasToken;
  const MyApp({super.key, required this.hasToken});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white),
          centerTitle: true,
          backgroundColor: topiccolor,
          elevation: 0,
          iconTheme: IconThemeData(color: iconAppColor),
        ),
        scaffoldBackgroundColor: bgcolor,
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.black, primary: Colors.black),
        useMaterial3: true,
      ),
      home: hasToken ? const HomeView() : const LoginView(),
    );
  }
}

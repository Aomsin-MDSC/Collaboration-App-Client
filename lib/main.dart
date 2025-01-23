import 'dart:convert';

import 'package:collaboration_app_client/utils/app_lifecycle_observer.dart';
import 'package:collaboration_app_client/utils/color.dart';
import 'package:collaboration_app_client/views/Login_View.dart';
import 'package:collaboration_app_client/views/home_view.dart';
import 'package:collaboration_app_client/views/new_announce_view.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'controllers/tag_controller.dart';
import 'firebase_options.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  Get.put(TagController());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await setupFirebaseMessaging();


  FirebaseMessaging.instance.requestPermission(provisional: true);
  FirebaseMessaging.instance.getToken().then((value){
    print(value);
  });
  
  final bool hasToken = await checkToken();
  runApp(MyApp(hasToken: hasToken));
}

Future<void> setupFirebaseMessaging() async {
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
    provisional: true,
  );

  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
  InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("Received message in foreground: ${message.notification?.title}");
    showLocalNotification(message);
  });
}

Future<void> showLocalNotification(RemoteMessage message) async {
  const AndroidNotificationDetails androidNotificationDetails =
  AndroidNotificationDetails(
    'default_channel_id',
    'Default Channel',
    channelDescription: 'This is the default notification channel',
    importance: Importance.high,
    priority: Priority.high,
  );
  const NotificationDetails notificationDetails =
  NotificationDetails(android: androidNotificationDetails);

  await flutterLocalNotificationsPlugin.show(
    message.hashCode,
    message.notification?.title,
    message.notification?.body,
    notificationDetails,
  );
}

Future<int?> getUserId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt('user_id');
}

Future<void> saveTokenToDatabase(String token) async {
  final userId = await getUserId();
  print("Device : $userId");
  try {
    final url = Uri.parse('http://10.24.8.16:5263/api/TokenDevice/$userId');

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_token': token,
      }),
    );

    if (response.statusCode == 200) {
      print('Device Token updated successfully!');
    } else {
      print('Failed to update token: ${response.body}');
    }
  } catch (e) {
    throw('Error updating token: $e');
  }
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
          titleTextStyle: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white),
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
      home:  AppLifecycleObserver(
        child: hasToken ? const HomeView() : const LoginView(),
      ),
    );
  }
}



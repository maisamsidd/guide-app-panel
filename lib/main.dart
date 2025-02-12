import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guide_app_panel/Views/Main_page_home.dart';
import 'package:guide_app_panel/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

late Size mq;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      home: MainPageHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

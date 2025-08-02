import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guide_app_panel/Views/home_page.dart' show MainPageHome;
import 'package:supabase_flutter/supabase_flutter.dart';

late Size mq;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
      url: "https://bbedlmbkkqakkfbvsomv.supabase.co",
      anonKey:
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJiZWRsbWJra3Fha2tmYnZzb212Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDE3MDQ5NDgsImV4cCI6MjA1NzI4MDk0OH0.p_brR5272ckj3oZbemupMEYnSFnX1rxL6QO5lKqRZIE");
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

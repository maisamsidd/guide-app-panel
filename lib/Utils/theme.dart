import 'package:flutter/material.dart';

class MyColors {
  static Color whiteColor = Colors.white;
  static Color BlackColor = Colors.black;
  static Color greyColor = const Color.fromARGB(255, 235, 227, 227);
  static Color orangeColor = Colors.orange;
  static Color lightOrangeColor = const Color.fromARGB(255, 255, 226, 183);
  static Color blueColor = const Color.fromARGB(255, 36, 117, 240);
}

class MyStyles {
  static TextStyle orangeText = const TextStyle(color: Colors.orange);
  static ButtonStyle appBarButtonStyle = ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.orange,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            );
}
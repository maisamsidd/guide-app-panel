import 'package:flutter/material.dart';

class LsTextField extends StatelessWidget {
  final hintText;
  final labelText;
  final bool secureText;
  final TextEditingController controller;
  const LsTextField(
      {super.key,
      this.hintText,
      this.labelText,
      required this.controller,
      required this.secureText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: TextFormField(
        controller: controller,
        obscureText: secureText,
        decoration: InputDecoration(
            hintText: hintText,
            labelText: labelText,
            border: const OutlineInputBorder(),
            focusColor: Colors.black),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ProfileBuildTextfield extends StatelessWidget {
  final hintText;
  final labelText;
  const ProfileBuildTextfield({super.key, this.hintText, this.labelText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 30),
      child: TextFormField(
        decoration: InputDecoration(
            hintText: hintText,
            labelText: labelText,
            border: const OutlineInputBorder(),
            focusColor: Colors.black),
      ),
    );
  }
}

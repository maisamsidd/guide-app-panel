import 'package:flutter/material.dart';

class UsersInfo extends StatelessWidget {
  const UsersInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User's Info"),
      ),
      body: ListView.builder(
          itemCount: 15,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                color: const Color.fromARGB(255, 236, 221, 221),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Maisam Hussain"),
                    Text("xyz"),
                    Text("02-11-2024"),
                    Text("Japan"),
                    Text("More Details"),
                  ],
                ),
              ),
            );
          }),
    );
  }
}

import 'package:flutter/material.dart';

class HomepageTop extends StatelessWidget {
  const HomepageTop({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Make the TextField responsive
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 20,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10), // Add spacing between elements
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.shopping_cart),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.access_alarm),
        ),
      ],
    );
  }
}

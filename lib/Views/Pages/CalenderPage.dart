import 'package:flutter/material.dart';
import 'package:guide_app_panel/utils/app_colors.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.orangeColor,
        title: Text(
          "Calendar",
          style: TextStyle(color: MyColors.whiteColor),
        ),
      ),
      body: Row(
        children: [
          // Sidebar for Filters
          Container(
            width: 250,
            padding: const EdgeInsets.all(16),
            color: Colors.grey[200],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // const Text(
                //   "Filters",
                //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                // ),
                // const SizedBox(height: 16),
                // DropdownButtonFormField<String>(
                //   decoration: const InputDecoration(
                //     labelText: "Product",
                //     border: OutlineInputBorder(),
                //   ),
                //   items: const [
                //     DropdownMenuItem(
                //         value: "All products", child: Text("All products")),
                //     DropdownMenuItem(
                //         value: "Option 1", child: Text("Option 1")),
                //   ],
                //   onChanged: (value) {},
                // ),
                // const SizedBox(height: 16),
                // DropdownButtonFormField<String>(
                //   decoration: const InputDecoration(
                //     labelText: "Options",
                //     border: OutlineInputBorder(),
                //   ),
                //   items: const [
                //     DropdownMenuItem(
                //         value: "Option 1", child: Text("Option 1")),
                //     DropdownMenuItem(
                //         value: "Option 2", child: Text("Option 2")),
                //   ],
                //   onChanged: (value) {},
                // ),
                // const SizedBox(height: 24),
                // const Text(
                //   "Other Links",
                //   style: TextStyle(fontWeight: FontWeight.bold),
                // ),
                // const SizedBox(height: 8),
                TextButton(
                  onPressed: () {},
                  child: const Text("Agenda view"),
                ),
              ],
            ),
          ),
          // Calendar Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with navigation
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Week 52 (December 2024)",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: const Text("Today"),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.arrow_back),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.arrow_forward),
                          ),
                          const SizedBox(width: 16),
                          ToggleButtons(
                            isSelected: const [true, false],
                            onPressed: (index) {
                              // Handle view toggle
                            },
                            children: const [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Text("Week"),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Text("Month"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Calendar grid
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7, // Days of the week
                      childAspectRatio: 1.5,
                    ),
                    itemCount: 7,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                [
                                  "Mon",
                                  "Tue",
                                  "Wed",
                                  "Thu",
                                  "Fri",
                                  "Sat",
                                  "Sun"
                                ][index],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const Expanded(
                              child: Center(
                                child: Text("No Events"),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

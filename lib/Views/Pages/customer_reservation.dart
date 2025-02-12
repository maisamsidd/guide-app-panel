import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guide_app_panel/Views/SubPages/customer_reservation_more.dart';
import 'package:guide_app_panel/utils/app_colors.dart';

class CustomerReservation extends StatelessWidget {
  const CustomerReservation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.orangeColor,
        title: const Text(
          "Customer's Reservations",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Material(
              elevation: 4,
              shadowColor: Colors.black26,
              borderRadius: BorderRadius.circular(50),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Search...",
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: Icon(
                    Icons.search,
                    color: MyColors.orangeColor,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),

          // Customer list
          Expanded(
            child: ListView.builder(
              itemCount: 15,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      Get.to(() => const ReservationMore());
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Leading icon
                          CircleAvatar(
                            radius: 30,
                            backgroundColor:
                                MyColors.orangeColor.withOpacity(0.2),
                            child: Icon(
                              Icons.person_2_rounded,
                              size: 30,
                              color: MyColors.orangeColor,
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Customer details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Maisam Siddiqui",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "maisam@example.com",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "123456789",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Trailing icon
                          Icon(
                            Icons.chevron_right,
                            color: MyColors.orangeColor,
                            size: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

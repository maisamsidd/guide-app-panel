import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guide_app_panel/Views/Pages/CalenderPage.dart';
import 'package:guide_app_panel/Views/Pages/Caregory.dart';
import 'package:guide_app_panel/Views/SubPages/CustomerServiceMore.dart';
import 'package:guide_app_panel/Views/SubPages/customer_reservation_more.dart';
import 'package:guide_app_panel/Views/Pages/customer_reservation.dart';
import 'package:guide_app_panel/Views/Pages/customer_support.dart';
import 'package:guide_app_panel/Views/Pages/Experiences_and_slider.dart';
import 'package:guide_app_panel/utils/app_colors.dart';

class MainPageHome extends StatelessWidget {
  const MainPageHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("Main Page",
            style: TextStyle(color: Colors.white, fontSize: 24)),
        actions: [
          TextButton(
              onPressed: () {
                Get.to(() => const CalendarPage());
              },
              child: Text(
                "Calender",
                style: TextStyle(fontSize: 18, color: MyColors.whiteColor),
              )),
          TextButton(
              onPressed: () {
                Get.to(() => const CategoryAdd());
              },
              child: Text(
                "Category",
                style: TextStyle(fontSize: 18, color: MyColors.whiteColor),
              )),
          TextButton(
              onPressed: () {
                Get.to(() => const ExperiencesAndSlider());
              },
              child: Text(
                "Experiences and slider",
                style: TextStyle(fontSize: 18, color: MyColors.whiteColor),
              )),
          TextButton(
              onPressed: () {
                Get.to(() => const CustomerReservation());
              },
              child: Text("Customer Reservation",
                  style: TextStyle(fontSize: 18, color: MyColors.whiteColor))),
          TextButton(
              onPressed: () {
                Get.to(() => const CustomerSupport());
              },
              child: Text("Customer Support",
                  style: TextStyle(fontSize: 18, color: MyColors.whiteColor))),
        ],
      ),
      body: Column(
        children: [
          // First List
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: 2,
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
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                // View More button for the first list
                ElevatedButton(
                  onPressed: () {
                    Get.to(() => const ReservationMore());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.orangeColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text(
                    "View More",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          // Second List
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: MyColors.orangeColor.withOpacity(0.5),
                              ),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor: MyColors.orangeColor,
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Maisam Hussain",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "Message preview or short description...",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.to(() => const Customerservicemore());
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: MyColors.orangeColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      "View",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // View More button for the second list
                ElevatedButton(
                  onPressed: () {
                    Get.to(() => const Customerservicemore());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.orangeColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text(
                    "View More",
                    style: TextStyle(color: Colors.white),
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

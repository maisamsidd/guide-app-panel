import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guide_app_panel/Models/slider_model.dart';
import 'package:guide_app_panel/Utils/theme.dart' show MyColors;
import 'package:guide_app_panel/Views/calendar_page.dart';
import 'package:guide_app_panel/Views/categories_page.dart';
import 'package:guide_app_panel/Views/customer_bookings.dart';
import 'package:guide_app_panel/Views/customer_reservation_page.dart'
    show CustomerReservationPage;
import 'package:guide_app_panel/Views/customer_support_page.dart'
    show CustomerSupportPage;
import 'package:guide_app_panel/Views/experiences_page.dart'
    show ExperiencesPage;
import 'package:guide_app_panel/Views/slider_page.dart';

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
                Get.to(() => const CategoriesPage());
              },
              child: Text(
                "Category",
                style: TextStyle(fontSize: 18, color: MyColors.whiteColor),
              )),
          TextButton(
              onPressed: () {
                Get.to(() => SliderPage());
              },
              child: Text(
                "Sliders",
                style: TextStyle(fontSize: 18, color: MyColors.whiteColor),
              )),
          TextButton(
              onPressed: () {
                Get.to(() => const ExperiencesPage());
              },
              child: Text(
                "Experiences",
                style: TextStyle(fontSize: 18, color: MyColors.whiteColor),
              )),
          TextButton(
              onPressed: () {
                Get.to(() => const CustomerReservationPage());
              },
              child: Text("Customer Reservation",
                  style: TextStyle(fontSize: 18, color: MyColors.whiteColor))),
          TextButton(
              onPressed: () {
                Get.to(() => const CustomerSupportPage());
              },
              child: Text("Customer Support",
                  style: TextStyle(fontSize: 18, color: MyColors.whiteColor))),
          TextButton(
              onPressed: () {
                Get.to(() => const AllBookingsPage());
              },
              child: Text("Bookings",
                  style: TextStyle(fontSize: 18, color: MyColors.whiteColor))),
        ],
      ),
      body: const Center(
          child: Text('Main Page', style: TextStyle(fontSize: 24))),
    );
  }
}

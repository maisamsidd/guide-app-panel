import 'package:flutter/material.dart';

class CustomerReservationPage extends StatefulWidget {
  const CustomerReservationPage({super.key});

  @override
  _CustomerReservationPageState createState() =>
      _CustomerReservationPageState();
}

class _CustomerReservationPageState extends State<CustomerReservationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Reservation'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
          child: Text('Customer Reservation Page',
              style: TextStyle(fontSize: 24))),
    );
  }
}

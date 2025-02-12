import 'package:flutter/material.dart';
import 'package:guide_app_panel/utils/app_colors.dart';

class ReservationMore extends StatelessWidget {
  const ReservationMore({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Maisam's Reservation",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: MyColors.orangeColor,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextFieldWithIcon(
                    context,
                    "First Name: Maisam",
                    "Update First Name",
                    Icons.person,
                  ),
                  _buildTextFieldWithIcon(
                    context,
                    "Last Name: Siddiqui",
                    "Update Last Name",
                    Icons.person_outline,
                  ),
                  _buildTextFieldWithIcon(
                    context,
                    "Experience: 3",
                    "Update experience Details",
                    Icons.image,
                  ),
                  _buildTextFieldWithIcon(
                    context,
                    "Date of Purchase: 02-11-2024",
                    "Update Purchase Date",
                    Icons.calendar_today,
                  ),
                  _buildTextFieldWithIcon(
                    context,
                    "Email: maisam@example.com",
                    "Update Email",
                    Icons.email,
                  ),
                  _buildTextFieldWithIcon(
                    context,
                    "Contact Number: 123456789",
                    "Update Contact Number",
                    Icons.phone,
                  ),
                  _buildTextFieldWithIcon(
                    context,
                    "Reservation Number: 982732923",
                    "Update Reservation Number",
                    Icons.confirmation_number,
                  ),
                  _buildTextFieldWithIcon(
                    context,
                    "Total number of infants: 2",
                    "Update infat Details",
                    Icons.child_care,
                  ),
                  _buildTextFieldWithIcon(
                    context,
                    "Total number of adults: 3",
                    "Update adults Details",
                    Icons.people,
                  ),
                  _buildTextFieldWithIcon(
                    context,
                    "Date/Time of activity: 2-06-2024 3:00",
                    "Update experience Details",
                    Icons.date_range,
                  ),
                  _buildTextFieldWithIcon(
                    context,
                    "Special request: 1 wheel chair",
                    "Update experience Details",
                    Icons.request_page,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildTextFieldWithIcon(
      BuildContext context, String text, String dialogTitle, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: GestureDetector(
        onTap: () => _showUpdateDialog(context, dialogTitle),
        child: Row(
          children: [
            Icon(icon, color: MyColors.orangeColor, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showUpdateDialog(BuildContext context, String title) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: TextFormField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: "Enter new value",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.red),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: MyColors.orangeColor),
              onPressed: () {
                // Handle the update logic here
                Navigator.of(context).pop();
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }
}

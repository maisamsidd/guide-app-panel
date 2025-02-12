import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guide_app_panel/main.dart';
import 'package:guide_app_panel/utils/app_colors.dart';
import 'package:guide_app_panel/widgets/Buttons/ls_button.dart';

class CategoryAdd extends StatelessWidget {
  const CategoryAdd({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController cat1 = TextEditingController();
    TextEditingController cat2 = TextEditingController();
    TextEditingController cat3 = TextEditingController();
    final fireStore = FirebaseFirestore.instance;
    mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.orangeColor,
        title: const Text("Categories"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "First Category",
                style: TextStyle(fontSize: 24),
              ),
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                    border: Border.all(color: MyColors.BlackColor),
                    borderRadius: BorderRadius.circular(15)),
                child: const Center(
                  child: Icon(Icons.camera),
                ),
              ),
              _buildTextField("Category name 1", "Mueseum", Icons.star, cat1),
              const Text(
                "Second Category",
                style: TextStyle(fontSize: 24),
              ),
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                    border: Border.all(color: MyColors.BlackColor),
                    borderRadius: BorderRadius.circular(15)),
                child: const Center(
                  child: Icon(Icons.camera),
                ),
              ),
              _buildTextField(
                  "Category name 2", "Entry ticket", Icons.star, cat2),
              const Text(
                "Thrid Category",
                style: TextStyle(fontSize: 24),
              ),
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                    border: Border.all(color: MyColors.BlackColor),
                    borderRadius: BorderRadius.circular(15)),
                child: const Center(
                  child: Icon(Icons.camera),
                ),
              ),
              _buildTextField("Category name 3", "Tour", Icons.star, cat3),
              Center(
                child: LsButton(
                  ontap: () {
                    try {
                      fireStore.collection("Category").add({
                        "cat1": cat1.text,
                        "cat2": cat2.text,
                        "cat3": cat3.text,
                      });
                      Get.snackbar("Success", "Item added successfully");
                    } catch (e) {
                      Get.snackbar("Error", "Error occured ${e}");
                    }
                  },
                  text: "Upload",
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, IconData icon,
      TextEditingController textController) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: textController,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: MyColors.orangeColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: MyColors.orangeColor, width: 2),
          ),
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }
}

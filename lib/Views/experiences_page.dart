import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:guide_app_panel/Models/category_model.dart';
import 'package:guide_app_panel/Models/experience_model.dart';
import 'package:guide_app_panel/Utils/theme.dart' show MyColors, MyStyles;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';

class ExperiencesPage extends StatefulWidget {
  const ExperiencesPage({super.key});

  @override
  _ExperiencesPageState createState() => _ExperiencesPageState();
}

class _ExperiencesPageState extends State<ExperiencesPage> {
  final SupabaseQueryBuilder experienceDB =
      Supabase.instance.client.from('Experiences');
  final StorageFileApi experienceImagesDB =
      Supabase.instance.client.storage.from('experience_images');
  List<Experience> experiences = [];
  Uint8List? pickedImageBytes;
  String? pickedImageName;

  final SupabaseQueryBuilder categoryDB =
      Supabase.instance.client.from('categories');
  final StorageFileApi categoryImagesDB =
      Supabase.instance.client.storage.from('category-images');
  List<Category> categories = [];
  bool isLoadingCategories = false;

  @override
  void initState() {
    super.initState();
    loadExperiences();
    _loadCategories();
  }

  Future<void> loadExperiences() async {
    try {
      final response = await experienceDB.select();
      experiences = response.map((data) => Experience.fromMap(data)).toList();
      setState(() {});
    } catch (e) {
      print('Error fetching experiences: $e');
    }
  }

  Future<void> _loadCategories() async {
    setState(() {
      isLoadingCategories = true;
    });
    try {
      final response = await categoryDB.select();
      categories = response.map((data) => Category.fromMap(data)).toList();
      setState(() {});
    } catch (e) {
      print('Error fetching categories: $e');
    } finally {
      setState(() {
        isLoadingCategories = false;
      });
    }
  }

  Future<void> addExperience({
    required String place,
    required String activity,
    required String description,
    required double adultPrice,
    required double kidsPrice,
    required double infantPrice,
  }) async {
    var id = DateTime.now().millisecondsSinceEpoch;
    final String fileName = '$id.jpg';

    try {
      await experienceImagesDB.uploadBinary(fileName, pickedImageBytes!);
      final experience = {
        'id': id,
        'place': place,
        'activity': activity,
        'description': description,
        'image_name': fileName,
        'adult_price': adultPrice,
        'kids_price': kidsPrice,
        'infant_price': infantPrice
      };

      await experienceDB.insert(experience);

      experiences.add(Experience(
          id: id,
          place: place,
          activity: activity,
          description: description,
          imageName: fileName,
          sliderImageName: "",
          adultPrice: adultPrice,
          kidsPrice: kidsPrice,
          infantPrice: infantPrice));

      pickedImageName = "";
      pickedImageBytes = null;
      print("Experience added successfully!");
    } catch (e) {
      print("Error adding experience: $e");
    }
  }

  Future<void> editExperience(
      {required int index,
      required String place,
      required String activity,
      required String description,
      required double adultPrice,
      required double kidsPrice,
      required double infantPrice}) async {
    var id = experiences[index].id;
    final String fileName = '$id.jpg';

    try {
      await experienceImagesDB.remove([fileName]);
      await experienceImagesDB.uploadBinary(fileName, pickedImageBytes!);
      final experience = {
        'id': id,
        'place': place,
        'activity': activity,
        'description': description,
        'image_name': fileName,
        'adult_price': adultPrice,
        'kids_price': kidsPrice,
        'infant_price': infantPrice
      };

      await experienceDB.update(experience).eq('id', id);

      experiences[index] = Experience(
          id: id,
          place: place,
          activity: activity,
          description: description,
          imageName: fileName,
          sliderImageName: experiences[index].sliderImageName,
          adultPrice: adultPrice,
          kidsPrice: kidsPrice,
          infantPrice: infantPrice);
      print("Experience updated successfully!");
    } catch (e) {
      print("Error adding experience: $e");
    }
  }

  Future<void> _showExperienceDialog({int? index}) async {
    TextEditingController placeController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController kidsPriceController = TextEditingController();
    TextEditingController infantPriceController = TextEditingController();
    TextEditingController adultPriceController = TextEditingController();
    String? selectedCategory;

    if (index != null) {
      placeController.text = experiences[index].place;
      selectedCategory = experiences[index].activity;
      descriptionController.text = experiences[index].description;
      kidsPriceController.text = experiences[index].kidsPrice.toString();
      infantPriceController.text = experiences[index].infantPrice.toString();
      adultPriceController.text = experiences[index].adultPrice.toString();
      var imageUrl =
          experienceImagesDB.getPublicUrl(experiences[index].imageName);
      final response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode == 200) {
        pickedImageBytes = response.bodyBytes;
      } else {
        pickedImageBytes = null;
      }
    }

    Future<void> pickImage() async {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );
      if (result != null) {
        setState(() {
          pickedImageBytes = result.files.first.bytes;
          pickedImageName = result.files.first.name;
        });
      }
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(index == null ? "Add Experience" : "Edit Experience"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: placeController,
                decoration: const InputDecoration(labelText: 'Experience'),
              ),
              const SizedBox(height: 8),
              isLoadingCategories
                  ? const Center(child: CircularProgressIndicator())
                  : categories.isEmpty
                      ? const Text("No categories available")
                      : DropdownButtonFormField<String>(
                          value: selectedCategory,
                          decoration:
                              const InputDecoration(labelText: 'Category'),
                          items: categories.map((Category category) {
                            return DropdownMenuItem<String>(
                              value: category.name,
                              child: Text(category.name),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            selectedCategory = newValue;
                          },
                          hint: const Text('Select a category'),
                        ),
              const SizedBox(height: 8),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    Get.snackbar("Error", "Please enter a description");
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: kidsPriceController,
                decoration: const InputDecoration(labelText: 'Kids Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    Get.snackbar("Error", "Please enter a price");
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: infantPriceController,
                decoration: const InputDecoration(labelText: 'Infant Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    Get.snackbar("Error", "Please enter a price");
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: adultPriceController,
                decoration: const InputDecoration(labelText: 'Adult Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    Get.snackbar("Error", "Please enter a price");
                  }
                  return null;
                },
              ),
              pickedImageBytes == null
                  ? const Text("No Image Selected")
                  : Image.memory(pickedImageBytes!, height: 100, width: 100),
              TextButton.icon(
                onPressed: pickImage,
                icon: Icon(Icons.image, color: MyColors.orangeColor),
                label: Text("Pick Image", style: MyStyles.orangeText),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                pickedImageBytes = null;
                pickedImageName = "";
              });
              Navigator.pop(ctx);
            },
            child: Text("Cancel", style: MyStyles.orangeText),
          ),
          ElevatedButton(
            onPressed: () async {
              if (placeController.text.isNotEmpty &&
                  selectedCategory != null &&
                  descriptionController.text.isNotEmpty &&
                  pickedImageBytes != null) {
                var place = placeController.text;
                var activity = selectedCategory!;
                var description = descriptionController.text;
                var kidsPrice =
                    double.tryParse(kidsPriceController.text) ?? 0.0;
                var infantPrice =
                    double.tryParse(infantPriceController.text) ?? 0.0;
                var adultPrice =
                    double.tryParse(adultPriceController.text) ?? 0.0;
                if (index == null) {
                  await addExperience(
                      place: place,
                      activity: activity,
                      description: description,
                      kidsPrice: kidsPrice,
                      infantPrice: infantPrice,
                      adultPrice: adultPrice);
                } else {
                  await editExperience(
                      index: index,
                      place: place,
                      activity: activity,
                      description: description,
                      kidsPrice: kidsPrice,
                      infantPrice: infantPrice,
                      adultPrice: adultPrice);
                }
                setState(() {});
                Navigator.pop(ctx);
              }
            },
            child: Text(index == null ? "Add" : "Update",
                style: MyStyles.orangeText),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteExperience(int index) async {
    try {
      await experienceImagesDB.remove([experiences[index].imageName]);
      await experienceDB.delete().eq('id', experiences[index].id);

      setState(() {
        experiences.removeAt(index);
      });
    } catch (e) {
      print("Error deleting experience: $e");
    }
  }

  Future<void> addSliderImage(Uint8List sliderImage, int index) async {
    try {
      String fileName =
          "${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
      await experienceImagesDB.uploadBinary(fileName, sliderImage);

      var id = experiences[index].id;
      await experienceDB.update({'slider_image_name': fileName}).eq('id', id);
      print("Slider image added successfully!");
    } catch (e) {
      print("Error adding slider image: $e");
    }
  }

  // Future<void> _addToSlider(int index) async {
  //   String place = experiences[index].place;
  //   String activity = experiences[index].activity;
  //   String description = experiences[index].description;
  //   String kidsPrice = experiences[index].kidsPrice.toString();
  //   String infantPrice = experiences[index].infantPrice.toString();
  //   String adultPrice = experiences[index].adultPrice.toString();
  //   Uint8List? sliderImage;

  //   Future<void> pickSliderImage() async {
  //     FilePickerResult? result = await FilePicker.platform.pickFiles(
  //       type: FileType.image,
  //     );
  //     if (result != null) {
  //       setState(() {
  //         sliderImage = result.files.first.bytes;
  //       });
  //     }
  //   }

  //   showDialog(
  //     context: context,
  //     builder: (ctx) => AlertDialog(
  //       title: const Text("Add to Slider"),
  //       content: SingleChildScrollView(
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text("Place: $place"),
  //             const SizedBox(height: 8),
  //             Text("Activity: $activity"),
  //             const SizedBox(height: 8),
  //             Text("Description: $description"),
  //             const SizedBox(height: 8),
  //             Text("Kids Price: $kidsPrice"),
  //             const SizedBox(height: 10),
  //             Text("Infant Price: $infantPrice"),
  //             const SizedBox(height: 10),
  //             Text("Adult Price: $adultPrice"),
  //             const SizedBox(height: 10),
  //             sliderImage == null
  //                 ? const Center(child: Text("No Image Selected"))
  //                 : Center(
  //                     child:
  //                         Image.memory(sliderImage!, height: 100, width: 100)),
  //             Center(
  //               child: TextButton.icon(
  //                 onPressed: pickSliderImage,
  //                 icon: Icon(Icons.image, color: MyColors.orangeColor),
  //                 label: Text("Pick Image", style: MyStyles.orangeText),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(ctx),
  //           child: Text("Cancel", style: MyStyles.orangeText),
  //         ),
  //         ElevatedButton(
  //           onPressed: () {
  //             if (sliderImage != null) {
  //               addSliderImage(sliderImage!, index);
  //             }
  //             setState(() {});
  //             Navigator.pop(ctx);
  //           },
  //           child: Text("Add to Slider", style: MyStyles.orangeText),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.orangeColor,
        foregroundColor: Colors.white,
        title: const Text('Experiences'),
        actions: [
          ElevatedButton.icon(
              onPressed: () => _showExperienceDialog(),
              icon: Icon(Icons.add, color: MyColors.orangeColor),
              label: const Text("Add Experience"),
              style: MyStyles.appBarButtonStyle),
          const SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: experiences.isEmpty
            ? const Center(child: Text("No experiences added"))
            : ListView.builder(
                itemCount: experiences.length,
                itemBuilder: (ctx, index) => Card(
                  color: MyColors.lightOrangeColor,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            experienceImagesDB
                                .getPublicUrl(experiences[index].imageName),
                            width: 160,
                            height: 120,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                experiences[index].place,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                experiences[index].activity,
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                experiences[index].description,
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.grey),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                "\$${experiences[index].kidsPrice}",
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green),
                              ),
                              Text(
                                "\$${experiences[index].infantPrice}",
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green),
                              ),
                              Text(
                                "\$${experiences[index].adultPrice}",
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green),
                              ),
                            ],
                          ),
                        ),
                        // IconButton(
                        //   icon: const Icon(Icons.add, color: Colors.blue),
                        //   onPressed: () => _addToSlider(index),
                        // ),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showExperienceDialog(index: index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteExperience(index),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

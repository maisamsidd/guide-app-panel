import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
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
  List<Uint8List> pickedImageBytesList = [];
  List<String> pickedImageNames = [];

  final SupabaseQueryBuilder categoryDB =
      Supabase.instance.client.from('categories');
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
      setState(() {
        experiences = Experience.fromList(response);
      });
    } catch (e) {
      print('Error fetching experiences: $e');
      Get.snackbar('Error', 'Failed to load experiences');
    }
  }

  Future<void> _loadCategories() async {
    setState(() {
      isLoadingCategories = true;
    });
    try {
      final response = await categoryDB.select();
      setState(() {
        categories = response.map((data) => Category.fromMap(data)).toList();
      });
    } catch (e) {
      print('Error fetching categories: $e');
      Get.snackbar('Error', 'Failed to load categories');
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

    try {
      List<String> uploadedFileNames = [];
      for (int i = 0; i < pickedImageBytesList.length; i++) {
        final String fileName = '${id}_$i.jpg';
        await experienceImagesDB.uploadBinary(
            fileName, pickedImageBytesList[i]);
        uploadedFileNames.add(fileName);
      }

      final experience = Experience(
        id: id,
        place: place,
        activity: activity,
        description: description,
        imageName: uploadedFileNames,
        sliderImageName: '',
        adultPrice: adultPrice,
        kidsPrice: kidsPrice,
        infantPrice: infantPrice,
      );

      await experienceDB.insert(experience.toMap());

      setState(() {
        experiences.add(experience);
        pickedImageBytesList = [];
        pickedImageNames = [];
      });
      Get.snackbar('Success', 'Experience added successfully');
    } catch (e) {
      print('Error adding experience: $e');
      Get.snackbar('Error', 'Failed to add experience: $e');
    }
  }

  Future<void> editExperience({
    required int index,
    required String place,
    required String activity,
    required String description,
    required double adultPrice,
    required double kidsPrice,
    required double infantPrice,
  }) async {
    var id = experiences[index].id;

    try {
      List<String> uploadedFileNames =
          List.from(experiences[index].imageName); // Preserve existing images
      if (pickedImageBytesList.isNotEmpty) {
        // Remove old images only if new ones are selected
        if (uploadedFileNames.isNotEmpty) {
          await experienceImagesDB.remove(uploadedFileNames);
        }
        // Upload new images
        uploadedFileNames = [];
        for (int i = 0; i < pickedImageBytesList.length; i++) {
          final String fileName = '${id}_$i.jpg';
          await experienceImagesDB.uploadBinary(
              fileName, pickedImageBytesList[i]);
          uploadedFileNames.add(fileName);
        }
      }

      final updatedExperience = experiences[index].copyWith(
        place: place,
        activity: activity,
        description: description,
        imageName: uploadedFileNames,
        adultPrice: adultPrice,
        kidsPrice: kidsPrice,
        infantPrice: infantPrice,
      );

      await experienceDB.update(updatedExperience.toMap()).eq('id', id);

      setState(() {
        experiences[index] = updatedExperience;
        pickedImageBytesList = [];
        pickedImageNames = [];
      });
      Get.snackbar('Success', 'Experience updated successfully');
    } catch (e) {
      print('Error editing experience: $e');
      Get.snackbar('Error', 'Failed to update experience: $e');
    }
  }

  Future<void> _deleteExperience(int index) async {
    try {
      // Delete all images associated with the experience
      if (experiences[index].imageName.isNotEmpty) {
        await experienceImagesDB.remove(experiences[index].imageName);
      }
      await experienceDB.delete().eq('id', experiences[index].id);

      setState(() {
        experiences.removeAt(index);
      });
      Get.snackbar('Success', 'Experience deleted successfully');
    } catch (e) {
      print('Error deleting experience: $e');
      Get.snackbar('Error', 'Failed to delete experience: $e');
    }
  }

  Future<void> _showExperienceDialog({int? index}) async {
    TextEditingController placeController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController kidsPriceController = TextEditingController();
    TextEditingController infantPriceController = TextEditingController();
    TextEditingController adultPriceController = TextEditingController();
    String? selectedCategory;

    // Initialize with existing data if editing
    List<Uint8List> tempImageBytesList = [];
    List<String> tempImageNames = [];
    if (index != null) {
      placeController.text = experiences[index].place;
      selectedCategory = experiences[index].activity;
      descriptionController.text = experiences[index].description;
      kidsPriceController.text =
          experiences[index].kidsPrice?.toString() ?? '0.0';
      infantPriceController.text =
          experiences[index].infantPrice?.toString() ?? '0.0';
      adultPriceController.text =
          experiences[index].adultPrice?.toString() ?? '0.0';

      // Fetch existing images
      for (String imageName in experiences[index].imageName) {
        try {
          final response = await http
              .get(Uri.parse(experienceImagesDB.getPublicUrl(imageName)));
          if (response.statusCode == 200) {
            tempImageBytesList.add(response.bodyBytes);
            tempImageNames.add(imageName);
          } else {
            print('Failed to fetch image $imageName: ${response.statusCode}');
          }
        } catch (e) {
          print('Error fetching image $imageName: $e');
        }
      }
    }

    // Initialize picked images with existing ones
    setState(() {
      pickedImageBytesList = List.from(tempImageBytesList);
      pickedImageNames = List.from(tempImageNames);
    });

    Future<void> pickImages() async {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.image,
      );
      if (result != null) {
        setState(() {
          // Append new images instead of overwriting
          pickedImageBytesList
              .addAll(result.files.map((f) => f.bytes!).toList());
          pickedImageNames.addAll(result.files.map((f) => f.name).toList());
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
                    return 'Please enter a description';
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
                    return 'Please enter a price';
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
                    return 'Please enter a price';
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
                    return 'Please enter a price';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              pickedImageBytesList.isEmpty
                  ? const Text("No Images Selected")
                  : SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: pickedImageBytesList.length,
                        itemBuilder: (ctx, i) => Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Stack(
                            children: [
                              Image.memory(
                                pickedImageBytesList[i],
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: IconButton(
                                  icon: const Icon(Icons.remove_circle,
                                      color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      pickedImageBytesList.removeAt(i);
                                      pickedImageNames.removeAt(i);
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
              ElevatedButton(
                onPressed: pickImages,
                child: const Text("Add Images"),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                pickedImageBytesList = [];
                pickedImageNames = [];
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
                  (index != null || pickedImageBytesList.isNotEmpty)) {
                final place = placeController.text;
                final activity = selectedCategory!;
                final description = descriptionController.text;
                final kidsPrice =
                    double.tryParse(kidsPriceController.text) ?? 0.0;
                final infantPrice =
                    double.tryParse(infantPriceController.text) ?? 0.0;
                final adultPrice =
                    double.tryParse(adultPriceController.text) ?? 0.0;

                if (index == null) {
                  await addExperience(
                    place: place,
                    activity: activity,
                    description: description,
                    adultPrice: adultPrice,
                    kidsPrice: kidsPrice,
                    infantPrice: infantPrice,
                  );
                } else {
                  await editExperience(
                    index: index,
                    place: place,
                    activity: activity,
                    description: description,
                    adultPrice: adultPrice,
                    kidsPrice: kidsPrice,
                    infantPrice: infantPrice,
                  );
                }
                await loadExperiences(); // Refresh the list
                Navigator.pop(ctx);
              } else {
                Get.snackbar('Error',
                    'Please fill all fields${index == null ? ' and select at least one image' : ''}');
              }
            },
            child: Text(index == null ? "Add" : "Update",
                style: MyStyles.orangeText),
          ),
        ],
      ),
    );
  }

  Future<void> addSliderImage(Uint8List sliderImage, int index) async {
    try {
      String fileName =
          "${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
      await experienceImagesDB.uploadBinary(fileName, sliderImage);
      await experienceDB.update({'slider_image_name': fileName}).eq(
          'id', experiences[index].id);

      setState(() {
        experiences[index] =
            experiences[index].copyWith(sliderImageName: fileName);
      });
      Get.snackbar('Success', 'Slider image added successfully');
    } catch (e) {
      print('Error adding slider image: $e');
      Get.snackbar('Error', 'Failed to add slider image: $e');
    }
  }

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
            style: MyStyles.appBarButtonStyle,
          ),
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
                        SizedBox(
                          height: 120,
                          width: 160,
                          child: experiences[index].imageName.isEmpty
                              ? const Center(child: Text("No Images"))
                              : CarouselSlider(
                                  options: CarouselOptions(
                                    height: 120,
                                    autoPlay: true,
                                    autoPlayInterval:
                                        const Duration(seconds: 3),
                                    enlargeCenterPage: true,
                                    viewportFraction: 1.0,
                                  ),
                                  items: experiences[index]
                                      .imageName
                                      .map((imageName) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        experienceImagesDB
                                            .getPublicUrl(imageName),
                                        width: 140,
                                        height: 120,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(Icons.error),
                                      ),
                                    );
                                  }).toList(),
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
                                "\$${experiences[index].kidsPrice?.toStringAsFixed(2) ?? '0.00'}",
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green),
                              ),
                              Text(
                                "\$${experiences[index].infantPrice?.toStringAsFixed(2) ?? '0.00'}",
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green),
                              ),
                              Text(
                                "\$${experiences[index].adultPrice?.toStringAsFixed(2) ?? '0.00'}",
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green),
                              ),
                            ],
                          ),
                        ),
                        // IconButton(
                        //   icon: const Icon(Icons.edit, color: Colors.blue),
                        //   onPressed: () => _showExperienceDialog(index: index),
                        // ),
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

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guide_app_panel/Models/category_model.dart';
import 'package:guide_app_panel/Models/slider_model.dart';
import 'package:guide_app_panel/Utils/theme.dart' show MyColors, MyStyles;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';

class SliderPage extends StatefulWidget {
  const SliderPage({super.key});

  @override
  _SliderPageState createState() => _SliderPageState();
}

class _SliderPageState extends State<SliderPage> {
  final SupabaseQueryBuilder experienceDB =
      Supabase.instance.client.from('Slider');
  final StorageFileApi sliderImagesDB =
      Supabase.instance.client.storage.from('sliderimages');
  List<Sliders> sliders = [];
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
    loadSliderss();
    _loadCategories();
  }

  Future<void> loadSliderss() async {
    try {
      final response = await experienceDB.select();
      sliders = response.map((data) => Sliders.fromMap(data)).toList();
      setState(() {});
    } catch (e) {
      print('Error fetching sliders: $e');
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

  Future<void> addSlider({
    required String place,
    required String description,
    required double adultPrice,
    required double kidsPrice,
    required double infantPrice,
  }) async {
    var id = DateTime.now().millisecondsSinceEpoch;
    final String fileName = '$id.jpg';

    try {
      await sliderImagesDB.uploadBinary(fileName, pickedImageBytes!);
      final slider = {
        'id': id,
        'place': place,
        'description': description,
        'slider_image_name': fileName,
        'adult_price': adultPrice,
        'kids_price': kidsPrice,
        'infant_price': infantPrice
      };

      await experienceDB.insert(slider);

      sliders.add(Sliders(
          id: id,
          place: place,
          description: description,
          sliderImageName: fileName,
          adultPrice: adultPrice,
          kidsPrice: kidsPrice,
          infantPrice: infantPrice));

      pickedImageName = "";
      pickedImageBytes = null;
      print("Sliders added successfully!");
    } catch (e) {
      print("Error adding Sliders: $e");
    }
  }

  Future<void> editSlider(
      {required int index,
      required String place,
      required String description,
      required double adultPrice,
      required double kidsPrice,
      required double infantPrice}) async {
    var id = sliders[index].id;
    final String fileName = '$id.jpg';

    try {
      await sliderImagesDB.remove([fileName]);
      await sliderImagesDB.uploadBinary(fileName, pickedImageBytes!);
      final slider = {
        'id': id,
        'place': place,
        'description': description,
        'slider_image_name': fileName,
        'adult_price': adultPrice,
        'kids_price': kidsPrice,
        'infant_price': infantPrice
      };

      await experienceDB.update(slider).eq('id', id);

      sliders[index] = Sliders(
          id: id,
          place: place,
          description: description,
          sliderImageName: fileName,
          adultPrice: adultPrice,
          kidsPrice: kidsPrice,
          infantPrice: infantPrice);
      print("Slider updated successfully!");
    } catch (e) {
      print("Error adding Slider: $e");
    }
  }

  Future<void> _showSlidereDialog({int? index}) async {
    TextEditingController placeController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController kidsPriceController = TextEditingController();
    TextEditingController infantPriceController = TextEditingController();
    TextEditingController adultPriceController = TextEditingController();
    String? selectedCategory;

    if (index != null) {
      placeController.text = sliders[index].place;
      descriptionController.text = sliders[index].description;
      kidsPriceController.text = sliders[index].kidsPrice.toString();
      infantPriceController.text = sliders[index].infantPrice.toString();
      adultPriceController.text = sliders[index].adultPrice.toString();
      var imageUrl =
          sliderImagesDB.getPublicUrl(sliders[index].sliderImageName);
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
        title: Text(index == null ? "Add Slider" : "Edit Slider"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: placeController,
                decoration: const InputDecoration(labelText: 'Slider'),
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
                var description = descriptionController.text;
                var kidsPrice =
                    double.tryParse(kidsPriceController.text) ?? 0.0;
                var infantPrice =
                    double.tryParse(infantPriceController.text) ?? 0.0;
                var adultPrice =
                    double.tryParse(adultPriceController.text) ?? 0.0;
                if (index == null) {
                  await addSlider(
                      place: place,
                      description: description,
                      kidsPrice: kidsPrice,
                      infantPrice: infantPrice,
                      adultPrice: adultPrice);
                } else {
                  await editSlider(
                      index: index,
                      place: place,
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

  Future<void> _deleteSlider(int index) async {
    try {
      await sliderImagesDB.remove([sliders[index].sliderImageName]);
      await experienceDB.delete().eq('id', sliders[index].id);

      setState(() {
        sliders.removeAt(index);
      });
    } catch (e) {
      print("Error deleting slider: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.orangeColor,
        foregroundColor: Colors.white,
        title: const Text('Sliders'),
        actions: [
          ElevatedButton.icon(
              onPressed: () => _showSlidereDialog(),
              icon: Icon(Icons.add, color: MyColors.orangeColor),
              label: const Text("Add Slider"),
              style: MyStyles.appBarButtonStyle),
          const SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: sliders.isEmpty
            ? const Center(child: Text("No Slider added"))
            : ListView.builder(
                itemCount: sliders.length,
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
                            sliderImagesDB
                                .getPublicUrl(sliders[index].sliderImageName),
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
                                sliders[index].place,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              // Text(
                              //   sliders[index].activity,
                              //   style: const TextStyle(fontSize: 16),
                              // ),
                              // Text(
                              //   sliders[index].description,
                              //   style: const TextStyle(
                              //       fontSize: 14, color: Colors.grey),
                              //   maxLines: 2,
                              //   overflow: TextOverflow.ellipsis,
                              // ),
                              Text(
                                "\$${sliders[index].kidsPrice}",
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green),
                              ),
                              Text(
                                "\$${sliders[index].infantPrice}",
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green),
                              ),
                              Text(
                                "\$${sliders[index].adultPrice}",
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
                          onPressed: () => _showSlidereDialog(index: index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteSlider(index),
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

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:guide_app_panel/Models/category_model.dart';
import 'package:guide_app_panel/Utils/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final SupabaseQueryBuilder categoryDB =
      Supabase.instance.client.from('categories');
  final StorageFileApi categoryImagesDB =
      Supabase.instance.client.storage.from('category-images');
  List<Category> categories = [];
  Uint8List? pickedImageBytes;
  String? pickedImageName;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final response = await categoryDB.select();
      categories = response.map((data) => Category.fromMap(data)).toList();
      setState(() {});
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  Future<void> _addCategory({
    required String name,
  }) async {
    // Generate a unique filename
    var id = DateTime.now().millisecondsSinceEpoch;
    final String fileName = '$id.jpg';

    try {
      // Upload image to Supabase Storage
      await categoryImagesDB.uploadBinary(fileName, pickedImageBytes!);

      // Insert category data with image filename
      final category = {
        'id': id,
        'name': name,
        'image_name': fileName,
      };

      await categoryDB.insert(category);

      categories.add(Category(
        id: id,
        name: name,
        imageName: fileName,
      ));

      pickedImageName = "";
      pickedImageBytes = null;
      print("Category added successfully!");
    } catch (e) {
      print("Error adding category: $e");
    }
  }

  Future<void> _editCategory({
    required int index,
    required String name,
  }) async {
    // Generate a unique filename
    var id = categories[index].id;
    final String fileName = '$id.jpg';

    try {
      // Upload image to Supabase Storage
      await categoryImagesDB.remove([fileName]);
      await categoryImagesDB.uploadBinary(fileName, pickedImageBytes!);

      // Insert category data with image filename
      final category = {
        'id': id,
        'name': name,
        'image_name': fileName,
      };

      await categoryDB.update(category).eq('id', id);

      categories[index] = Category(
        id: id,
        name: name,
        imageName: fileName,
      );

      print("Experience updated successfully!");
    } catch (e) {
      print("Error adding experience: $e");
    }
  }

  Future<void> _showCategoryDialog({int? index}) async {
    TextEditingController nameController = TextEditingController();

    if (index != null) {
      nameController.text = categories[index].name;
      var imageUrl = categoryImagesDB.getPublicUrl(categories[index].imageName);
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
        title: Text(index == null ? "Add Category" : "Edit Category"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Category Name'),
            ),
            const SizedBox(height: 10),
            pickedImageBytes == null
                ? const Text("No Image Selected")
                : Image.memory(pickedImageBytes!, height: 50, width: 50),
            TextButton.icon(
              onPressed: pickImage,
              icon: Icon(Icons.image, color: MyColors.orangeColor),
              label: Text("Pick Icon", style: MyStyles.orangeText),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("Cancel", style: MyStyles.orangeText),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty && pickedImageBytes != null) {
                if (index == null) {
                  await _addCategory(name: nameController.text);
                } else {
                  await _editCategory(index: index, name: nameController.text);
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

  Future<void> _deleteCategory(int index) async {
    try {
      await categoryImagesDB.remove([categories[index].imageName]);
      await categoryDB.delete().eq('id', categories[index].id);

      setState(() {
        categories.removeAt(index);
      });
    } catch (e) {
      print("Error deleting experience: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.orangeColor,
        foregroundColor: Colors.white,
        title: const Text('Categories'),
        actions: [
          ElevatedButton.icon(
            onPressed: () => _showCategoryDialog(),
            icon: Icon(Icons.add, color: MyColors.orangeColor),
            label: const Text("Add Category", style: TextStyle(fontSize: 16)),
            style: MyStyles.appBarButtonStyle,
          ),
          const SizedBox(width: 16), // Add spacing on the right side
        ],
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width *
              0.6, // Limit width to 60% of screen
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: categories.isEmpty
              ? const Center(child: Text("No categories added"))
              : ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (ctx, index) => Card(
                    color: MyColors.lightOrangeColor,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: Image.network(
                          categoryImagesDB
                              .getPublicUrl(categories[index].imageName),
                          width: 40,
                          height: 40),
                      title: Text(categories[index].name),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _showCategoryDialog(index: index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteCategory(index),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

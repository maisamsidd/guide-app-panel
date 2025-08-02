class Category {
  final int id;
  final String name;
  final String imageName;

  Category({
    required this.id,
    required this.name,
    required this.imageName,
  });

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] as int,
      name: map['name'] as String,
      imageName: map['image_name'] as String? ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image_name': imageName,
    };
  }

  static List<Category> fromList(List<Map<String, dynamic>> dataList) {
    return dataList.map((data) => Category.fromMap(data)).toList();
  }

  Category copyWith({
    int? id,
    String? name,
    String? imageName,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      imageName: imageName ?? this.imageName,
    );
  }
}

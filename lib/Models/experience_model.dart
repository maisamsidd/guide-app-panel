class Experience {
  final int id;
  final String place;
  final String activity;
  final String description;
  final String imageName;
  final String sliderImageName;
  final double? adultPrice;
  final double? kidsPrice;
  final double? infantPrice;

  Experience(
      {required this.id,
      required this.place,
      required this.activity,
      required this.description,
      required this.imageName,
      required this.sliderImageName,
      required this.adultPrice,
      required this.kidsPrice,
      required this.infantPrice});

  factory Experience.fromMap(Map<String, dynamic> map) {
    return Experience(
      id: map['id'] as int,
      place: map['place'] as String,
      activity: map['activity'] as String,
      description: map['description'] as String,
      imageName: map['image_name'] as String? ?? "",
      sliderImageName: map['slider_image_name'] as String? ?? "",
      adultPrice: (map['adult_price'] as num).toDouble(),
      kidsPrice: (map['kids_price'] as num).toDouble(),
      infantPrice: (map['infant_price'] as num).toDouble(),
    );
  }

  // Convert Experience object to Map (for Supabase insertion)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'place': place,
      'activity': activity,
      'description': description,
      'image_name': imageName,
      'slider_image_name': sliderImageName,
      'adult_price': adultPrice,
      'kids_price': kidsPrice,
      'infant_price': infantPrice
    };
  }

  // Convert a list of maps (from Supabase) to a list of Experience objects
  static List<Experience> fromList(List<Map<String, dynamic>> dataList) {
    return dataList.map((data) => Experience.fromMap(data)).toList();
  }

  // CopyWith method to update specific fields
  Experience copyWith(
      {int? id,
      String? place,
      String? activity,
      String? description,
      String? imageName,
      String? sliderImageName,
      double? adultPrice,
      double? kidsPrice,
      double? infantPrice}) {
    return Experience(
        id: id ?? this.id,
        place: place ?? this.place,
        activity: activity ?? this.activity,
        description: description ?? this.description,
        imageName: imageName ?? this.imageName,
        sliderImageName: sliderImageName ?? this.sliderImageName,
        adultPrice: this.adultPrice,
        kidsPrice: this.kidsPrice,
        infantPrice: this.infantPrice);
  }
}

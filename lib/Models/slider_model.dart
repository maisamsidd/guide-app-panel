class Sliders {
  final int id;
  final String place;
  final String description;
  final String sliderImageName;
  final double? adultPrice;
  final double? kidsPrice;
  final double? infantPrice;

  Sliders(
      {required this.id,
      required this.place,
      required this.description,
      required this.sliderImageName,
      required this.adultPrice,
      required this.kidsPrice,
      required this.infantPrice});

  factory Sliders.fromMap(Map<String, dynamic> map) {
    return Sliders(
      id: map['id'] as int,
      place: map['place'] as String,
      description: map['description'] as String,
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
      'description': description,
      'slider_image_name': sliderImageName,
      'adult_price': adultPrice,
      'kids_price': kidsPrice,
      'infant_price': infantPrice
    };
  }

  // Convert a list of maps (from Supabase) to a list of Experience objects
  static List<Sliders> fromList(List<Map<String, dynamic>> dataList) {
    return dataList.map((data) => Sliders.fromMap(data)).toList();
  }

  // CopyWith method to update specific fields
  Sliders copyWith(
      {int? id,
      String? place,
      String? description,
      String? imageName,
      String? sliderImageName,
      double? adultPrice,
      double? kidsPrice,
      double? infantPrice}) {
    return Sliders(
        id: id ?? this.id,
        place: place ?? this.place,
        description: description ?? this.description,
        sliderImageName: sliderImageName ?? this.sliderImageName,
        adultPrice: this.adultPrice,
        kidsPrice: this.kidsPrice,
        infantPrice: this.infantPrice);
  }
}

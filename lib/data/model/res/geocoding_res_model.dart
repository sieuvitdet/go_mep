class GeocodingResModel {
  final String address;

  GeocodingResModel({
    required this.address,
  });

  factory GeocodingResModel.fromJson(Map<String, dynamic> json) {
    return GeocodingResModel(
      address: json['address'] ?? '',
    );
  }

  factory GeocodingResModel.fromString(String addressString) {
    return GeocodingResModel(
      address: addressString,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
    };
  }
}

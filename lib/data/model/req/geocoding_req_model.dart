class GeocodingReqModel {
  final double lat;
  final double lng;

  GeocodingReqModel({
    required this.lat,
    required this.lng,
  });

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lng': lng,
    };
  }

  Map<String, String> toQueryParameters() {
    return {
      'lat': lat.toString(),
      'lng': lng.toString(),
      'api-version': '1.0',
    };
  }
}

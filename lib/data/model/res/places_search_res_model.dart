class PlacesSearchResModel {
  List<PlaceResultModel>? results;
  int? totalResults;

  PlacesSearchResModel({
    this.results,
    this.totalResults,
  });

  PlacesSearchResModel.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <PlaceResultModel>[];
      json['results'].forEach((v) {
        results!.add(PlaceResultModel.fromJson(v));
      });
    }
    totalResults = json['total_results'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    data['total_results'] = totalResults;
    return data;
  }
}

class PlaceResultModel {
  String? id;
  String? name;
  String? address;
  String? formattedAddress;
  LocationModel? location;
  double? rating;
  String? phone;
  String? website;
  List<String>? types;
  bool? isOpen;
  String? openingHours;
  String? priceLevel;

  PlaceResultModel({
    this.id,
    this.name,
    this.address,
    this.formattedAddress,
    this.location,
    this.rating,
    this.phone,
    this.website,
    this.types,
    this.isOpen,
    this.openingHours,
    this.priceLevel,
  });

  PlaceResultModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    formattedAddress = json['formatted_address'];
    location = json['location'] != null 
        ? LocationModel.fromJson(json['location']) 
        : null;
    rating = json['rating']?.toDouble();
    phone = json['phone'];
    website = json['website'];
    types = json['types']?.cast<String>();
    isOpen = json['is_open'];
    openingHours = json['opening_hours'];
    priceLevel = json['price_level'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['address'] = address;
    data['formatted_address'] = formattedAddress;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['rating'] = rating;
    data['phone'] = phone;
    data['website'] = website;
    data['types'] = types;
    data['is_open'] = isOpen;
    data['opening_hours'] = openingHours;
    data['price_level'] = priceLevel;
    return data;
  }
}

class LocationModel {
  double? lat;
  double? lng;

  LocationModel({
    this.lat,
    this.lng,
  });

  LocationModel.fromJson(Map<String, dynamic> json) {
    lat = json['lat']?.toDouble();
    lng = json['lng']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
  }
}
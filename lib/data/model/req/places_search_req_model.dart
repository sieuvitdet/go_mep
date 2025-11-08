class PlacesSearchReqModel {
  String? query;
  String? location;
  int? maxResults;

  PlacesSearchReqModel({
    this.query,
    this.location,
    this.maxResults,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['query'] = query;
    data['location'] = location;
    data['max_results'] = maxResults;
    return data;
  }

  PlacesSearchReqModel.fromJson(Map<String, dynamic> json) {
    query = json['query'];
    location = json['location'];
    maxResults = json['max_results'];
  }
}
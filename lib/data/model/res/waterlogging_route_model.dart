/// Model cho waterlogging route (tuyến đường ngập úng)
class WaterloggingRouteModel {
  final int routeId;
  final String routeName;
  final List<WaterloggingPoint> points;
  final String lineColor;
  final double lineWidth;
  final String? description;

  WaterloggingRouteModel({
    required this.routeId,
    required this.routeName,
    required this.points,
    this.lineColor = '#2196F3', // Màu xanh dương
    this.lineWidth = 5.0,
    this.description,
  });

  factory WaterloggingRouteModel.fromJson(Map<String, dynamic> json) {
    return WaterloggingRouteModel(
      routeId: json['routeId'] as int,
      routeName: json['routeName'] as String,
      points: (json['points'] as List)
          .map((point) => WaterloggingPoint.fromJson(point))
          .toList(),
      lineColor: json['lineColor'] as String? ?? '#2196F3',
      lineWidth: (json['lineWidth'] as num?)?.toDouble() ?? 5.0,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'routeId': routeId,
      'routeName': routeName,
      'points': points.map((p) => p.toJson()).toList(),
      'lineColor': lineColor,
      'lineWidth': lineWidth,
      'description': description,
    };
  }
}

/// Model cho từng điểm trong tuyến đường
class WaterloggingPoint {
  final double latitude;
  final double longitude;
  final int orderIndex;

  WaterloggingPoint({
    required this.latitude,
    required this.longitude,
    required this.orderIndex,
  });

  factory WaterloggingPoint.fromJson(Map<String, dynamic> json) {
    return WaterloggingPoint(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      orderIndex: json['orderIndex'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'orderIndex': orderIndex,
    };
  }

  /// Parse từ string "lat, lng"
  factory WaterloggingPoint.fromString(String coordString, int index) {
    final parts = coordString.split(',').map((e) => e.trim()).toList();
    return WaterloggingPoint(
      latitude: double.parse(parts[0]),
      longitude: double.parse(parts[1]),
      orderIndex: index,
    );
  }
}

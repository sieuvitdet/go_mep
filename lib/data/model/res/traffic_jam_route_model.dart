import 'package:json_annotation/json_annotation.dart';

part 'traffic_jam_route_model.g.dart';

/// Model representing a traffic jam route with multiple points
@JsonSerializable(explicitToJson: true)
class TrafficJamRouteModel {
  final int routeId;
  final String routeName;
  final List<TrafficJamPoint> points;
  final String lineColor;
  final double lineWidth;
  final String? description;

  TrafficJamRouteModel({
    required this.routeId,
    required this.routeName,
    required this.points,
    this.lineColor = '#FF5722', // Default: Deep Orange for traffic jam
    this.lineWidth = 5.0,
    this.description,
  });

  /// Parse from JSON - supports both string array and object array
  factory TrafficJamRouteModel.fromJson(Map<String, dynamic> json) {
    // Check if points is a list of strings or objects
    final pointsData = json['points'] as List;

    List<TrafficJamPoint> points;
    if (pointsData.isNotEmpty && pointsData.first is String) {
      // Parse from string format: ["lat, lng", "lat, lng", ...]
      points = pointsData
          .asMap()
          .entries
          .map((entry) => TrafficJamPoint.fromString(entry.value as String, entry.key))
          .toList();
    } else {
      // Parse from object format (standard JSON serialization)
      points = (pointsData as List)
          .map((e) => TrafficJamPoint.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return TrafficJamRouteModel(
      routeId: json['routeId'] as int,
      routeName: json['routeName'] as String,
      points: points,
      lineColor: json['lineColor'] as String? ?? '#FF5722',
      lineWidth: (json['lineWidth'] as num?)?.toDouble() ?? 5.0,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() => _$TrafficJamRouteModelToJson(this);

  TrafficJamRouteModel copyWith({
    int? routeId,
    String? routeName,
    List<TrafficJamPoint>? points,
    String? lineColor,
    double? lineWidth,
    String? description,
  }) {
    return TrafficJamRouteModel(
      routeId: routeId ?? this.routeId,
      routeName: routeName ?? this.routeName,
      points: points ?? this.points,
      lineColor: lineColor ?? this.lineColor,
      lineWidth: lineWidth ?? this.lineWidth,
      description: description ?? this.description,
    );
  }

  @override
  String toString() {
    return 'TrafficJamRouteModel(routeId: $routeId, routeName: $routeName, points: ${points.length}, lineColor: $lineColor)';
  }
}

/// Represents a single point in a traffic jam route
@JsonSerializable()
class TrafficJamPoint {
  final double latitude;
  final double longitude;
  final int orderIndex;

  TrafficJamPoint({
    required this.latitude,
    required this.longitude,
    required this.orderIndex,
  });

  factory TrafficJamPoint.fromJson(Map<String, dynamic> json) =>
      _$TrafficJamPointFromJson(json);

  Map<String, dynamic> toJson() => _$TrafficJamPointToJson(this);

  /// Parse from string format "lat, lng"
  factory TrafficJamPoint.fromString(String coordString, int orderIndex) {
    final parts = coordString.split(',').map((e) => e.trim()).toList();
    if (parts.length != 2) {
      throw FormatException('Invalid coordinate format: $coordString');
    }
    return TrafficJamPoint(
      latitude: double.parse(parts[0]),
      longitude: double.parse(parts[1]),
      orderIndex: orderIndex,
    );
  }

  @override
  String toString() {
    return 'TrafficJamPoint(lat: $latitude, lng: $longitude, order: $orderIndex)';
  }

  TrafficJamPoint copyWith({
    double? latitude,
    double? longitude,
    int? orderIndex,
  }) {
    return TrafficJamPoint(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      orderIndex: orderIndex ?? this.orderIndex,
    );
  }
}

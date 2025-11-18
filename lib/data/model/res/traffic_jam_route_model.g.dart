// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'traffic_jam_route_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrafficJamRouteModel _$TrafficJamRouteModelFromJson(
        Map<String, dynamic> json) =>
    TrafficJamRouteModel(
      routeId: (json['routeId'] as num).toInt(),
      routeName: json['routeName'] as String,
      points: (json['points'] as List<dynamic>)
          .map((e) => TrafficJamPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
      lineColor: json['lineColor'] as String? ?? '#FF5722',
      lineWidth: (json['lineWidth'] as num?)?.toDouble() ?? 5.0,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$TrafficJamRouteModelToJson(
        TrafficJamRouteModel instance) =>
    <String, dynamic>{
      'routeId': instance.routeId,
      'routeName': instance.routeName,
      'points': instance.points.map((e) => e.toJson()).toList(),
      'lineColor': instance.lineColor,
      'lineWidth': instance.lineWidth,
      'description': instance.description,
    };

TrafficJamPoint _$TrafficJamPointFromJson(Map<String, dynamic> json) =>
    TrafficJamPoint(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      orderIndex: (json['orderIndex'] as num).toInt(),
    );

Map<String, dynamic> _$TrafficJamPointToJson(TrafficJamPoint instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'orderIndex': instance.orderIndex,
    };

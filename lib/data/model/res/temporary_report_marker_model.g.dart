// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'temporary_report_marker_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TemporaryReportMarkerModel _$TemporaryReportMarkerModelFromJson(
        Map<String, dynamic> json) =>
    TemporaryReportMarkerModel(
      id: (json['id'] as num).toInt(),
      reportType: $enumDecode(_$ReportTypeEnumMap, json['reportType']),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      userReportedBy: json['userReportedBy'] as String?,
    );

Map<String, dynamic> _$TemporaryReportMarkerModelToJson(
        TemporaryReportMarkerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reportType': _$ReportTypeEnumMap[instance.reportType]!,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'description': instance.description,
      'createdAt': instance.createdAt.toIso8601String(),
      'expiresAt': instance.expiresAt.toIso8601String(),
      'userReportedBy': instance.userReportedBy,
    };

const _$ReportTypeEnumMap = {
  ReportType.trafficJam: 'trafficJam',
  ReportType.waterlogging: 'waterlogging',
  ReportType.accident: 'accident',
};

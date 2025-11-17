import 'package:json_annotation/json_annotation.dart';

part 'temporary_report_marker_model.g.dart';

/// Type of report
enum ReportType {
  trafficJam,      // Tắc đường
  waterlogging,    // Ngập nước
  accident;        // Tai nạn

  String get displayName {
    switch (this) {
      case ReportType.trafficJam:
        return 'Tắc Đường';
      case ReportType.waterlogging:
        return 'Ngập Nước';
      case ReportType.accident:
        return 'Tai Nạn';
    }
  }

  String get iconAsset {
    switch (this) {
      case ReportType.trafficJam:
        return 'assets/icons/traffic_jam.png';
      case ReportType.waterlogging:
        return 'assets/icons/waterlogging.png';
      case ReportType.accident:
        return 'assets/icons/accident.png';
    }
  }
}

/// Model for temporary report markers that auto-expire after 1 hour
@JsonSerializable(explicitToJson: true)
class TemporaryReportMarkerModel {
  final int id;
  final ReportType reportType;
  final double latitude;
  final double longitude;
  final String? description;
  final DateTime createdAt;
  final DateTime expiresAt;
  final String? userReportedBy;

  TemporaryReportMarkerModel({
    required this.id,
    required this.reportType,
    required this.latitude,
    required this.longitude,
    this.description,
    required this.createdAt,
    required this.expiresAt,
    this.userReportedBy,
  });

  /// Create new marker (expires in 1 hour by default)
  factory TemporaryReportMarkerModel.create({
    required int id,
    required ReportType reportType,
    required double latitude,
    required double longitude,
    String? description,
    String? userReportedBy,
    Duration expiryDuration = const Duration(hours: 1),
  }) {
    final now = DateTime.now();
    return TemporaryReportMarkerModel(
      id: id,
      reportType: reportType,
      latitude: latitude,
      longitude: longitude,
      description: description,
      createdAt: now,
      expiresAt: now.add(expiryDuration),
      userReportedBy: userReportedBy,
    );
  }

  factory TemporaryReportMarkerModel.fromJson(Map<String, dynamic> json) =>
      _$TemporaryReportMarkerModelFromJson(json);

  Map<String, dynamic> toJson() => _$TemporaryReportMarkerModelToJson(this);

  /// Check if marker has expired
  bool get isExpired => DateTime.now().isAfter(expiresAt);

  /// Get remaining time until expiry
  Duration get timeUntilExpiry {
    final now = DateTime.now();
    if (now.isAfter(expiresAt)) {
      return Duration.zero;
    }
    return expiresAt.difference(now);
  }

  /// Get formatted remaining time
  String get formattedRemainingTime {
    final remaining = timeUntilExpiry;
    if (remaining.inMinutes < 1) {
      return 'Hết hạn';
    } else if (remaining.inMinutes < 60) {
      return '${remaining.inMinutes} phút';
    } else {
      return '${remaining.inHours} giờ ${remaining.inMinutes % 60} phút';
    }
  }

  TemporaryReportMarkerModel copyWith({
    int? id,
    ReportType? reportType,
    double? latitude,
    double? longitude,
    String? description,
    DateTime? createdAt,
    DateTime? expiresAt,
    String? userReportedBy,
  }) {
    return TemporaryReportMarkerModel(
      id: id ?? this.id,
      reportType: reportType ?? this.reportType,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      userReportedBy: userReportedBy ?? this.userReportedBy,
    );
  }

  @override
  String toString() {
    return 'TemporaryReportMarker(id: $id, type: ${reportType.displayName}, lat: $latitude, lng: $longitude, expires: $formattedRemainingTime)';
  }
}

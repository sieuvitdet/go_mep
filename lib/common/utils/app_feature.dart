/// Enum representing all available features in the app
enum AppFeature {
  /// Report traffic jam feature
  reportTrafficJam,

  /// Report waterlogging/flood feature
  reportWaterlogging,

  /// Report accident feature
  reportAccident,

  /// Search/Find restaurants
  findRestaurants,

  /// Open restaurant list screen
  openRestaurantList,

  /// Open notifications screen
  openNotifications,

  /// Open user profile screen
  openProfile,

  /// Unknown or unsupported feature
  unknown;

  /// Get feature from string (for debugging/logging)
  String get displayName {
    switch (this) {
      case AppFeature.reportTrafficJam:
        return 'Báo Tắc Đường';
      case AppFeature.reportWaterlogging:
        return 'Báo Ngập Nước';
      case AppFeature.reportAccident:
        return 'Báo Tai Nạn';
      case AppFeature.findRestaurants:
        return 'Tìm Quán Ăn';
      case AppFeature.openRestaurantList:
        return 'Mở Danh Sách Quán Ăn';
      case AppFeature.openNotifications:
        return 'Mở Thông Báo';
      case AppFeature.openProfile:
        return 'Mở Profile';
      case AppFeature.unknown:
        return 'Không xác định';
    }
  }

  /// Get feature description
  String get description {
    switch (this) {
      case AppFeature.reportTrafficJam:
        return 'Báo cáo tình trạng tắc đường giao thông';
      case AppFeature.reportWaterlogging:
        return 'Báo cáo tình trạng ngập úng, ngập nước';
      case AppFeature.reportAccident:
        return 'Báo cáo tai nạn giao thông';
      case AppFeature.findRestaurants:
        return 'Tìm kiếm quán ăn gần đây';
      case AppFeature.openRestaurantList:
        return 'Hiển thị danh sách các quán ăn';
      case AppFeature.openNotifications:
        return 'Mở danh sách thông báo';
      case AppFeature.openProfile:
        return 'Mở trang cá nhân của người dùng';
      case AppFeature.unknown:
        return 'Tính năng không được hỗ trợ';
    }
  }
}

/// Result of feature recognition
class FeatureRecognitionResult {
  final AppFeature feature;
  final double confidence;
  final String? detectedKeywords;
  final Map<String, dynamic>? parameters;

  FeatureRecognitionResult({
    required this.feature,
    required this.confidence,
    this.detectedKeywords,
    this.parameters,
  });

  bool get isConfident => confidence >= 0.7;

  @override
  String toString() {
    return 'FeatureRecognitionResult(feature: ${feature.displayName}, confidence: $confidence, keywords: $detectedKeywords)';
  }
}

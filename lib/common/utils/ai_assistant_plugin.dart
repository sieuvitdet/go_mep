import 'package:go_mep_application/common/utils/app_feature.dart';

/// AI Assistant Plugin - Recognizes user intent from text input
/// Supports Vietnamese language with various ways of expressing commands
class AIAssistantPlugin {
  /// Keywords mapping for each feature
  static final Map<AppFeature, List<String>> _featureKeywords = {
    AppFeature.reportTrafficJam: [
      'tắc đường',
      'tac duong',
      'kẹt xe',
      'ket xe',
      'tắc nghẽn',
      'tac nghen',
      'báo tắc',
      'bao tac',
      'đường tắc',
      'duong tac',
      'traffic jam',
      'traffic',
    ],
    AppFeature.reportWaterlogging: [
      'ngập nước',
      'ngap nuoc',
      'ngập úng',
      'ngap ung',
      'báo ngập',
      'bao ngap',
      'nước ngập',
      'nuoc ngap',
      'úng nước',
      'ung nuoc',
      'flood',
      'flooding',
      'waterlogging',
    ],
    AppFeature.reportAccident: [
      'tai nạn',
      'tai nan',
      'báo tai nạn',
      'bao tai nan',
      'va chạm',
      'va cham',
      'đụng xe',
      'dung xe',
      'accident',
      'crash',
    ],
    AppFeature.findRestaurants: [
      'tìm quán ăn',
      'tim quan an',
      'tìm quán',
      'tim quan',
      'tìm đồ ăn',
      'tim do an',
      'quán ăn gần đây',
      'quan an gan day',
      'ăn gì',
      'an gi',
      'find restaurant',
      'search restaurant',
      'restaurant near',
    ],
    AppFeature.openRestaurantList: [
      'mở quán ăn',
      'mo quan an',
      'hiện quán ăn',
      'hien quan an',
      'danh sách quán ăn',
      'danh sach quan an',
      'xem quán ăn',
      'xem quan an',
      'list quán ăn',
      'list quan an',
      'open restaurant',
      'show restaurant',
      'restaurant list',
    ],
    AppFeature.openNotifications: [
      'thông báo',
      'thong bao',
      'mở thông báo',
      'mo thong bao',
      'xem thông báo',
      'xem thong bao',
      'notifications',
      'notification',
      'alert',
    ],
    AppFeature.openProfile: [
      'profile',
      'hồ sơ',
      'ho so',
      'tài khoản',
      'tai khoan',
      'mở profile',
      'mo profile',
      'xem profile',
      'my profile',
      'my account',
      'cá nhân',
      'ca nhan',
    ],
  };

  /// Recognize feature from text input
  static FeatureRecognitionResult recognize(String input) {
    if (input.trim().isEmpty) {
      return FeatureRecognitionResult(
        feature: AppFeature.unknown,
        confidence: 0.0,
      );
    }

    final normalizedInput = _normalizeText(input);
    AppFeature bestMatch = AppFeature.unknown;
    double bestConfidence = 0.0;
    String? bestKeyword;

    // Check each feature's keywords
    for (final entry in _featureKeywords.entries) {
      final feature = entry.key;
      final keywords = entry.value;

      for (final keyword in keywords) {
        final normalizedKeyword = _normalizeText(keyword);

        // Exact match
        if (normalizedInput == normalizedKeyword) {
          return FeatureRecognitionResult(
            feature: feature,
            confidence: 1.0,
            detectedKeywords: keyword,
          );
        }

        // Contains match
        if (normalizedInput.contains(normalizedKeyword)) {
          final confidence = _calculateConfidence(normalizedInput, normalizedKeyword);
          if (confidence > bestConfidence) {
            bestConfidence = confidence;
            bestMatch = feature;
            bestKeyword = keyword;
          }
        }

        // Fuzzy match (for typos)
        final similarity = _calculateSimilarity(normalizedInput, normalizedKeyword);
        if (similarity > 0.7 && similarity > bestConfidence) {
          bestConfidence = similarity;
          bestMatch = feature;
          bestKeyword = keyword;
        }
      }
    }

    return FeatureRecognitionResult(
      feature: bestMatch,
      confidence: bestConfidence,
      detectedKeywords: bestKeyword,
    );
  }

  /// Recognize multiple features from text (for complex queries)
  static List<FeatureRecognitionResult> recognizeMultiple(String input) {
    final results = <FeatureRecognitionResult>[];
    final normalizedInput = _normalizeText(input);

    for (final entry in _featureKeywords.entries) {
      final feature = entry.key;
      final keywords = entry.value;

      for (final keyword in keywords) {
        final normalizedKeyword = _normalizeText(keyword);

        if (normalizedInput.contains(normalizedKeyword)) {
          final confidence = _calculateConfidence(normalizedInput, normalizedKeyword);
          if (confidence >= 0.5) {
            results.add(FeatureRecognitionResult(
              feature: feature,
              confidence: confidence,
              detectedKeywords: keyword,
            ));
            break; // One match per feature
          }
        }
      }
    }

    // Sort by confidence
    results.sort((a, b) => b.confidence.compareTo(a.confidence));
    return results;
  }

  /// Normalize text for comparison
  static String _normalizeText(String text) {
    return text
        .toLowerCase()
        .trim()
        // Remove Vietnamese diacritics (basic)
        .replaceAll(RegExp(r'[àáạảãâầấậẩẫăằắặẳẵ]'), 'a')
        .replaceAll(RegExp(r'[èéẹẻẽêềếệểễ]'), 'e')
        .replaceAll(RegExp(r'[ìíịỉĩ]'), 'i')
        .replaceAll(RegExp(r'[òóọỏõôồốộổỗơờớợởỡ]'), 'o')
        .replaceAll(RegExp(r'[ùúụủũưừứựửữ]'), 'u')
        .replaceAll(RegExp(r'[ỳýỵỷỹ]'), 'y')
        .replaceAll(RegExp(r'[đ]'), 'd')
        // Remove extra spaces
        .replaceAll(RegExp(r'\s+'), ' ');
  }

  /// Calculate confidence based on keyword length vs input length
  static double _calculateConfidence(String input, String keyword) {
    // Exact match
    if (input == keyword) return 1.0;

    // Starts with keyword
    if (input.startsWith(keyword)) {
      return 0.9;
    }

    // Contains keyword - confidence based on ratio
    final ratio = keyword.length / input.length;
    return 0.5 + (ratio * 0.4); // Range: 0.5 to 0.9
  }

  /// Calculate similarity between two strings (simple Levenshtein-like)
  static double _calculateSimilarity(String s1, String s2) {
    if (s1 == s2) return 1.0;
    if (s1.isEmpty || s2.isEmpty) return 0.0;

    final longer = s1.length > s2.length ? s1 : s2;
    final shorter = s1.length > s2.length ? s2 : s1;

    if (longer.length == 0) return 1.0;

    final editDistance = _levenshteinDistance(longer, shorter);
    return (longer.length - editDistance) / longer.length;
  }

  /// Calculate Levenshtein distance between two strings
  static int _levenshteinDistance(String s1, String s2) {
    final costs = List<int>.filled(s2.length + 1, 0);

    for (int i = 0; i <= s1.length; i++) {
      int lastValue = i;
      for (int j = 0; j <= s2.length; j++) {
        if (i == 0) {
          costs[j] = j;
        } else if (j > 0) {
          int newValue = costs[j - 1];
          if (s1[i - 1] != s2[j - 1]) {
            newValue = [newValue, lastValue, costs[j]].reduce((a, b) => a < b ? a : b) + 1;
          }
          costs[j - 1] = lastValue;
          lastValue = newValue;
        }
      }
      if (i > 0) costs[s2.length] = lastValue;
    }

    return costs[s2.length];
  }

  /// Get suggestion text for a feature
  static String getSuggestionText(AppFeature feature) {
    switch (feature) {
      case AppFeature.reportTrafficJam:
        return 'Thử: "báo tắc đường", "kẹt xe", "đường tắc"';
      case AppFeature.reportWaterlogging:
        return 'Thử: "báo ngập nước", "ngập úng", "nước ngập"';
      case AppFeature.reportAccident:
        return 'Thử: "báo tai nạn", "va chạm"';
      case AppFeature.findRestaurants:
        return 'Thử: "tìm quán ăn", "ăn gì", "quán ăn gần đây"';
      case AppFeature.openRestaurantList:
        return 'Thử: "mở quán ăn", "danh sách quán ăn"';
      case AppFeature.openNotifications:
        return 'Thử: "thông báo", "mở thông báo"';
      case AppFeature.openProfile:
        return 'Thử: "profile", "tài khoản", "cá nhân"';
      case AppFeature.unknown:
        return 'Tôi chưa hiểu. Thử một trong các lệnh trên.';
    }
  }
}

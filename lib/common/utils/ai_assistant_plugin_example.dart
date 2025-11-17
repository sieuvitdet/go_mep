import 'package:go_mep_application/common/utils/ai_assistant_plugin.dart';
import 'package:go_mep_application/common/utils/app_feature.dart';

/// Example usage and test cases for AI Assistant Plugin
class AIAssistantPluginExample {
  /// Run all examples
  static void runExamples() {
    print('=== AI Assistant Plugin Examples ===\n');

    _basicUsageExamples();
    _vietnameseWithDiacriticsExamples();
    _fuzzyMatchingExamples();
    _multipleFeatureExamples();
    _confidenceScoreExamples();
  }

  /// Basic usage examples
  static void _basicUsageExamples() {
    print('--- Basic Usage ---');

    final examples = [
      'báo tắc đường',
      'báo ngập nước',
      'báo tai nạn',
      'tìm quán ăn',
      'mở thông báo',
      'mở profile',
    ];

    for (final text in examples) {
      final result = AIAssistantPlugin.recognize(text);
      print('Input: "$text"');
      print('  → Feature: ${result.feature.displayName}');
      print('  → Confidence: ${(result.confidence * 100).toStringAsFixed(0)}%');
      print('  → Keywords: ${result.detectedKeywords}');
      print('');
    }
  }

  /// Vietnamese with diacritics examples
  static void _vietnameseWithDiacriticsExamples() {
    print('--- Vietnamese With/Without Diacritics ---');

    final examples = [
      ['báo tắc đường', 'bao tac duong'],
      ['ngập nước', 'ngap nuoc'],
      ['tai nạn', 'tai nan'],
      ['quán ăn', 'quan an'],
    ];

    for (final pair in examples) {
      final result1 = AIAssistantPlugin.recognize(pair[0]);
      final result2 = AIAssistantPlugin.recognize(pair[1]);

      print('With diacritics: "${pair[0]}" → ${result1.feature.displayName}');
      print('Without: "${pair[1]}" → ${result2.feature.displayName}');
      print('Same feature: ${result1.feature == result2.feature}');
      print('');
    }
  }

  /// Fuzzy matching examples (typos)
  static void _fuzzyMatchingExamples() {
    print('--- Fuzzy Matching (Typos) ---');

    final examples = [
      'bao tac duongg',      // Extra 'g'
      'ngap nuocc',          // Extra 'c'
      'tim quan ann',        // Extra 'n'
      'thog bao',            // Missing 'n'
    ];

    for (final text in examples) {
      final result = AIAssistantPlugin.recognize(text);
      print('Input (with typo): "$text"');
      print('  → Feature: ${result.feature.displayName}');
      print('  → Confidence: ${(result.confidence * 100).toStringAsFixed(0)}%');
      print('  → Detected: ${result.detectedKeywords}');
      print('');
    }
  }

  /// Multiple feature detection examples
  static void _multipleFeatureExamples() {
    print('--- Multiple Feature Detection ---');

    final examples = [
      'tìm quán ăn và mở thông báo',
      'báo tắc đường và tai nạn',
      'mở profile và thông báo',
    ];

    for (final text in examples) {
      final results = AIAssistantPlugin.recognizeMultiple(text);
      print('Input: "$text"');
      print('  → Found ${results.length} features:');
      for (final result in results) {
        print('    • ${result.feature.displayName} (${(result.confidence * 100).toStringAsFixed(0)}%)');
      }
      print('');
    }
  }

  /// Confidence score examples
  static void _confidenceScoreExamples() {
    print('--- Confidence Scores ---');

    final examples = [
      'báo tắc đường',                    // Perfect match
      'tắc',                              // Partial match
      'đường tắc nghẽn giao thông',      // Contains keyword
      'xyz 123 abc',                      // No match
    ];

    for (final text in examples) {
      final result = AIAssistantPlugin.recognize(text);
      print('Input: "$text"');
      print('  → Feature: ${result.feature.displayName}');
      print('  → Confidence: ${(result.confidence * 100).toStringAsFixed(0)}%');
      print('  → Is Confident: ${result.isConfident ? "✅" : "❌"}');
      print('');
    }
  }

  /// Test all features
  static void testAllFeatures() {
    print('=== Testing All Features ===\n');

    final testCases = {
      AppFeature.reportTrafficJam: [
        'báo tắc đường',
        'kẹt xe',
        'traffic jam',
      ],
      AppFeature.reportWaterlogging: [
        'báo ngập nước',
        'ngập úng',
        'waterlogging',
      ],
      AppFeature.reportAccident: [
        'báo tai nạn',
        'va chạm',
        'accident',
      ],
      AppFeature.findRestaurants: [
        'tìm quán ăn',
        'ăn gì',
        'find restaurant',
      ],
      AppFeature.openRestaurantList: [
        'mở quán ăn',
        'danh sách quán ăn',
        'restaurant list',
      ],
      AppFeature.openNotifications: [
        'mở thông báo',
        'thông báo',
        'notifications',
      ],
      AppFeature.openProfile: [
        'mở profile',
        'tài khoản',
        'my account',
      ],
    };

    for (final entry in testCases.entries) {
      final feature = entry.key;
      final testInputs = entry.value;

      print('Testing: ${feature.displayName}');

      for (final input in testInputs) {
        final result = AIAssistantPlugin.recognize(input);
        final passed = result.feature == feature && result.isConfident;

        print('  "${input}" → ${passed ? "✅ PASS" : "❌ FAIL"} (${(result.confidence * 100).toStringAsFixed(0)}%)');
      }

      print('');
    }
  }

  /// Benchmark performance
  static void benchmarkPerformance() {
    print('=== Performance Benchmark ===\n');

    final testInputs = [
      'báo tắc đường',
      'tìm quán ăn',
      'mở thông báo',
      'xyz abc 123',
    ];

    final iterations = 1000;

    for (final input in testInputs) {
      final stopwatch = Stopwatch()..start();

      for (int i = 0; i < iterations; i++) {
        AIAssistantPlugin.recognize(input);
      }

      stopwatch.stop();

      final avgTime = stopwatch.elapsedMicroseconds / iterations;
      print('Input: "$input"');
      print('  → Avg time: ${avgTime.toStringAsFixed(2)} μs');
      print('  → ${iterations} iterations in ${stopwatch.elapsedMilliseconds}ms');
      print('');
    }
  }

  /// Print all supported keywords
  static void printAllKeywords() {
    print('=== All Supported Keywords ===\n');

    final features = [
      AppFeature.reportTrafficJam,
      AppFeature.reportWaterlogging,
      AppFeature.reportAccident,
      AppFeature.findRestaurants,
      AppFeature.openRestaurantList,
      AppFeature.openNotifications,
      AppFeature.openProfile,
    ];

    for (final feature in features) {
      print('${feature.displayName}:');
      print('  ${AIAssistantPlugin.getSuggestionText(feature)}');
      print('');
    }
  }
}

/// Run this file to see examples
void main() {
  AIAssistantPluginExample.runExamples();
  print('\n');
  AIAssistantPluginExample.testAllFeatures();
  print('\n');
  AIAssistantPluginExample.benchmarkPerformance();
  print('\n');
  AIAssistantPluginExample.printAllKeywords();
}

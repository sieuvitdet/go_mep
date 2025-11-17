# AI Assistant Plugin

Plugin nhận diện lệnh tiếng Việt và thực hiện action tương ứng trong ứng dụng Go Mep.

## Tính Năng

Plugin hỗ trợ nhận diện các tính năng sau:

1. **Báo Tắc Đường** - Report traffic jam
2. **Báo Ngập Nước** - Report waterlogging/flood
3. **Báo Tai Nạn** - Report accident
4. **Tìm Quán Ăn** - Search restaurants
5. **Mở Danh Sách Quán Ăn** - Open restaurant list
6. **Mở Thông Báo** - Open notifications
7. **Mở Profile** - Open user profile

## Cấu Trúc

### 1. Enum Features (app_feature.dart)

```dart
enum AppFeature {
  reportTrafficJam,      // Báo tắc đường
  reportWaterlogging,    // Báo ngập nước
  reportAccident,        // Báo tai nạn
  findRestaurants,       // Tìm quán ăn
  openRestaurantList,    // Mở danh sách quán ăn
  openNotifications,     // Mở thông báo
  openProfile,           // Mở profile
  unknown;               // Không xác định
}
```

### 2. AI Assistant Plugin (ai_assistant_plugin.dart)

**Nhận diện lệnh từ text:**

```dart
// Nhận diện single feature
final result = AIAssistantPlugin.recognize("báo tắc đường");
print(result.feature);        // AppFeature.reportTrafficJam
print(result.confidence);     // 1.0
print(result.isConfident);    // true

// Nhận diện multiple features
final results = AIAssistantPlugin.recognizeMultiple("tìm quán ăn và mở thông báo");
// Returns list of FeatureRecognitionResult
```

### 3. Action Handler (feature_action_handler.dart)

**Xử lý action cho feature:**

```dart
// Handle single feature
FeatureActionHandler.handleFeature(
  context,
  result,
  onAction: (feature, params) {
    // Custom action
    print('Execute: ${feature.displayName}');
  },
);

// Handle multiple features
FeatureActionHandler.handleMultipleFeatures(
  context,
  results,
  onAction: (feature, params) {
    // Custom action for each feature
  },
);
```

## Cách Sử Dụng

### 1. Sử Dụng Đơn Giản

```dart
import 'package:go_mep_application/common/utils/ai_assistant_plugin.dart';
import 'package:go_mep_application/common/utils/feature_action_handler.dart';

void handleUserInput(BuildContext context, String text) {
  // Nhận diện feature
  final result = AIAssistantPlugin.recognize(text);

  // Xử lý action
  final response = FeatureActionHandler.handleFeature(context, result);

  print(response); // Response text for user
}

// Ví dụ
handleUserInput(context, "báo tắc đường");
handleUserInput(context, "tìm quán ăn");
handleUserInput(context, "mở thông báo");
```

### 2. Với Custom Action

```dart
void handleWithCustomAction(BuildContext context, String text) {
  final result = AIAssistantPlugin.recognize(text);

  FeatureActionHandler.handleFeature(
    context,
    result,
    onAction: (feature, params) {
      switch (feature) {
        case AppFeature.reportTrafficJam:
          Navigator.pushNamed(context, '/report-traffic-jam');
          break;
        case AppFeature.findRestaurants:
          Navigator.pushNamed(context, '/restaurants');
          break;
        case AppFeature.openNotifications:
          Navigator.pushNamed(context, '/notifications');
          break;
        case AppFeature.openProfile:
          Navigator.pushNamed(context, '/profile');
          break;
        default:
          break;
      }
    },
  );
}
```

### 3. Sử Dụng Widget Example

```dart
import 'package:go_mep_application/common/widgets/ai_assistant_widget.dart';

// Navigate to AI Assistant screen
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const AIAssistantWidget()),
);
```

## Từ Khóa Nhận Diện

### Báo Tắc Đường
- tắc đường, tac duong
- kẹt xe, ket xe
- tắc nghẽn, tac nghen
- báo tắc, bao tac
- traffic jam, traffic

### Báo Ngập Nước
- ngập nước, ngap nuoc
- ngập úng, ngap ung
- báo ngập, bao ngap
- nước ngập, nuoc ngap
- flood, flooding, waterlogging

### Báo Tai Nạn
- tai nạn, tai nan
- báo tai nạn, bao tai nan
- va chạm, va cham
- đụng xe, dung xe
- accident, crash

### Tìm Quán Ăn
- tìm quán ăn, tim quan an
- tìm quán, tim quan
- quán ăn gần đây
- ăn gì, an gi
- find restaurant, search restaurant

### Mở Quán Ăn
- mở quán ăn, mo quan an
- danh sách quán ăn
- xem quán ăn
- restaurant list

### Mở Thông Báo
- thông báo, thong bao
- mở thông báo
- notifications

### Mở Profile
- profile
- tài khoản, tai khoan
- cá nhân, ca nhan
- my account, my profile

## Đặc Điểm

### 1. Hỗ Trợ Tiếng Việt Có Dấu & Không Dấu
```dart
AIAssistantPlugin.recognize("báo tắc đường");  // ✅
AIAssistantPlugin.recognize("bao tac duong");  // ✅
```

### 2. Fuzzy Matching (Chịu lỗi chính tả)
```dart
AIAssistantPlugin.recognize("bao tac duongg");  // ✅ Still works
AIAssistantPlugin.recognize("ngap nuoc");       // ✅ Still works
```

### 3. Confidence Score
```dart
final result = AIAssistantPlugin.recognize("tìm quán");
print(result.confidence);  // 0.9 (high confidence)

if (result.isConfident) {  // >= 0.7
  // Execute action
}
```

### 4. Multiple Feature Detection
```dart
final results = AIAssistantPlugin.recognizeMultiple(
  "tìm quán ăn và mở thông báo"
);
// Returns 2 features: findRestaurants, openNotifications
```

## API Reference

### AIAssistantPlugin

#### Methods:
- `recognize(String input)` → `FeatureRecognitionResult`
- `recognizeMultiple(String input)` → `List<FeatureRecognitionResult>`
- `getSuggestionText(AppFeature feature)` → `String`

### FeatureRecognitionResult

#### Properties:
- `feature` → `AppFeature` - Recognized feature
- `confidence` → `double` - Confidence score (0.0 - 1.0)
- `detectedKeywords` → `String?` - Keywords that matched
- `parameters` → `Map<String, dynamic>?` - Optional parameters
- `isConfident` → `bool` - True if confidence >= 0.7

### FeatureActionHandler

#### Methods:
- `handleFeature(context, result, {onAction})` → `String`
- `handleMultipleFeatures(context, results, {onAction})` → `String`

## Ví Dụ Thực Tế

### TextField với AI Recognition

```dart
TextField(
  decoration: InputDecoration(
    hintText: 'Nhập lệnh: báo tắc đường, tìm quán ăn...',
  ),
  onSubmitted: (text) {
    final result = AIAssistantPlugin.recognize(text);

    if (result.isConfident) {
      FeatureActionHandler.handleFeature(context, result);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không hiểu: $text')),
      );
    }
  },
)
```

### Voice Command Integration

```dart
// After speech-to-text
void onSpeechResult(String spokenText) {
  final result = AIAssistantPlugin.recognize(spokenText);

  print('You said: $spokenText');
  print('I recognized: ${result.feature.displayName}');

  FeatureActionHandler.handleFeature(context, result);
}
```

### Chat Bot Interface

```dart
void onChatMessage(String message) {
  final results = AIAssistantPlugin.recognizeMultiple(message);

  if (results.isEmpty) {
    _addBotMessage('Xin lỗi, tôi chưa hiểu.');
  } else if (results.length == 1) {
    FeatureActionHandler.handleFeature(context, results.first);
  } else {
    FeatureActionHandler.handleMultipleFeatures(context, results);
  }
}
```

## Testing

### Test Cases

```dart
// Test exact match
final result1 = AIAssistantPlugin.recognize("báo tắc đường");
assert(result1.feature == AppFeature.reportTrafficJam);
assert(result1.confidence == 1.0);

// Test fuzzy match
final result2 = AIAssistantPlugin.recognize("bao tac duong");
assert(result2.feature == AppFeature.reportTrafficJam);
assert(result2.confidence >= 0.7);

// Test unknown
final result3 = AIAssistantPlugin.recognize("xyz abc 123");
assert(result3.feature == AppFeature.unknown);
assert(result3.confidence == 0.0);

// Test multiple
final results = AIAssistantPlugin.recognizeMultiple("tìm quán ăn và mở thông báo");
assert(results.length == 2);
assert(results[0].feature == AppFeature.findRestaurants);
assert(results[1].feature == AppFeature.openNotifications);
```

## Notes

- ✅ Hỗ trợ tiếng Việt có dấu & không dấu
- ✅ Fuzzy matching cho lỗi chính tả
- ✅ Multiple feature detection
- ✅ Confidence scoring
- ✅ Extensible - dễ thêm feature mới
- ✅ No external dependencies
- ⚠️ Cần customize action handler theo navigation của app
- ⚠️ Có thể mở rộng thêm keywords trong `_featureKeywords`

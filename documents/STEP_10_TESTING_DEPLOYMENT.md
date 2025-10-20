# Step 10: Testing, Optimization & Deployment

## Overview
This final step focuses on comprehensive testing, performance optimization, code quality assurance, and preparing the application for production deployment. This includes unit testing, widget testing, integration testing, optimization, and app store submission preparation.

## Duration
**5-7 days**

## Status
**⏳ Pending**

## Dependencies
- All previous steps (1-9) completed

## Objectives
- Write comprehensive unit tests
- Implement widget tests
- Create integration tests
- Optimize app performance
- Reduce app size
- Improve startup time
- Fix memory leaks
- Conduct security audit
- Prepare production builds
- Create app store listings
- Submit to app stores
- Set up monitoring and analytics

---

## Testing Strategy

### 1. Unit Testing

#### BLoC Testing Example:
```dart
// test/bloc/login_bloc_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:go_mep_application/presentation/auth/login/bloc/login_bloc.dart';

void main() {
  group('LoginBloc Tests', () {
    late LoginBloc bloc;

    setUp(() {
      bloc = LoginBloc(MockBuildContext());
    });

    tearDown(() {
      bloc.dispose();
    });

    test('Initial state should be not loading', () {
      expect(bloc.streamIsLoading.value, false);
    });

    test('Login with empty credentials should fail', () async {
      await bloc.login('', '');

      expect(bloc.streamError.value, isNotNull);
      expect(bloc.streamError.value, contains('Please enter'));
    });

    test('Login with valid credentials should succeed', () async {
      // Mock successful API response
      when(mockRepository.login(any, any))
          .thenAnswer((_) async => ResponseModel(success: true));

      await bloc.login('validuser', 'validpass');

      expect(bloc.streamIsLoading.value, false);
      expect(bloc.streamError.value, isNull);
    });

    test('Login should emit loading states correctly', () async {
      expectLater(
        bloc.streamIsLoading,
        emitsInOrder([false, true, false]),
      );

      await bloc.login('user', 'pass');
    });
  });
}
```

#### Utility Function Testing:
```dart
// test/utils/utility_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:go_mep_application/common/utils/utility.dart';

void main() {
  group('Utility Tests', () {
    test('Valid email should return true', () {
      expect(Utility.isValidEmail('test@example.com'), true);
      expect(Utility.isValidEmail('user.name@domain.co.uk'), true);
    });

    test('Invalid email should return false', () {
      expect(Utility.isValidEmail('invalid'), false);
      expect(Utility.isValidEmail('test@'), false);
      expect(Utility.isValidEmail('@example.com'), false);
    });

    test('Valid phone should return true', () {
      expect(Utility.isValidPhone('0123456789'), true);
      expect(Utility.isValidPhone('0987654321'), true);
    });

    test('Invalid phone should return false', () {
      expect(Utility.isValidPhone('123'), false);
      expect(Utility.isValidPhone('abcdefghij'), false);
    });

    test('Format date should return correct format', () {
      final date = DateTime(2025, 10, 20);
      expect(Utility.formatDate(date), '20-10-2025');
    });

    test('Format time should return correct format', () {
      final time = DateTime(2025, 10, 20, 14, 30);
      expect(Utility.formatTime(time), '14:30');
    });
  });
}
```

#### Model Testing:
```dart
// test/model/user_model_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:go_mep_application/data/model/res/user_me_res_model.dart';

void main() {
  group('UserMeResModel Tests', () {
    test('Should parse from JSON correctly', () {
      final json = {
        'id': '123',
        'username': 'testuser',
        'email': 'test@example.com',
        'fullName': 'Test User',
        'phoneNumber': '0123456789',
      };

      final user = UserMeResModel.fromJson(json);

      expect(user.id, '123');
      expect(user.username, 'testuser');
      expect(user.email, 'test@example.com');
      expect(user.fullName, 'Test User');
      expect(user.phoneNumber, '0123456789');
    });

    test('Should handle null values gracefully', () {
      final json = {'id': '123'};
      final user = UserMeResModel.fromJson(json);

      expect(user.id, '123');
      expect(user.username, isNull);
      expect(user.email, isNull);
    });
  });
}
```

---

### 2. Widget Testing

#### Button Widget Test:
```dart
// test/widget/responsive_button_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_mep_application/common/widgets/figma_button.dart';

void main() {
  group('ResponsiveButton Tests', () {
    testWidgets('Button displays text correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveButton(
              text: 'Test Button',
              type: FigmaButtonType.primary,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Test Button'), findsOneWidget);
    });

    testWidgets('Button triggers callback on tap', (tester) async {
      bool wasPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveButton(
              text: 'Test Button',
              type: FigmaButtonType.primary,
              onPressed: () {
                wasPressed = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ResponsiveButton));
      await tester.pumpAndSettle();

      expect(wasPressed, true);
    });

    testWidgets('Button shows loading indicator when loading', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveButton(
              text: 'Test Button',
              type: FigmaButtonType.primary,
              onPressed: () {},
              isLoading: true,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Test Button'), findsNothing);
    });

    testWidgets('Button is disabled when loading', (tester) async {
      bool wasPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveButton(
              text: 'Test Button',
              type: FigmaButtonType.primary,
              onPressed: () {
                wasPressed = true;
              },
              isLoading: true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ResponsiveButton));
      await tester.pumpAndSettle();

      expect(wasPressed, false);
    });
  });
}
```

#### Input Field Widget Test:
```dart
// test/widget/responsive_input_field_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_mep_application/common/widgets/figma_input_field.dart';

void main() {
  group('ResponsiveInputField Tests', () {
    testWidgets('Input field displays hint text', (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveInputField(
              hintText: 'Enter text',
              controller: controller,
            ),
          ),
        ),
      );

      expect(find.text('Enter text'), findsOneWidget);
    });

    testWidgets('Input field accepts text input', (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveInputField(
              hintText: 'Enter text',
              controller: controller,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'Test input');
      expect(controller.text, 'Test input');
    });

    testWidgets('Input field validates correctly', (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveInputField(
              hintText: 'Email',
              controller: controller,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                }
                return null;
              },
            ),
          ),
        ),
      );

      // Test validation with empty input
      final formState = tester.state<FormFieldState>(
        find.byType(TextFormField),
      );
      formState.validate();
      await tester.pumpAndSettle();

      expect(find.text('Required'), findsOneWidget);
    });
  });
}
```

---

### 3. Integration Testing

#### Login Flow Integration Test:
```dart
// integration_test/login_flow_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:go_mep_application/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Login Flow Integration Tests', () {
    testWidgets('Complete login flow', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify we're on login screen
      expect(find.text('Login'), findsOneWidget);

      // Enter credentials
      await tester.enterText(
        find.byType(TextField).first,
        'testuser',
      );
      await tester.enterText(
        find.byType(TextField).last,
        'password123',
      );

      // Tap login button
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle(Duration(seconds: 5));

      // Verify navigation to home screen
      expect(find.text('Go Mep'), findsOneWidget);
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    testWidgets('Login with invalid credentials shows error', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Enter invalid credentials
      await tester.enterText(
        find.byType(TextField).first,
        'invalid',
      );
      await tester.enterText(
        find.byType(TextField).last,
        'wrong',
      );

      // Tap login button
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle(Duration(seconds: 3));

      // Verify error message shown
      expect(find.textContaining('failed'), findsOneWidget);
    });
  });
}
```

#### Navigation Flow Test:
```dart
// integration_test/navigation_flow_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:go_mep_application/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Navigation Flow Tests', () {
    testWidgets('Navigate between all tabs', (tester) async {
      // Login first
      await loginUser(tester);

      // Verify home tab
      expect(find.text('Latest Updates'), findsOneWidget);

      // Navigate to Map tab
      await tester.tap(find.text('Map'));
      await tester.pumpAndSettle();
      expect(find.byType(GoogleMap), findsOneWidget);

      // Navigate to Notifications tab
      await tester.tap(find.text('Notifications'));
      await tester.pumpAndSettle();
      expect(find.text('Notifications'), findsOneWidget);

      // Navigate to Account tab
      await tester.tap(find.text('Account'));
      await tester.pumpAndSettle();
      expect(find.text('Personal Information'), findsOneWidget);

      // Navigate back to Home
      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();
      expect(find.text('Latest Updates'), findsOneWidget);
    });
  });
}
```

---

## Performance Optimization

### 1. Image Optimization

```dart
// Compress images before upload
Future<File> compressImage(File file) async {
  final result = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path,
    '${file.parent.path}/compressed_${file.path.split('/').last}',
    quality: 80,
    minWidth: 1024,
    minHeight: 1024,
  );
  return File(result!.path);
}

// Use cached network images
CachedNetworkImage(
  imageUrl: url,
  placeholder: (context, url) => Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Container(color: Colors.white),
  ),
  errorWidget: (context, url, error) => Icon(Icons.error),
  fadeInDuration: Duration(milliseconds: 300),
  memCacheHeight: 400,
  memCacheWidth: 400,
);
```

### 2. List Rendering Optimization

```dart
// Use ListView.builder for long lists
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ListItem(item: items[index]);
  },
  // Add cache extent for smooth scrolling
  cacheExtent: 100,
);

// Use AutomaticKeepAliveClientMixin for tabs
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Important!
    return Container();
  }
}
```

### 3. Memory Leak Prevention

```dart
// Always dispose streams in BLoC
class MyBloc {
  final streamData = BehaviorSubject<Data>();

  void dispose() {
    streamData.close(); // Important!
  }
}

// Cancel subscriptions
class MyScreen extends StatefulWidget {
  @override
  _MyScreenState createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  StreamSubscription? subscription;

  @override
  void initState() {
    super.initState();
    subscription = stream.listen((data) {});
  }

  @override
  void dispose() {
    subscription?.cancel(); // Important!
    super.dispose();
  }
}
```

### 4. Build Time Optimization

```dart
// Use const constructors where possible
const Text('Hello');
const Icon(Icons.home);
const SizedBox(height: 16);

// Extract widgets to reduce rebuilds
class ExpensiveWidget extends StatelessWidget {
  const ExpensiveWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(); // Expensive widget
  }
}

// Use RepaintBoundary for complex widgets
RepaintBoundary(
  child: ComplexWidget(),
);
```

---

## Build Configuration

### 1. Production Build Commands

#### Android:
```bash
# Build APK
flutter build apk --release --obfuscate --split-debug-info=build/debug-info

# Build App Bundle (for Google Play)
flutter build appbundle --release --obfuscate --split-debug-info=build/debug-info

# Build for specific architecture
flutter build apk --release --target-platform android-arm64
```

#### iOS:
```bash
# Build iOS
flutter build ios --release --obfuscate --split-debug-info=build/debug-info

# Create IPA
flutter build ipa --release --obfuscate --split-debug-info=build/debug-info
```

### 2. App Size Reduction

```bash
# Analyze app size
flutter build apk --analyze-size

# Remove unused resources
flutter pub run flutter_native_splash:remove
flutter clean

# Use split APKs
flutter build apk --release --split-per-abi
```

---

## Deployment Checklist

### Pre-Deployment:
- [ ] All features tested and working
- [ ] No critical bugs
- [ ] Performance optimized
- [ ] App size under target (< 50MB)
- [ ] Startup time under 3 seconds
- [ ] All API endpoints point to production
- [ ] Security audit completed
- [ ] Privacy policy updated
- [ ] Terms of service updated

### Android (Google Play):
- [ ] App signed with release key
- [ ] Version code incremented
- [ ] Version name updated
- [ ] App bundle generated
- [ ] Screenshots prepared (phone, tablet)
- [ ] Feature graphic created
- [ ] App description written
- [ ] Privacy policy link added
- [ ] Content rating completed
- [ ] Store listing created
- [ ] App submitted for review

### iOS (App Store):
- [ ] App signed with distribution certificate
- [ ] Build number incremented
- [ ] Version number updated
- [ ] IPA file generated
- [ ] Screenshots prepared (all device sizes)
- [ ] App preview video created (optional)
- [ ] App description written
- [ ] Keywords selected
- [ ] Privacy policy link added
- [ ] App category selected
- [ ] Age rating completed
- [ ] App Store listing created
- [ ] App submitted for review

---

## Monitoring & Analytics

### 1. Crash Monitoring Setup

```dart
// Setup Firebase Crashlytics
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Pass all uncaught errors to Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  runZonedGuarded(() {
    runApp(MyApp());
  }, (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack);
  });
}

// Log custom errors
try {
  await riskyOperation();
} catch (e, stack) {
  await FirebaseCrashlytics.instance.recordError(
    e,
    stack,
    reason: 'Failed to perform risky operation',
  );
}
```

### 2. Analytics Setup

```dart
// Setup Firebase Analytics
class Analytics {
  static final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  static Future<void> logEvent({
    required String name,
    Map<String, dynamic>? parameters,
  }) async {
    await analytics.logEvent(
      name: name,
      parameters: parameters,
    );
  }

  static Future<void> logScreenView({
    required String screenName,
  }) async {
    await analytics.logScreenView(
      screenName: screenName,
    );
  }

  static Future<void> setUserId(String userId) async {
    await analytics.setUserId(id: userId);
  }
}

// Usage
Analytics.logScreenView(screenName: 'HomeScreen');
Analytics.logEvent(
  name: 'restaurant_search',
  parameters: {'query': 'pizza'},
);
```

---

## Testing Commands

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Generate coverage report
genhtml coverage/lcov.info -o coverage/html

# Run integration tests
flutter test integration_test/

# Run specific test file
flutter test test/bloc/login_bloc_test.dart

# Run tests in watch mode
flutter test --watch
```

---

## CI/CD Pipeline (Future)

```yaml
# .github/workflows/flutter.yml
name: Flutter CI

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test --coverage

  build:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter build apk --release
      - uses: actions/upload-artifact@v2
        with:
          name: release-apk
          path: build/app/outputs/flutter-apk/app-release.apk
```

---

## Key Deliverables

⏳ **Unit Tests**: Comprehensive test coverage for BLoCs and utilities
⏳ **Widget Tests**: UI component testing
⏳ **Integration Tests**: End-to-end flow testing
⏳ **Performance Optimized**: Fast startup, smooth scrolling
⏳ **App Size Optimized**: Under target size
⏳ **Production Builds**: Release builds for Android and iOS
⏳ **Store Listings**: Complete store presence
⏳ **Monitoring Setup**: Crash and analytics tracking
⏳ **Documentation**: Technical and user documentation
⏳ **App Submitted**: To Google Play and App Store

---

## Success Metrics

⏳ Test coverage > 70%
⏳ App size < 50MB
⏳ Startup time < 3 seconds
⏳ Zero critical bugs
⏳ Smooth 60fps scrolling
⏳ No memory leaks
⏳ Successful store submissions
⏳ 4.5+ star rating target
⏳ Monitoring active
⏳ Analytics tracking working

---

**Step Status**: ⏳ Pending
**Project Completion**: Ready for production release after this step

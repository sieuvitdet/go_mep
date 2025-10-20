# Step 2: Core Architecture & Design System Implementation

## Overview
This step establishes the application's architectural foundation using the BLoC (Business Logic Component) pattern and creates a comprehensive design system based on Figma specifications. This ensures consistent, maintainable, and scalable code throughout the application.

## Duration
**3-5 days**

## Status
**✓ Completed**

## Dependencies
- Step 1: Project Setup (completed)

## Objectives
- Implement BLoC pattern for state management
- Create organized folder structure
- Build theme system with Figma colors
- Implement typography system
- Create reusable widget library
- Set up internationalization framework
- Configure responsive design system

---

## Tasks Completed

### 1. Folder Structure Organization

#### Created Directory Structure:
```
lib/
├── common/
│   ├── lang_key/              # Language key constants
│   │   └── lang_key.dart
│   ├── localization/          # Internationalization
│   │   ├── app_localizations.dart
│   │   └── localizations_config.dart
│   ├── theme/                 # Theme system
│   │   ├── globals/
│   │   │   ├── globals.dart
│   │   │   ├── config.dart
│   │   │   └── theme_provider.dart
│   │   ├── app_colors.dart
│   │   ├── app_dimens.dart
│   │   ├── app_format.dart
│   │   ├── app_text_styles.dart
│   │   ├── figma_colors.dart
│   │   └── constant/
│   │       └── constant.dart
│   ├── utils/                 # Utility functions
│   │   ├── custom_navigator.dart
│   │   ├── device_id.dart
│   │   ├── hex_color.dart
│   │   ├── utility.dart
│   │   ├── progress_dialog.dart
│   │   ├── permission_request.dart
│   │   ├── currency_input_formatter.dart
│   │   └── rsa_encryption_helper.dart
│   └── widgets/               # Reusable widgets
│       ├── custom_button.dart
│       ├── custom_textfield.dart
│       ├── custom_appbar.dart
│       ├── custom_dialog.dart
│       ├── custom_scaffold.dart
│       ├── figma_button.dart
│       ├── figma_input_field.dart
│       ├── figma_logo.dart
│       ├── responsive_container.dart
│       └── ... (30+ widgets)
│
├── data/
│   ├── local/
│   │   └── shared_prefs/
│   │       ├── shared_prefs.dart
│   │       └── shared_prefs_key.dart
│   ├── model/
│   │   ├── req/              # Request models
│   │   └── res/              # Response models
│   ├── user_account.dart
│   └── user_data.dart
│
├── net/
│   ├── api/
│   │   ├── api.dart
│   │   └── interaction.dart
│   ├── http/
│   │   ├── http_connection.dart
│   │   └── http_status_code.dart
│   ├── repository/
│   │   └── repository.dart
│   └── network_connectivity.dart
│
├── presentation/
│   ├── auth/                 # Authentication screens
│   ├── base/                 # Main app screens
│   ├── boarding/             # Onboarding
│   └── main/                 # Main navigation
│
└── main.dart
```

---

### 2. BLoC Pattern Implementation

#### Core BLoC Structure:
```dart
// Example BLoC pattern implementation
class FeatureBloc {
  late BuildContext context;

  // Streams for state management
  final streamData = BehaviorSubject<DataModel?>();
  final streamIsLoading = BehaviorSubject<bool>();
  final streamError = BehaviorSubject<String?>();

  FeatureBloc(BuildContext context) {
    this.context = context;
    streamIsLoading.add(false);
  }

  // Business logic methods
  Future<void> loadData() async {
    streamIsLoading.add(true);

    try {
      // API calls and data processing
      final result = await fetchData();
      streamData.add(result);
    } catch (e) {
      streamError.add(e.toString());
    }

    streamIsLoading.add(false);
  }

  void dispose() {
    streamData.close();
    streamIsLoading.close();
    streamError.close();
  }
}
```

#### BLoC Usage in UI:
```dart
// StreamBuilder pattern for reactive UI
StreamBuilder<DataModel?>(
  stream: bloc.streamData,
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      return DataWidget(data: snapshot.data!);
    }
    return LoadingWidget();
  },
)
```

#### Key BLoC Principles Applied:
1. **Separation of Concerns**: Business logic separated from UI
2. **Stream-based State Management**: RxDart BehaviorSubject for state
3. **Minimal setState**: Avoid setState, use streams instead
4. **Proper Disposal**: Always close streams in dispose()

---

### 3. Theme System Implementation

#### A. Figma Colors (figma_colors.dart):
```dart
class FigmaColors {
  // Primary Colors
  static const Color primaryBlue = Color(0xFF3478F6);
  static const Color primaryYellow = Color(0xFFFFD700);

  // Background Colors
  static const Color backgroundPrimary = Color(0xFFFFFFFF);
  static const Color backgroundSecondary = Color(0xFFF5F5F5);
  static const Color backgroundDark = Color(0xFF1A1A1A);

  // Text Colors
  static const Color textPrimary = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textHint = Color(0xFF999999);

  // Accent Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFFF3B30);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF2196F3);

  // Dimensions
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;
  static const double spacingXLarge = 32.0;
}
```

#### B. App Colors (app_colors.dart):
```dart
class AppColors {
  // Dynamic color based on theme
  static Color getBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? FigmaColors.backgroundDark
        : FigmaColors.backgroundPrimary;
  }

  static Color getTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : FigmaColors.textPrimary;
  }

  static Color getBackgroundCard(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color(0xFF2A2A2A)
        : Colors.white;
  }

  // Static colors
  static const Color primary = FigmaColors.primaryBlue;
  static const Color accent = FigmaColors.primaryYellow;
  static const Color success = FigmaColors.success;
  static const Color error = FigmaColors.error;
  static const Color warning = FigmaColors.warning;
  static const Color hint = FigmaColors.textHint;
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color greyLight = Color(0xFFF5F5F5);
}
```

#### C. Theme Provider (theme_provider.dart):
```dart
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    notifyListeners();
  }

  void setTheme(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }
}
```

---

### 4. Typography System (app_text_styles.dart)

```dart
class AppTextStyles {
  // Heading Styles
  static TextStyle get h1 => TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );

  static TextStyle get h2 => TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    height: 1.3,
  );

  static TextStyle get h3 => TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  // Body Styles
  static TextStyle get bodyLarge => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  static TextStyle get bodyMedium => TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  static TextStyle get bodySmall => TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  // Button Styles
  static TextStyle get button => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  // Caption Style
  static TextStyle get caption => TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.hint,
  );
}
```

---

### 5. Responsive Dimensions (app_dimens.dart)

```dart
class AppSizes {
  static late double maxWidth;
  static late double maxHeight;

  // Initialize with context
  static void init(BuildContext context) {
    maxWidth = MediaQuery.of(context).size.width;
    maxHeight = MediaQuery.of(context).size.height;
  }

  // Spacing
  static const double tiny = 4.0;
  static const double small = 8.0;
  static const double regular = 12.0;
  static const double medium = 16.0;
  static const double semiMedium = 20.0;
  static const double large = 24.0;
  static const double xLarge = 32.0;
  static const double xxLarge = 48.0;

  // Border Radius
  static const double radiusSmall = 4.0;
  static const double radiusMedium = 8.0;
  static const double radiusLarge = 12.0;
  static const double radiusXLarge = 16.0;
  static const double radiusCircle = 999.0;

  // Icon Sizes
  static const double iconSmall = 16.0;
  static const double iconMedium = 24.0;
  static const double iconLarge = 32.0;
  static const double iconXLarge = 48.0;
}
```

---

### 6. Reusable Widget Library

#### A. Custom Button (figma_button.dart):
```dart
enum FigmaButtonType { primary, secondary, outlined, text }

class ResponsiveButton extends StatelessWidget {
  final String text;
  final FigmaButtonType type;
  final VoidCallback onPressed;
  final bool isLoading;
  final double? width;
  final double? height;

  const ResponsiveButton({
    Key? key,
    required this.text,
    required this.type,
    required this.onPressed,
    this.isLoading = false,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 48,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: _getButtonStyle(),
        child: isLoading
            ? CircularProgressIndicator(color: Colors.white)
            : Text(text, style: AppTextStyles.button),
      ),
    );
  }

  ButtonStyle _getButtonStyle() {
    switch (type) {
      case FigmaButtonType.primary:
        return ElevatedButton.styleFrom(
          backgroundColor: FigmaColors.primaryBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          ),
        );
      case FigmaButtonType.secondary:
        return ElevatedButton.styleFrom(
          backgroundColor: FigmaColors.backgroundSecondary,
          foregroundColor: FigmaColors.textPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          ),
        );
      // ... other types
      default:
        return ElevatedButton.styleFrom();
    }
  }
}
```

#### B. Custom Text Field (figma_input_field.dart):
```dart
class ResponsiveInputField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final FormFieldValidator<String>? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const ResponsiveInputField({
    Key? key,
    required this.hintText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      style: AppTextStyles.bodyMedium,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.hint,
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: FigmaColors.backgroundSecondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSizes.medium,
          vertical: AppSizes.medium,
        ),
      ),
    );
  }
}
```

#### C. Responsive Container (responsive_container.dart):
```dart
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;

  const ResponsiveContainer({
    Key? key,
    required this.child,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.symmetric(
        horizontal: AppSizes.medium,
      ),
      constraints: BoxConstraints(
        maxWidth: 600, // Max width for tablets
      ),
      child: child,
    );
  }
}
```

#### D. Custom Gaps Widget (gaps_widget.dart):
```dart
class Gaps {
  static const Widget vGap4 = SizedBox(height: 4);
  static const Widget vGap8 = SizedBox(height: 8);
  static const Widget vGap12 = SizedBox(height: 12);
  static const Widget vGap16 = SizedBox(height: 16);
  static const Widget vGap20 = SizedBox(height: 20);
  static const Widget vGap24 = SizedBox(height: 24);
  static const Widget vGap32 = SizedBox(height: 32);

  static const Widget hGap4 = SizedBox(width: 4);
  static const Widget hGap8 = SizedBox(width: 8);
  static const Widget hGap12 = SizedBox(width: 12);
  static const Widget hGap16 = SizedBox(width: 16);
  static const Widget hGap20 = SizedBox(width: 20);
  static const Widget hGap24 = SizedBox(width: 24);
  static const Widget hGap32 = SizedBox(width: 32);
}
```

---

### 7. Internationalization Setup

#### A. Localization Config (localizations_config.dart):
```dart
class LocalizationsConfig {
  static const List<Locale> supportedLocales = [
    Locale('vi', ''), // Vietnamese
    Locale('en', ''), // English
    Locale('zh', ''), // Chinese
  ];

  static Locale getCurrentLocale() {
    // Get from SharedPreferences or return default
    String? languageCode = SharedPrefs.getLanguage();
    return Locale(languageCode ?? 'vi');
  }

  static void setLocale(String languageCode) {
    SharedPrefs.setLanguage(languageCode);
  }
}
```

#### B. Language Keys (lang_key.dart):
```dart
class LangKey {
  // Authentication
  static const String login = 'login';
  static const String logout = 'logout';
  static const String email = 'email';
  static const String password = 'password';
  static const String forgotPassword = 'forgot_password';

  // Common
  static const String save = 'save';
  static const String cancel = 'cancel';
  static const String confirm = 'confirm';
  static const String delete = 'delete';
  static const String edit = 'edit';

  // Notifications
  static const String notifications = 'notifications';
  static const String noNotifications = 'no_notifications';

  // Errors
  static const String errorOccurred = 'error_occurred';
  static const String networkError = 'network_error';
  static const String invalidInput = 'invalid_input';
}
```

#### C. App Localizations (app_localizations.dart):
```dart
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  // Translation maps
  static Map<String, Map<String, String>> _localizedValues = {
    'vi': {
      'login': 'Đăng nhập',
      'logout': 'Đăng xuất',
      'email': 'Email',
      'password': 'Mật khẩu',
      // ... more translations
    },
    'en': {
      'login': 'Login',
      'logout': 'Logout',
      'email': 'Email',
      'password': 'Password',
      // ... more translations
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }
}
```

---

### 8. Global Configuration (globals.dart)

```dart
class Globals {
  static GlobalKey<_MyAppState>? myApp;
  static MainBloc? mainBloc;
  static UserMeResModel? userMeResModel;
  static Config config = Config();

  // Screen dimensions
  static late double screenWidth;
  static late double screenHeight;

  // App state
  static bool isLoggedIn = false;
  static String? authToken;

  static void init(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
  }
}
```

---

### 9. Utility Functions

#### A. Custom Navigator (custom_navigator.dart):
```dart
class CustomNavigator {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Future<T?> push<T>(BuildContext context, Widget page) {
    return Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  static void pushReplacement(BuildContext context, Widget page) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  static void pop(BuildContext context, [dynamic result]) {
    Navigator.pop(context, result);
  }

  static void popUntilRoot(BuildContext context) {
    Navigator.popUntil(context, (route) => route.isFirst);
  }
}
```

#### B. Utility Functions (utility.dart):
```dart
class Utility {
  static void hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  static String formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  static String formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  static void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  static bool isValidPhone(String phone) {
    return RegExp(r'^[0-9]{10,11}$').hasMatch(phone);
  }
}
```

---

### 10. Updated main.dart

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  Globals.myApp = GlobalKey<_MyAppState>();
  await Config.getPreferences();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: MyApp(key: Globals.myApp),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
        return OverlaySupport.global(
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            navigatorKey: CustomNavigator.navigatorKey,
            theme: ThemeData.light(),
            darkTheme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
            themeMode: themeProvider.themeMode,
            locale: LocalizationsConfig.getCurrentLocale(),
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: LocalizationsConfig.supportedLocales,
            builder: (context, child) {
              AppSizes.init(context);
              Globals.init(context);
              return GestureDetector(
                onTap: Utility.hideKeyboard,
                child: child ?? Container(),
              );
            },
            home: const SplashScreen(),
          ),
        );
      },
    );
  }
}
```

---

## Key Deliverables

✅ **BLoC Pattern**: Implemented with RxDart streams
✅ **Folder Structure**: Clean, organized, scalable
✅ **Theme System**: Figma colors and dark mode support
✅ **Typography**: Consistent text styles
✅ **Widget Library**: 30+ reusable components
✅ **Responsive Design**: Adaptive layouts for all screen sizes
✅ **Internationalization**: Multi-language support (vi, en, zh)
✅ **Utilities**: Helper functions for common tasks
✅ **Global State**: Centralized app configuration

---

## Architecture Principles Established

1. **Separation of Concerns**: Clear separation between UI, business logic, and data
2. **Single Responsibility**: Each class has one clear purpose
3. **DRY (Don't Repeat Yourself)**: Reusable components and utilities
4. **Open/Closed Principle**: Easy to extend, hard to modify
5. **Dependency Inversion**: Depend on abstractions, not concretions

---

## Success Criteria

✅ BLoC pattern consistently implemented
✅ Theme system matches Figma designs 100%
✅ All widgets are reusable and consistent
✅ Internationalization framework working
✅ Responsive design adapts to all screens
✅ Code is clean, documented, and maintainable

---

**Step Status**: ✅ Completed
**Next Step**: [Step 3: Network Layer & API Integration](STEP_3_NETWORK_LAYER.md)

# Step 1: Project Setup & Environment Configuration

## Overview
This step establishes the foundation for the Go Mep application by setting up the development environment, initializing the Flutter project, and configuring all necessary tools and dependencies.

## Duration
**1-2 days**

## Status
**✓ Completed**

## Objectives
- Set up Flutter development environment
- Initialize the project structure
- Configure version control
- Install and configure all dependencies
- Set up multi-platform support
- Configure asset management

---

## Tasks Completed

### 1. Flutter & Dart SDK Installation
#### Actions:
- Installed Flutter SDK (version >=3.3.1 <4.0.0)
- Installed Dart SDK
- Configured Flutter path in system environment variables
- Verified installation with `flutter doctor`

#### Verification:
```bash
flutter --version
dart --version
flutter doctor -v
```

#### Result:
All Flutter components properly installed and configured for development.

---

### 2. IDE & Development Tools Setup
#### Tools Configured:
- **Primary IDE**: Visual Studio Code / Android Studio
- **Flutter Extension**: Flutter and Dart plugins installed
- **DevTools**: Flutter DevTools for debugging
- **Emulators**: Android Emulator and iOS Simulator configured

#### Key Extensions:
- Flutter
- Dart
- Prettier
- GitLens
- Error Lens

---

### 3. Project Initialization
#### Command Used:
```bash
flutter create go_mep_application
cd go_mep_application
```

#### Project Structure Created:
```
go_mep_application/
├── android/                 # Android platform code
├── ios/                     # iOS platform code
├── lib/                     # Main application code
│   └── main.dart           # Application entry point
├── test/                    # Test files
├── assets/                  # Static assets
│   ├── icons/
│   ├── images/
│   ├── json/
│   └── figma/
├── web/                     # Web platform code
├── windows/                 # Windows platform code
├── linux/                   # Linux platform code
├── macos/                   # macOS platform code
├── pubspec.yaml            # Dependencies configuration
├── analysis_options.yaml   # Code analysis rules
└── README.md               # Project documentation
```

---

### 4. Version Control Setup
#### Git Initialization:
```bash
git init
git add .
git commit -m "Initial commit"
```

#### .gitignore Configuration:
Created comprehensive `.gitignore` file to exclude:
- Build files
- IDE-specific files
- Generated files
- Secret keys and credentials
- Platform-specific temporary files

#### Key Exclusions:
```
# Build outputs
/build/
*.apk
*.ipa

# IDE files
.idea/
.vscode/
*.iml

# Dependencies
.pub/
.packages

# Environment
.env
config.json (if containing secrets)
```

---

### 5. Dependencies Configuration (pubspec.yaml)

#### Core Dependencies:
```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter

  # State Management
  bloc: any
  flutter_bloc: any
  rxdart: any
  provider: ^6.1.5

  # Networking
  dio: ^5.8.0+1
  http: any
  http_parser: any
  connectivity_plus: any

  # Storage
  shared_preferences: any
  flutter_secure_storage: ^9.2.4
  path_provider: ^2.1.5

  # UI Components
  shimmer: any
  fl_chart: ^0.65.0
  table_calendar: ^3.0.9
  flutter_animate: ^4.5.2
  card_swiper: 3.0.1
  badges: any
  auto_size_text_plus: any

  # Maps & Location
  google_maps_flutter: ^2.9.0
  flutter_polyline_points: ^2.1.0
  geolocator: ^13.0.2
  geocoding: ^3.0.0

  # Media
  image_picker: 1.1.2
  cached_network_image: any
  flutter_image_compress: ^2.3.0
  image: ^4.2.0
  flutter_svg: ^2.2.1
  image_gallery_saver_plus: any

  # Security & Encryption
  pointycastle: ^4.0.0
  basic_utils: ^5.8.2
  fast_rsa: ^3.6.0

  # Utilities
  intl: any
  url_launcher: any
  fluttertoast: any
  overlay_support: ^2.1.0
  permission_handler: 11.4.0
  device_info_plus: 11.3.3
  webview_flutter: any
  flutter_datetime_picker_plus: any
  keyboard_actions: any
  cupertino_icons: any

dev_dependencies:
  flutter_test:
    sdk: flutter
```

#### Installation:
```bash
flutter pub get
```

---

### 6. Platform-Specific Configuration

#### Android Configuration (android/app/build.gradle):
```gradle
android {
    compileSdkVersion 34

    defaultConfig {
        applicationId "com.gomep.application"
        minSdkVersion 21
        targetSdkVersion 34
        versionCode 1
        versionName "1.0.0"
    }

    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
    }
}
```

#### iOS Configuration (ios/Runner/Info.plist):
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs access to location for map features</string>
<key>NSCameraUsageDescription</key>
<string>This app needs access to camera for profile pictures</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>This app needs access to photo library</string>
```

#### Permissions Added:
- **Android** (AndroidManifest.xml):
  - INTERNET
  - ACCESS_FINE_LOCATION
  - ACCESS_COARSE_LOCATION
  - CAMERA
  - WRITE_EXTERNAL_STORAGE
  - READ_EXTERNAL_STORAGE

- **iOS** (Info.plist):
  - NSLocationWhenInUseUsageDescription
  - NSCameraUsageDescription
  - NSPhotoLibraryUsageDescription

---

### 7. Asset Configuration

#### Asset Directory Structure:
```
assets/
├── icons/
│   ├── car_fill.svg
│   ├── waves.png
│   └── [other icons]
├── images/
│   ├── logo.png
│   ├── splash.png
│   └── [other images]
├── json/
│   └── config.json
└── figma/
    └── [figma exports]
```

#### pubspec.yaml Asset Declaration:
```yaml
flutter:
  uses-material-design: true

  assets:
    - assets/icons/
    - assets/images/
    - assets/json/
    - assets/figma/
```

---

### 8. Configuration File Setup

#### config.json Structure:
```json
{
  "dev": {
    "server": "https://dev-api.gomep.com",
    "version": "1.0.0",
    "environment": "development"
  },
  "staging": {
    "server": "https://staging-api.gomep.com",
    "version": "1.0.0",
    "environment": "staging"
  },
  "production": {
    "server": "https://api.gomep.com",
    "version": "1.0.0",
    "environment": "production"
  }
}
```

---

### 9. Code Analysis Configuration

#### analysis_options.yaml:
```yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    - avoid_print
    - prefer_const_constructors
    - prefer_const_literals_to_create_immutables
    - use_key_in_widget_constructors
    - avoid_unnecessary_containers
    - prefer_single_quotes
    - sort_child_properties_last

analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
```

---

### 10. Initial Application Entry Point

#### lib/main.dart (Initial Setup):
```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Force portrait mode
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Go Mep',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: Text('Go Mep Application'),
        ),
      ),
    );
  }
}
```

---

## Key Deliverables

✅ **Flutter SDK Installed**: Version 3.3.1+
✅ **Project Initialized**: Complete project structure
✅ **Git Repository**: Version control configured
✅ **Dependencies Installed**: All 40+ packages configured
✅ **Platform Setup**: Android, iOS, Web, Desktop
✅ **Assets Configured**: Icons, images, JSON files
✅ **Analysis Tools**: Linter and formatter configured
✅ **Permissions**: All platform permissions set
✅ **Configuration Files**: Environment configs ready
✅ **Documentation**: README.md created

---

## Verification Steps

### 1. Check Flutter Installation:
```bash
flutter doctor -v
```
**Expected**: All checkmarks green

### 2. Verify Dependencies:
```bash
flutter pub get
```
**Expected**: All packages resolved successfully

### 3. Test Build:
```bash
flutter build apk --debug
flutter build ios --debug (on macOS)
```
**Expected**: Successful debug build

### 4. Run Application:
```bash
flutter run
```
**Expected**: App launches on connected device/emulator

---

## Common Issues Encountered & Solutions

### Issue 1: Flutter Doctor Warnings
**Problem**: Android toolchain not found
**Solution**: Install Android SDK through Android Studio

### Issue 2: Dependency Conflicts
**Problem**: Version conflicts between packages
**Solution**: Used `any` for flexible versioning, specific versions for critical packages

### Issue 3: iOS Build Errors
**Problem**: CocoaPods installation issues
**Solution**:
```bash
cd ios
pod install
cd ..
```

### Issue 4: Asset Not Found
**Problem**: Assets not loading in app
**Solution**: Verified pubspec.yaml indentation and ran `flutter clean`

---

## File Structure After Step 1

```
go_mep_application/
├── .git/                    # Git version control
├── .gitignore              # Git ignore rules
├── android/                # Android platform
│   ├── app/
│   │   ├── build.gradle
│   │   └── src/
│   └── build.gradle
├── ios/                    # iOS platform
│   ├── Runner/
│   │   ├── Info.plist
│   │   └── Assets.xcassets/
│   └── Podfile
├── lib/                    # Application code
│   └── main.dart          # Entry point
├── assets/                 # Static assets
│   ├── icons/
│   ├── images/
│   ├── json/
│   │   └── config.json
│   └── figma/
├── test/                   # Tests
│   └── widget_test.dart
├── pubspec.yaml           # Dependencies
├── analysis_options.yaml  # Linter config
└── README.md              # Documentation
```

---

## Next Steps

With the project foundation established, the next phase focuses on:

1. **Step 2**: Implementing the core architecture (BLoC pattern)
2. Creating the design system (themes, colors, typography)
3. Building reusable widget library
4. Setting up localization framework

---

## Lessons Learned

1. **Dependency Management**: Using specific versions for critical packages (dio, google_maps_flutter) ensures stability
2. **Multi-Platform Support**: Early platform configuration prevents issues later
3. **Asset Organization**: Structured asset folders improve maintainability
4. **Version Control**: Comprehensive .gitignore prevents committing unnecessary files
5. **Configuration Files**: Separate environment configs enable easy switching between dev/staging/prod

---

## Tools & Technologies Used

| Tool | Version | Purpose |
|------|---------|---------|
| Flutter SDK | 3.3.1+ | Framework |
| Dart SDK | 3.x | Language |
| Android Studio | Latest | Android development |
| Xcode | Latest | iOS development |
| Visual Studio Code | Latest | Code editor |
| Git | 2.x | Version control |

---

## Success Criteria

✅ Flutter project runs successfully on Android
✅ Flutter project runs successfully on iOS
✅ All dependencies installed without errors
✅ Git repository initialized and committed
✅ Asset files accessible in application
✅ Configuration files properly structured
✅ Development environment fully operational

---

**Step Status**: ✅ Completed
**Next Step**: [Step 2: Core Architecture & Design System Implementation](STEP_2_ARCHITECTURE_DESIGN.md)

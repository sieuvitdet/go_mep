# Go Mep Application

A Flutter mobile application for Go Mep, featuring authentication, notifications, and user management capabilities.

## Description

Go Mep is a mobile application built with Flutter that provides a comprehensive platform for user management and communication. The app includes features such as user authentication, password management, notifications, and personal account management.

## Features

- **Authentication System**
  - User login and logout
  - Password change functionality
  - Password reset via email
  - First-time password setup
  - IT contact support

- **User Interface**
  - Modern Material Design
  - Multi-language support (Vietnamese, English, Chinese)
  - Responsive design for various screen sizes
  - Custom themes and styling

- **Core Functionality**
  - Home dashboard
  - Notification management
  - Personal account settings
  - Secure data storage
  - Network connectivity handling

- **Technical Features**
  - State management with BLoC pattern
  - HTTP networking with Dio
  - Image handling and compression
  - Location services
  - Secure storage
  - Calendar integration

## Prerequisites

Before running this application, make sure you have the following installed:

- Flutter SDK (>=3.3.1)
- Dart SDK
- Android Studio / Xcode (for mobile development)
- Git

## How to Run

### 1. Clone the repository
```bash
git clone <repository-url>
cd go_mep_application
```

### 2. Install dependencies
```bash
flutter pub get
```

### 3. Configure the application
- Update the configuration in `assets/json/config.json` with your server endpoints
- Configure environment-specific settings (dev, staging, production)

### 4. Run the application

#### For Android:
```bash
flutter run
```

#### For iOS:
```bash
flutter run -d ios
```

#### For specific device:
```bash
flutter devices
flutter run -d <device-id>
```

### 5. Build for production

#### Android APK:
```bash
flutter build apk --release
```

#### iOS:
```bash
flutter build ios --release
```

## How to Test

### Run unit tests
```bash
flutter test
```

### Run integration tests
```bash
flutter test integration_test/
```

### Run tests with coverage
```bash
flutter test --coverage
```

### Run specific test files
```bash
flutter test test/widget_test.dart
```

## Project Structure

```
lib/
├── common/                 # Shared utilities and widgets
│   ├── lang_key/          # Language keys
│   ├── localization/      # Internationalization
│   ├── theme/            # App theming
│   ├── utils/            # Utility functions
│   └── widgets/          # Reusable widgets
├── data/                 # Data models and local storage
├── net/                  # Network layer (API, HTTP)
├── presentation/         # UI screens and business logic
│   ├── auth/            # Authentication screens
│   ├── base/            # Main app screens
│   ├── boarding/        # Onboarding screens
│   └── main/            # Main navigation
└── main.dart            # App entry point
```

## Dependencies

Key dependencies used in this project:

- **State Management**: `flutter_bloc`, `bloc`
- **Networking**: `dio`, `http`
- **UI Components**: `shimmer`, `fl_chart`, `table_calendar`
- **Storage**: `shared_preferences`, `flutter_secure_storage`
- **Media**: `image_picker`, `cached_network_image`
- **Location**: `geolocator`, `geocoding`
- **Utilities**: `intl`, `url_launcher`, `permission_handler`

## Configuration

The app supports multiple environments (dev, staging, production) configured in `assets/json/config.json`. Each environment has its own:

- Server endpoints
- App version information
- Build configurations
- Security settings

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## License

This project is proprietary software. All rights reserved.

## Support

For technical support or questions, please contact the development team through the IT contact feature within the application.
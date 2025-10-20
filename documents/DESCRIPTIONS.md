# Go Mep Application - Technical Description

## Project Overview

**Go Mep** is a comprehensive mobile application built with Flutter, designed to provide a complete platform for restaurant discovery, taxi services, user management, and communication. The application features a modern architecture based on BLoC (Business Logic Component) pattern for state management and follows clean architecture principles.

## Application Purpose

Go Mep serves as a multi-functional platform that enables users to:
- Discover and search for restaurants using Google Maps integration
- Request and manage taxi services
- Receive real-time notifications
- Manage personal accounts and profiles
- Securely authenticate and manage passwords
- Access location-based services

## Technical Stack

### Core Technologies
- **Framework**: Flutter (SDK >=3.3.1 <4.0.0)
- **Language**: Dart
- **State Management**: BLoC Pattern with RxDart streams
- **Platform**: Cross-platform (Android, iOS, Web, Desktop)

### Key Dependencies

#### State Management & Architecture
- `flutter_bloc` & `bloc` - BLoC pattern implementation
- `rxdart` - Reactive programming with streams
- `provider` - Dependency injection and state management

#### Networking & API
- `dio` (v5.8.0+1) - HTTP client for API communication
- `http` - Additional HTTP support
- `connectivity_plus` - Network connectivity monitoring

#### UI Components & Design
- `shimmer` - Loading skeleton screens
- `fl_chart` (v0.65.0) - Charts and data visualization
- `table_calendar` (v3.0.9) - Calendar components
- `flutter_animate` (v4.5.2) - Animations
- `card_swiper` (v3.0.1) - Swipeable card layouts
- `badges` - Badge indicators
- `auto_size_text_plus` - Responsive text sizing
- `flutter_svg` (v2.2.1) - SVG image support

#### Maps & Location Services
- `google_maps_flutter` (v2.9.0) - Google Maps integration
- `flutter_polyline_points` (v2.1.0) - Route visualization
- `geolocator` (v13.0.2) - GPS location services
- `geocoding` (v3.0.0) - Address geocoding

#### Media & File Handling
- `image_picker` (v1.1.2) - Camera and gallery access
- `flutter_image_compress` (v2.3.0) - Image optimization
- `cached_network_image` - Efficient image caching
- `image` (v4.2.0) - Image processing
- `image_gallery_saver_plus` - Save images to gallery
- `path_provider` (v2.1.5) - File system access

#### Storage & Security
- `shared_preferences` - Local key-value storage
- `flutter_secure_storage` (v9.2.4) - Encrypted secure storage
- `pointycastle` (v4.0.0) - Cryptography library
- `basic_utils` (v5.8.2) - Utility functions
- `fast_rsa` (v3.6.0) - RSA encryption

#### Permissions & Device
- `permission_handler` (v11.4.0) - Runtime permissions
- `device_info_plus` (v11.3.3) - Device information

#### Internationalization & Localization
- `flutter_localizations` - Multi-language support
- `intl` - Date, number, and message formatting

#### Other Utilities
- `webview_flutter` - In-app web browsing
- `url_launcher` - Open external URLs
- `fluttertoast` - Toast notifications
- `overlay_support` (v2.1.0) - Overlay notifications
- `flutter_datetime_picker_plus` - Date/time pickers
- `keyboard_actions` - Keyboard management

## Architecture Overview

### Directory Structure

```
lib/
├── common/                    # Shared resources and utilities
│   ├── lang_key/             # Internationalization keys
│   ├── localization/         # Language configuration
│   ├── theme/                # App theming and styling
│   │   ├── globals/         # Global theme configuration
│   │   ├── app_colors.dart  # Color definitions
│   │   ├── app_dimens.dart  # Dimension constants
│   │   ├── app_format.dart  # Formatting utilities
│   │   ├── app_text_styles.dart  # Text styles
│   │   └── figma_colors.dart     # Figma design colors
│   ├── utils/                # Utility functions
│   │   ├── custom_navigator.dart  # Navigation helper
│   │   ├── device_id.dart         # Device identification
│   │   ├── permission_request.dart # Permission handling
│   │   ├── progress_dialog.dart    # Loading dialogs
│   │   ├── rsa_encryption_helper.dart # Encryption utilities
│   │   └── utility.dart           # General utilities
│   └── widgets/              # Reusable UI components
│       ├── custom_button.dart
│       ├── custom_textfield.dart
│       ├── custom_dialog.dart
│       ├── custom_appbar.dart
│       ├── figma_button.dart      # Figma-designed buttons
│       ├── figma_input_field.dart # Figma-designed inputs
│       └── ... (30+ custom widgets)
│
├── data/                     # Data layer
│   ├── local/               # Local data storage
│   │   └── shared_prefs/    # SharedPreferences wrapper
│   ├── model/               # Data models
│   │   ├── req/            # Request models (API input)
│   │   │   ├── login_req_model.dart
│   │   │   ├── change_password_req_model.dart
│   │   │   ├── notification_req_model.dart
│   │   │   ├── reset_password_req_model.dart
│   │   │   └── geocoding_req_model.dart
│   │   └── res/            # Response models (API output)
│   │       ├── login_res_model.dart
│   │       ├── logout_res_model.dart
│   │       ├── notification_res_model.dart
│   │       ├── user_me_res_model.dart
│   │       ├── reset_password_res_model.dart
│   │       └── geocoding_res_model.dart
│   ├── user_account.dart    # User account management
│   └── user_data.dart       # User data storage
│
├── net/                      # Network layer
│   ├── api/                 # API configuration
│   │   ├── api.dart        # API endpoints definition
│   │   └── interaction.dart # API request/response handling
│   ├── http/                # HTTP client configuration
│   │   ├── http_connection.dart   # HTTP client setup
│   │   └── http_status_code.dart  # Status code constants
│   ├── repository/          # Data repository
│   │   └── repository.dart  # API call implementations
│   └── network_connectivity.dart  # Network monitoring
│
├── presentation/             # Presentation layer (UI + BLoC)
│   ├── auth/                # Authentication features
│   │   ├── splash_screen/   # Splash screen
│   │   ├── login/           # Login functionality
│   │   │   ├── ui/         # Login UI screens
│   │   │   └── bloc/       # Login business logic
│   │   ├── register/        # Registration
│   │   ├── change_password/ # Password change
│   │   ├── change_password_first_time/ # First-time password setup
│   │   ├── reset_password/  # Password reset
│   │   └── request_reset_password_email/ # Reset password request
│   │
│   ├── base/                # Main application features
│   │   ├── home/           # Home screen
│   │   │   ├── ui/        # Home UI
│   │   │   └── bloc/      # Home business logic
│   │   ├── notifications/  # Notification management
│   │   │   ├── ui/        # Notification UI
│   │   │   └── bloc/      # Notification logic
│   │   ├── personal/       # Personal account management
│   │   │   ├── ui/        # Account UI
│   │   │   └── bloc/      # Account logic
│   │   ├── google_map/     # Google Maps integration
│   │   │   ├── ui/        # Map UI
│   │   │   ├── bloc/      # Map logic
│   │   │   └── widgets/   # Map-specific widgets
│   │   └── news/           # News/feed functionality
│   │       └── models/    # News data models
│   │
│   ├── boarding/            # Onboarding screens
│   │   └── src/
│   │       └── bloc/       # Onboarding logic
│   │
│   └── main/                # Main navigation
│       └── bloc/           # Main app logic
│
└── main.dart                # Application entry point
```

## Core Features

### 1. Authentication System
- **Login Screen**: Responsive design with phone/password authentication
- **Password Management**:
  - First-time password setup
  - Password change functionality
  - Password reset via email
  - Reset token verification
- **Account Verification**: Account status checking
- **Session Management**: Refresh token mechanism
- **Secure Logout**: Token invalidation

### 2. User Interface
- **Modern Material Design**: Follows Material Design 3 guidelines
- **Multi-language Support**: Vietnamese (vi), English (en), Chinese
- **Responsive Design**: Adapts to various screen sizes
- **Dark/Light Theme**: Theme switching capability
- **Custom Themes**: Figma-based design system
- **Status Bar Management**: Adaptive status bar styling

### 3. Home & Dashboard
- **User Profile Display**: Shows user information
- **Quick Access**: Navigation to main features
- **News Feed**: Latest updates and announcements
- **Activity Overview**: User activity tracking

### 4. Notifications
- **Real-time Notifications**: Push notification support
- **Notification List**: Paginated notification display
- **Read/Unread Status**: Mark notifications as read
- **Load More**: Infinite scroll with pagination
- **Pull to Refresh**: Manual refresh capability
- **Notification Badge**: Unread count indicator

### 5. Google Maps Integration
- **Restaurant Discovery**:
  - Search for restaurants
  - View restaurant markers on map
  - Focus on selected restaurant
  - Restaurant details display
- **Taxi Service**:
  - Mode switching (Restaurant/Taxi)
  - Vehicle location tracking
  - Route visualization
- **Location Services**:
  - Current location detection
  - Geocoding and reverse geocoding
  - Address search
  - Custom map markers with different sizes (focused vs normal)
- **Search Functionality**:
  - Real-time search
  - Search results list
  - Clear search capability

### 6. Personal Account Management
- **Profile View**: Display user information
  - Full name
  - Email address
  - Phone number
  - Birthday
  - Gender
  - Address
  - Personal notes
- **Profile Editing**: Update personal information
- **Settings**: App preferences and configuration

### 7. Network & Connectivity
- **Network Monitoring**: Real-time connectivity status
- **Offline Handling**: Graceful degradation
- **API Error Handling**: User-friendly error messages
- **Retry Mechanism**: Automatic retry for failed requests

### 8. Data Storage
- **Local Storage**:
  - SharedPreferences for app settings
  - Secure Storage for sensitive data (tokens, credentials)
- **Caching**:
  - Image caching for performance
  - API response caching
- **Data Persistence**: User preferences and session data

## BLoC Pattern Implementation

### BLoC Structure
Each feature follows the BLoC pattern with:

```dart
class FeatureBloc {
  late BuildContext context;

  // Streams for state management
  final streamData = BehaviorSubject<DataModel?>();
  final streamIsLoading = BehaviorSubject<bool>();
  final streamError = BehaviorSubject<String?>();

  FeatureBloc(BuildContext context) {
    this.context = context;
    // Initialize streams
  }

  // Business logic methods
  Future<void> loadData() async {
    streamIsLoading.add(true);

    // API calls and data processing
    // Update streams with results

    streamIsLoading.add(false);
  }

  void dispose() {
    streamData.close();
    streamIsLoading.close();
    streamError.close();
  }
}
```

### Stream-based State Management
- **BehaviorSubject**: Maintains current state and emits to new subscribers
- **StreamBuilder**: UI updates based on stream changes
- **Reactive Programming**: Data flows through streams
- **Separation of Concerns**: Business logic separated from UI

### Example: Notification BLoC
```dart
class NotificationBloc {
  final streamNotifications = BehaviorSubject<List<NotificationData>>();
  final streamLoading = BehaviorSubject<bool>();
  final streamLoadMore = BehaviorSubject<bool>();

  // Load initial notifications
  Future<void> initializeNotifications() async { ... }

  // Load more notifications (pagination)
  Future<void> loadNotifications({bool isLoadMore = false}) async { ... }

  // Refresh notifications
  Future<void> refreshNotifications() async { ... }

  // Mark notification as read
  Future<void> markAsRead(String id) async { ... }
}
```

## API Integration

### Endpoint Structure
- **Base Gateway**: `/api`
- **API Version**: `api-version=1.0`
- **Authentication**: Token-based (Bearer token)

### Key Endpoints
1. **Authentication**:
   - `POST /api/auth/login` - User login
   - `POST /api/auth/logout` - User logout
   - `POST /api/auth/refresh-token` - Token refresh
   - `POST /api/auth/change-password` - Change password
   - `POST /api/auth/reset-password` - Reset password
   - `POST /api/auth/request-reset-password` - Request reset email
   - `GET /api/auth/account-check` - Check account status

2. **User Management**:
   - `GET /api/users/me` - Get current user info

3. **Notifications**:
   - `GET /api/notifications?pageNumber={n}&pageSize={m}` - Get notifications

4. **Location Services**:
   - `GET /api/geocodes/reverse?lat={lat}&lng={lng}` - Reverse geocoding

### Request/Response Flow
1. **Request Model**: Create request model with required data
2. **API Call**: Send request via Dio HTTP client
3. **Response Handling**: Parse response into response model
4. **Stream Update**: Emit data through BLoC streams
5. **UI Update**: StreamBuilder rebuilds UI with new data

### Error Handling
- HTTP status code checking
- Network error handling
- Token expiration handling with automatic refresh
- User-friendly error messages

## Security Features

### Encryption
- **RSA Encryption**: Password encryption before transmission
- **Secure Storage**: Encrypted storage for sensitive data
- **Token Management**: Secure token storage and refresh

### Data Protection
- **HTTPS**: All API communication over HTTPS
- **Token Expiration**: Automatic token refresh
- **Secure Logout**: Token invalidation on logout

### Permissions
- **Location Permissions**: Request location access
- **Camera Permissions**: Request camera access for profile pictures
- **Storage Permissions**: Request storage access for file operations

## Localization & Internationalization

### Supported Languages
- Vietnamese (vi) - Primary language
- English (en) - Secondary language
- Chinese (zh) - Additional language

### Implementation
- **App Localizations**: Custom localization delegate
- **Language Keys**: Centralized translation keys
- **Dynamic Language Switching**: Runtime language change
- **Formatted Messages**: Date, number, and currency formatting

### Text Formatting
- **Date Formats**: `DateFormat` from `intl` package
- **Number Formats**: Currency and decimal formatting
- **Relative Time**: "Just now", "5 minutes ago", etc.

## UI/UX Design

### Design System
- **Figma Integration**: Direct implementation from Figma designs
- **Color Scheme**: Defined in `figma_colors.dart`
- **Typography**: Custom text styles
- **Spacing System**: Consistent padding and margins
- **Component Library**: 30+ reusable widgets

### Responsive Design
- **ResponsiveContainer**: Adaptive layouts
- **MediaQuery**: Screen size detection
- **Orientation Support**: Portrait and landscape
- **Platform-specific UI**: iOS and Android adaptations

### Custom Widgets
1. **Form Components**:
   - `FigmaInputField`: Text input fields
   - `FigmaButton`: Action buttons
   - `CustomTextField`: Custom text fields
   - `CustomDropdown`: Dropdown selectors

2. **Display Components**:
   - `CustomAppBar`: Application bar
   - `CustomDialog`: Alert dialogs
   - `CustomBottomSheet`: Bottom sheets
   - `CustomCard`: Content cards

3. **Feedback Components**:
   - `CustomProgressIndicator`: Loading indicators
   - `CustomSkeleton`: Skeleton loading screens
   - `CustomEmpty`: Empty state displays
   - `CustomToast`: Toast notifications

4. **Navigation Components**:
   - `CustomRoute`: Page transitions
   - `CustomTabBar`: Tab navigation
   - `CustomPopup`: Popup menus

## Performance Optimization

### Image Handling
- **Caching**: `cached_network_image` for network images
- **Compression**: Automatic image compression
- **Lazy Loading**: Images load on demand
- **Placeholder**: Shimmer effect while loading

### List Performance
- **Pagination**: Load data in chunks
- **Infinite Scroll**: Load more on scroll
- **ListView.builder**: Efficient list rendering
- **Item Recycling**: Reuse list items

### State Management
- **Minimal Rebuilds**: Only affected widgets rebuild
- **Stream Optimization**: Efficient stream subscriptions
- **Dispose Pattern**: Proper resource cleanup

## Development Guidelines

### Code Style
- **Dart Style Guide**: Follow official Dart conventions
- **Naming Conventions**:
  - Classes: PascalCase
  - Variables: camelCase
  - Constants: lowerCamelCase with `const` keyword
  - Private members: prefix with `_`

### BLoC Pattern Rules
1. All business logic in BLoC classes
2. UI only handles presentation
3. Use streams for state management
4. Minimize `setState` usage
5. Proper stream disposal

### Widget Development
1. Keep widgets small and focused
2. Extract reusable components
3. Use `const` constructors where possible
4. Follow Figma designs 100%

### API Integration
1. Create request/response models
2. Handle errors gracefully
3. Show loading states
4. Provide user feedback

## Testing Strategy

### Unit Tests
- BLoC logic testing
- Utility function testing
- Model validation testing

### Widget Tests
- UI component testing
- User interaction testing
- State change testing

### Integration Tests
- End-to-end flow testing
- API integration testing
- Navigation testing

## Build & Deployment

### Development Environment
- Debug mode with hot reload
- Development API endpoints
- Verbose logging

### Staging Environment
- Release mode build
- Staging API endpoints
- Error tracking

### Production Environment
- Optimized release build
- Production API endpoints
- Performance monitoring
- Crash reporting

## Future Enhancements

### Planned Features
1. **Push Notifications**: Firebase Cloud Messaging integration
2. **Social Features**: User chat and messaging
3. **Payment Integration**: In-app payment processing
4. **Analytics**: User behavior tracking
5. **Offline Mode**: Full offline functionality
6. **Real-time Updates**: WebSocket integration

### Technical Improvements
1. **Code Generation**: JSON serialization with `json_serializable`
2. **Dependency Injection**: GetIt or Provider improvements
3. **Testing Coverage**: Increase test coverage to 80%+
4. **Performance Monitoring**: Firebase Performance integration
5. **CI/CD Pipeline**: Automated build and deployment

## Configuration Files

### assets/json/config.json
Contains environment-specific configuration:
```json
{
  "dev": {
    "server": "https://dev-api.gomep.com",
    "version": "1.0.0"
  },
  "staging": {
    "server": "https://staging-api.gomep.com",
    "version": "1.0.0"
  },
  "production": {
    "server": "https://api.gomep.com",
    "version": "1.0.0"
  }
}
```

### pubspec.yaml
- Dependencies management
- Asset declarations
- Version control
- SDK constraints

### analysis_options.yaml
- Linter rules
- Code analysis configuration
- Static analysis settings

## Platform Support

### Android
- Minimum SDK: 21 (Android 5.0)
- Target SDK: 34 (Android 14)
- Permissions configured in `AndroidManifest.xml`

### iOS
- Minimum iOS version: 12.0
- Permissions configured in `Info.plist`
- CocoaPods integration

### Web
- Progressive Web App support
- Responsive web design
- Browser compatibility

### Desktop (Linux, macOS, Windows)
- Flutter desktop support
- Native window management
- Platform-specific features

## Conclusion

Go Mep is a well-architected Flutter application that demonstrates best practices in mobile development. It leverages modern technologies, follows clean architecture principles, and provides a solid foundation for future enhancements. The application is production-ready with comprehensive features for user management, location services, and real-time communication.

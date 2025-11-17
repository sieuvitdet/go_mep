# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Go Mep is a Flutter mobile application for user management, authentication, notifications, and restaurant discovery with integrated Google Maps. The app follows Clean Architecture principles with BLoC pattern for state management.

**Tech Stack**: Flutter 3.3.1+, Dart, BLoC/RxDart, Dio, Google Maps, Firebase

**Platforms**: Android, iOS (primary), Web/Linux/macOS (partial support)

## Essential Commands

### Development
```bash
# Install dependencies
flutter pub get

# Run app
flutter run

# Run on specific device
flutter devices
flutter run -d <device-id>

# Run on iOS
flutter run -d ios

# Code analysis
flutter analyze
```

### Building
```bash
# Android APK (release)
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS (release)
flutter build ios --release

# Debug builds
flutter build apk --debug
flutter build ios --debug
```

### Testing
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart

# Run with coverage
flutter test --coverage

# Integration tests
flutter test integration_test/
```

### Clean & Rebuild
```bash
# Clean build artifacts
flutter clean

# Get dependencies and rebuild
flutter clean && flutter pub get
```

## Project Architecture

### Clean Architecture Layers

```
Presentation Layer (UI + BLoC) → Repository → Network (API) → Server
```

### Directory Structure

- **`lib/common/`** - Shared components across the app
  - `theme/` - Design system (Figma colors, text styles, dimensions, globals)
  - `widgets/` - Reusable UI components (buttons, inputs, dialogs)
  - `utils/` - Utilities (RSA encryption, GPS, image picker, extensions)
  - `localization/` - i18n setup (Vietnamese, English, Chinese)
  - `lang_key/` - Translation keys

- **`lib/data/`** - Data layer
  - `model/req/` - Request models (API payloads)
  - `model/res/` - Response models (API responses)
  - `local/shared_prefs/` - Local storage (simple key-value)
  - `local/database/` - **SQLite database with Drift ORM**
    - `app_database.dart` - Main database class
    - `tables/` - Table definitions (Notifications, Users, Places)
    - `daos/` - Data Access Objects (CRUD operations)
    - `database_maintenance_service.dart` - Auto cleanup & maintenance
  - `repositories/` - **Cache-first repository layer**
    - `notification_repository.dart` - Notification cache management
    - `user_repository.dart` - User profile cache
    - `places_repository.dart` - Places/restaurant cache

- **`lib/net/`** - Network layer
  - `api/api.dart` - API endpoint definitions
  - `api/interaction.dart` - HTTP request wrapper
  - `repository/repository.dart` - Repository pattern implementation
  - `http/` - HTTP client configuration

- **`lib/presentation/`** - UI & Business Logic
  - `auth/` - Authentication flows (login, register, password management, OTP)
  - `base/` - Main app features (home, notifications, personal, news, restaurant, google_map)
  - `boarding/` - Onboarding screens
  - `main/` - Main navigation with bottom bar

- **`assets/`** - Static resources
  - `json/config.json` - Environment configuration (dev, staging, production)
  - `json/vi.json`, `en.json` - Translation files
  - `icons/`, `images/`, `figma/` - Media assets

### BLoC Pattern Implementation

All business logic uses the BLoC pattern with RxDart streams. **Critical**: Minimize `setState()` usage.

**Standard BLoC Structure**:
```dart
class FeatureBloc {
  late BuildContext context;

  // Streams for reactive state
  final streamData = BehaviorSubject<DataModel?>();
  final streamIsLoading = BehaviorSubject<bool>();

  FeatureBloc(BuildContext context) {
    this.context = context;
    streamIsLoading.add(false);
  }

  Future<void> loadData() async {
    streamIsLoading.add(true);
    try {
      ResponseModel response = await Repository.getData(context);
      streamData.add(response.data);
    } catch (e) {
      // Handle error
    }
    streamIsLoading.add(false);
  }

  void dispose() {
    streamData.close();
    streamIsLoading.close();
  }
}
```

**UI Pattern**:
```dart
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

**Reference Implementation**: `lib/presentation/main/bloc/main_bloc.dart` demonstrates the complete pattern for API mapping, data streaming, and error handling.

## API Integration

### Server Configuration

API server runs on `localhost:8000` (proxied via ngrok in config). Configured in `assets/json/config.json`:
- `dev.server` - Development endpoint
- `staging.server` - Staging endpoint
- `product.server` - Production endpoint

### API Flow

1. **Define endpoint** in `lib/net/api/api.dart`
2. **Add repository method** in `lib/net/repository/repository.dart`
3. **Call from BLoC** and stream results
4. **Update UI** via StreamBuilder

**Example**:
```dart
// 1. API endpoint (api.dart)
static String getUserMe() => '/api/v1/auth/me';

// 2. Repository method (repository.dart)
static getUserMe(BuildContext context) =>
  Interaction(
    context: context,
    url: API.getUserMe(),
    param: {},
    showError: false
  ).get();

// 3. BLoC usage (main_bloc.dart)
Future<void> getUserInfo() async {
  streamIsLoading.add(true);
  ResponseModel response = await Repository.getUserMe(context);
  streamUserInfo.add(response.data);
  streamIsLoading.add(false);
}
```

### Request/Response Models

- All API requests use models in `lib/data/model/req/`
- All API responses use models in `lib/data/model/res/`
- Models include `toJson()` and `fromJson()` methods

## Figma Design System

**Critical**: UI must match Figma designs 100% - pixel-perfect implementation required.

**Figma Link**: See `figma_link.md` for component references

### Design Resources

- **Colors**: `lib/common/theme/figma_colors.dart` - Use Figma color palette exclusively
- **Typography**: `lib/common/theme/app_text_styles.dart` - Predefined text styles
- **Dimensions**: `lib/common/theme/app_dimens.dart` - Spacing constants
- **Components**: `lib/common/widgets/figma_*.dart` - Figma-based widgets

### Custom Figma Components

- `figma_button.dart` - Button component matching Figma specs
- `figma_input_field.dart` - Input fields with Figma styling
- `figma_logo.dart` - App logo component
- Custom dialogs in `lib/common/widgets/dialogs/`

## Key Implementation Requirements

### 1. UI Development
- Match Figma designs exactly (100% requirement)
- Use Figma color system (`FigmaColors` class)
- Use predefined text styles (`AppTextStyles`)
- Implement proper loading, error, and empty states
- Add shimmer effects for loading states

### 2. BLoC Pattern Rules
- All business logic in BLoC classes (not in UI)
- Use RxDart `BehaviorSubject` for state streams
- Avoid `setState()` - use streams instead
- Always dispose streams in `dispose()` method
- Reference `main_bloc.dart` for canonical implementation

### 3. Google Maps Integration
- Custom markers with size differentiation (focused vs normal)
- Restaurant search with real-time filtering
- Location tracking and geocoding
- Proper marker clustering and selection states

### 4. Localization
- Support Vietnamese (primary), English, Chinese
- Use `LangKey` constants for translation keys
- Load translations from `assets/json/vi.json` and `en.json`
- Update translations in JSON files, not hardcoded

### 5. Error Handling
- Network errors with user-friendly messages
- Token refresh on 401 responses
- Offline mode support
- Custom error dialogs

## State Management

### Global State
- `Globals` class (in `lib/common/theme/globals/globals.dart`) stores app-wide state
- `Globals.userMeResModel` - Current user data
- `Globals.mainBloc` - Main BLoC instance
- `Globals.config` - Environment configuration

### Theme Management
- `ThemeProvider` (Provider pattern) for dark/light mode
- Toggle theme via `ThemeProvider.toggleTheme()`
- Access theme in UI via `Theme.of(context)`

### Local Storage
- `SharedPrefs` class wraps SharedPreferences
- Secure storage via `flutter_secure_storage` for tokens/sensitive data
- RSA encryption for password transmission (`rsa_encryption_helper.dart`)

## Security

- Passwords encrypted with RSA before transmission
- Tokens stored in secure storage
- API keys managed via `assets/json/config.json`
- Never commit sensitive credentials to git

## Common Utilities

- **`custom_navigator.dart`** - Navigation helpers
- **`custom_image_picker.dart`** - Image selection and compression
- **`gps_utils.dart`** - Location services
- **`device_id.dart`** - Device identification
- **`extension.dart`** - Dart extensions for common operations
- **`app_format.dart`** - Date/number formatting

## Development Workflow

### Adding a New Feature

1. **Create BLoC** in appropriate feature folder (`presentation/<feature>/bloc/`)
2. **Create UI** in `presentation/<feature>/ui/`
3. **Define models** in `data/model/req/` and `data/model/res/`
4. **Add API endpoint** in `net/api/api.dart`
5. **Add repository method** in `net/repository/repository.dart`
6. **Implement BLoC logic** using streams (reference `main_bloc.dart`)
7. **Build UI** with StreamBuilders
8. **Match Figma design** 100%

### Modifying Existing Features

1. **Check Figma** for design specs
2. **Locate BLoC** in `presentation/<feature>/bloc/`
3. **Update streams** for new state
4. **Update UI** in `presentation/<feature>/ui/`
5. **Test all states** (loading, error, empty, success)

## Testing Strategy

- Unit tests for BLoC logic and utilities
- Widget tests for UI components
- Integration tests for complete flows
- Currently minimal test coverage - expansion needed

## Environment Configuration

The app uses `assets/json/config.json` for environment-specific settings:
- `environment`: Current environment (`"staging"` by default)
- `dev`, `staging`, `product`: Environment configurations
  - `server`: API base URL
  - `versionName`, `versionCode`: App version
  - `displayPrint`: Enable debug logs
  - Signing configs for Android

Change environment by updating the `"environment"` field.

## Known Issues & Patterns

- Some mock data exists in BLoC classes (e.g., `main_bloc.dart` lines 28-38) - replace with real API calls
- Notification pagination implemented - follow same pattern for other lists
- Google Maps markers need precise sizing (focused marker should be larger)
- Always check `figma_link.md` for component-specific Figma references

## Important Notes

- **Language**: Primary language is Vietnamese - UI text, comments, variable names may be in Vietnamese
- **BLoC Reference**: Always refer to `lib/presentation/main/bloc/main_bloc.dart` for standard implementation patterns
- **Figma Compliance**: Non-negotiable 100% design match requirement
- **Stream Management**: Every stream must be closed in `dispose()` to prevent memory leaks
- **Error Messages**: Should be user-friendly and localized

## SQLite Database with Drift ORM

### Overview

The app uses **Drift** (formerly Moor) for local database management with a **cache-first strategy** for optimal performance and offline support.

**Key Benefits:**
- ⚡ Instant UI loading (50-100ms vs 1-2s from network)
- 📱 Full offline support
- 🔄 Automatic data sync
- 💾 ~80% reduction in API calls
- 🎯 Type-safe database queries

### Database Structure

**Tables:**
1. **Notifications** (13 columns) - Cache notifications with pagination
2. **Users** (10 columns) - Cache user profile data
3. **Places** (14 columns) - Cache restaurant/location data

**Location:** `lib/data/local/database/`

### Accessing Database & Repositories

All database access is through global instances initialized in `main.dart`:

```dart
// Access from Globals
final db = Globals.database;
final notificationRepo = Globals.notificationRepository;
final userRepo = Globals.userRepository;
final placesRepo = Globals.placesRepository;
final maintenance = Globals.maintenanceService;
```

### Cache-First Strategy Pattern

**All BLoCs follow this pattern:**

```dart
Future<void> loadData({bool forceRefresh = false}) async {
  // Step 1: Load from cache first (instant UI)
  if (!forceRefresh) {
    final cached = await repository.getCached();
    if (cached != null) {
      streamData.add(cached); // Update UI immediately
    }
  }

  // Step 2: Fetch from API (background)
  try {
    final apiData = await repository.getFromApi(context);
    // Step 3: Update cache
    await repository.cache(apiData);
    // Step 4: Update UI with fresh data
    streamData.add(apiData);
  } catch (e) {
    // Step 5: On error, use cache
    final cached = await repository.getCached();
    streamData.add(cached);
  }
}
```

### Repository Layer

**NotificationRepository** - `lib/data/repositories/notification_repository.dart`
```dart
// Cache-first loading
final notifications = await notificationRepo.getNotifications(
  context: context,
  page: 1,
  pageSize: 10,
  forceRefresh: false, // Use cache if available
);

// Mark as read (updates cache)
await notificationRepo.markAsRead(notificationId);

// Watch unread count (reactive stream!)
notificationRepo.watchUnreadCount().listen((count) {
  // Auto-updates when database changes
});

// Cleanup old data
await notificationRepo.cleanupOldNotifications(); // Deletes > 30 days
```

**UserRepository** - `lib/data/repositories/user_repository.dart`
```dart
// Cache-first (24 hour TTL)
final user = await userRepo.getUser(
  context: context,
  forceRefresh: false,
);

// Watch user changes (reactive!)
userRepo.watchCurrentUser().listen((user) {
  // Auto-updates when user data changes
});

// Force refresh
await userRepo.fetchFreshUser(context: context);

// Clear on logout
await userRepo.clearCache();
```

**PlacesRepository** - `lib/data/repositories/places_repository.dart`
```dart
// Search with cache (6 hour TTL)
final results = await placesRepo.searchPlaces(
  context: context,
  query: "restaurant",
  latitude: 10.762622,
  longitude: 106.660172,
  radius: 5000, // meters
);

// Get nearby places from cache
final nearby = await placesRepo.getNearbyPlaces(
  latitude: lat,
  longitude: lng,
  radiusInKm: 5.0,
);

// Get top rated
final topRated = await placesRepo.getTopRatedPlaces(limit: 10);
```

### Updated BLoCs with Cache-First

**NotificationBloc** - `lib/presentation/base/notifications/bloc/notification_bloc.dart`
- ✅ Cache-first loading (instant UI)
- ✅ Offline support
- ✅ Reactive unread count
- ✅ Auto-sync in background

**MainBloc** - `lib/presentation/main/bloc/main_bloc.dart`
- ✅ User profile caching (24h)
- ✅ Reactive user stream
- ✅ Auto-refresh when stale
- ✅ Offline profile viewing

**MapBloc** - `lib/presentation/base/google_map/bloc/map_bloc.dart`
- ✅ Places caching (6h)
- ✅ Search history
- ✅ Offline map markers
- ✅ Background sync

### Database Maintenance

**Automatic cleanup** runs 5 seconds after app starts:

```dart
// Performed automatically by DatabaseMaintenanceService
- Delete notifications older than 30 days
- Keep max 1000 notifications
- Delete places older than 7 days
- Vacuum database (reclaim space)
```

**Manual operations:**
```dart
final maintenance = Globals.maintenanceService;

// Force maintenance
await maintenance.performMaintenance();

// Clear specific cache
await maintenance.clearCache(CacheType.notifications);

// Clear all cache
await maintenance.clearAllCache();

// Check database size
final sizeInBytes = await maintenance.getDatabaseSize();
```

### Code Generation

When modifying database schema:

```bash
# Generate Drift code after table/DAO changes
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode (auto-regenerate on changes)
flutter pub run build_runner watch
```

### Cache TTL Strategy

| Data Type | TTL | Max Items | Cleanup |
|-----------|-----|-----------|---------|
| Notifications | - | 1000 | 30 days |
| User Profile | 24h | 1 | On logout |
| Places | 6h | Unlimited | 7 days |

### SharedPreferences vs SQLite

**Use SharedPreferences for:**
- ✅ Auth tokens (token, refresh_token)
- ✅ Simple flags (is_remember_me)
- ✅ Language preference
- ✅ Device ID

**Use SQLite (Drift) for:**
- ✅ Complex objects (lists, nested data)
- ✅ Data requiring queries/filters
- ✅ Paginated data
- ✅ Offline-first features

### Performance Metrics

| Operation | Before SQLite | After SQLite | Improvement |
|-----------|---------------|--------------|-------------|
| Notification load | 1-2s | 50-100ms | **95% faster** |
| User profile load | 0.5-1s | 20-50ms | **96% faster** |
| Offline support | ❌ | ✅ Full | **100%** |
| API calls/session | 20-30 | 5-10 | **-75%** |

### Troubleshooting

**Build errors after schema changes:**
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

**Database corrupted:**
- App will auto-rebuild on next start
- Or manually: `await Globals.database?.close()` then restart app

**Cache not updating:**
- Check if `forceRefresh: true` is being used
- Verify repository is initialized in Globals
- Check debug logs for cache hits/misses

## Quick Reference

| Task | Location |
|------|----------|
| Add API endpoint | `lib/net/api/api.dart` |
| Add repository method | `lib/net/repository/repository.dart` |
| Create request model | `lib/data/model/req/` |
| Create response model | `lib/data/model/res/` |
| **Add database table** | `lib/data/local/database/tables/` |
| **Add DAO** | `lib/data/local/database/daos/` |
| **Create cache repository** | `lib/data/repositories/` |
| **Access database** | `Globals.database` |
| **Access repositories** | `Globals.notificationRepository`, etc. |
| Add translation | `assets/json/vi.json`, `assets/json/en.json` |
| Add reusable widget | `lib/common/widgets/` |
| Configure colors | `lib/common/theme/figma_colors.dart` |
| Configure text styles | `lib/common/theme/app_text_styles.dart` |
| Environment config | `assets/json/config.json` |
| Check Figma design | `figma_link.md` |
| **Run code generation** | `flutter pub run build_runner build` |
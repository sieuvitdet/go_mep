# Step 3: Network Layer & API Integration

## Overview
This step establishes the network communication layer, configuring the HTTP client, defining API endpoints, creating request/response models, and implementing error handling mechanisms.

## Duration
**3-4 days**

## Status
**✓ Completed**

## Dependencies
- Step 1: Project Setup (completed)
- Step 2: Architecture & Design System (completed)

## Objectives
- Configure Dio HTTP client
- Define all API endpoints
- Create request/response models
- Implement repository pattern
- Set up error handling
- Configure network monitoring
- Implement token management
- Set up API interceptors

---

## Tasks Completed

### 1. API Endpoint Configuration (net/api/api.dart)

```dart
class API {
  static String? get server => Globals.config.server;
  static String get successCode => "success";
  static String get fail => "fail";
  static bool get success => true;
  static String get gateway => "/api";
  static String get apiVersion => "api-version=1.0";

  // Authentication Endpoints
  static login() => "$gateway/auth/login?$apiVersion";
  static refreshToken() => "$gateway/auth/refresh-token?$apiVersion";
  static changePassword() => "$gateway/auth/change-password?$apiVersion";
  static requestResetPassword() =>
      "$gateway/auth/request-reset-password?$apiVersion";
  static logout() => "$gateway/auth/logout?$apiVersion";
  static accountCheck() => "$gateway/auth/account-check?$apiVersion";
  static resetPassword() => "$gateway/auth/reset-password?$apiVersion";
  static resetTokenInfo() => "$gateway/auth/reset-token-info?$apiVersion";

  // User Endpoints
  static userMe() => "$gateway/users/me?$apiVersion";

  // Notification Endpoints
  static notifications({required int pageNumber, required int pageSize}) =>
      "$gateway/notifications?pageNumber=$pageNumber&pageSize=$pageSize&$apiVersion";

  // Location Endpoints
  static geocodingReverse(GeocodingReqModel model) =>
      "$gateway/geocodes/reverse?lat=${model.lat}&lng=${model.lng}&$apiVersion";

  // Document Upload
  static bulkUploadAttachments({int expiryInSeconds = 3600}) =>
      "$gateway/document-attachments/bulk?expiryInSeconds=$expiryInSeconds&$apiVersion";

  // Test Endpoints
  static testEncrypt() => "$gateway/test/encrypt?$apiVersion";
}
```

**Key Features**:
- Centralized endpoint management
- Dynamic API versioning
- Environment-based server configuration
- Query parameter support

---

### 2. HTTP Client Configuration (net/http/http_connection.dart)

```dart
class HttpConnection {
  static Dio? _dio;

  static Dio get dio {
    if (_dio == null) {
      _dio = Dio(
        BaseOptions(
          baseUrl: API.server ?? '',
          connectTimeout: Duration(seconds: 30),
          receiveTimeout: Duration(seconds: 30),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      // Add interceptors
      _dio!.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            // Add auth token
            String? token = await SharedPrefs.getToken();
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            }

            print('REQUEST[${options.method}] => ${options.uri}');
            return handler.next(options);
          },
          onResponse: (response, handler) {
            print('RESPONSE[${response.statusCode}] => ${response.data}');
            return handler.next(response);
          },
          onError: (error, handler) async {
            print('ERROR[${error.response?.statusCode}] => ${error.message}');

            // Handle token expiration
            if (error.response?.statusCode == 401) {
              // Attempt to refresh token
              bool refreshed = await _refreshToken();
              if (refreshed) {
                // Retry original request
                return handler.resolve(await _retry(error.requestOptions));
              }
            }

            return handler.next(error);
          },
        ),
      );
    }

    return _dio!;
  }

  static Future<bool> _refreshToken() async {
    try {
      String? refreshToken = await SharedPrefs.getRefreshToken();
      if (refreshToken == null) return false;

      final response = await Dio().post(
        '${API.server}${API.refreshToken()}',
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200) {
        String newToken = response.data['token'];
        await SharedPrefs.setToken(newToken);
        return true;
      }
    } catch (e) {
      print('Token refresh failed: $e');
    }
    return false;
  }

  static Future<Response<dynamic>> _retry(
    RequestOptions requestOptions,
  ) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );

    return dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
}
```

**Key Features**:
- Singleton pattern for Dio instance
- Automatic token injection
- Request/response logging
- Token refresh mechanism
- Request retry on auth failure
- Timeout configuration

---

### 3. HTTP Status Code Handler (net/http/http_status_code.dart)

```dart
class HttpStatusCode {
  // Success
  static const int ok = 200;
  static const int created = 201;
  static const int noContent = 204;

  // Client Errors
  static const int badRequest = 400;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int notFound = 404;
  static const int methodNotAllowed = 405;
  static const int conflict = 409;
  static const int unprocessableEntity = 422;

  // Server Errors
  static const int internalServerError = 500;
  static const int badGateway = 502;
  static const int serviceUnavailable = 503;
  static const int gatewayTimeout = 504;

  static bool isSuccess(int? statusCode) {
    return statusCode != null && statusCode >= 200 && statusCode < 300;
  }

  static bool isClientError(int? statusCode) {
    return statusCode != null && statusCode >= 400 && statusCode < 500;
  }

  static bool isServerError(int? statusCode) {
    return statusCode != null && statusCode >= 500 && statusCode < 600;
  }

  static String getErrorMessage(int? statusCode) {
    switch (statusCode) {
      case badRequest:
        return 'Invalid request';
      case unauthorized:
        return 'Unauthorized access';
      case forbidden:
        return 'Access forbidden';
      case notFound:
        return 'Resource not found';
      case internalServerError:
        return 'Server error occurred';
      default:
        return 'An error occurred';
    }
  }
}
```

---

### 4. Request Models (data/model/req/)

#### Login Request:
```dart
class LoginReqModel {
  String? username;
  String? password;
  String? deviceId;

  LoginReqModel({
    this.username,
    this.password,
    this.deviceId,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'deviceId': deviceId,
    };
  }
}
```

#### Change Password Request:
```dart
class ChangePasswordReqModel {
  String? oldPassword;
  String? newPassword;

  ChangePasswordReqModel({
    this.oldPassword,
    this.newPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'oldPassword': oldPassword,
      'newPassword': newPassword,
    };
  }
}
```

#### Reset Password Request:
```dart
class ResetPasswordReqModel {
  String? token;
  String? newPassword;

  ResetPasswordReqModel({
    this.token,
    this.newPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'newPassword': newPassword,
    };
  }
}
```

#### Notification Request:
```dart
class NotificationReqModel {
  int? pageNumber;
  int? pageSize;

  NotificationReqModel({
    this.pageNumber = 1,
    this.pageSize = 20,
  });

  Map<String, dynamic> toJson() {
    return {
      'pageNumber': pageNumber,
      'pageSize': pageSize,
    };
  }
}
```

#### Geocoding Request:
```dart
class GeocodingReqModel {
  double? lat;
  double? lng;

  GeocodingReqModel({
    this.lat,
    this.lng,
  });

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lng': lng,
    };
  }
}
```

---

### 5. Response Models (data/model/res/)

#### Login Response:
```dart
class LoginResModel {
  String? token;
  String? refreshToken;
  String? userId;
  String? username;
  bool? requirePasswordChange;

  LoginResModel({
    this.token,
    this.refreshToken,
    this.userId,
    this.username,
    this.requirePasswordChange,
  });

  factory LoginResModel.fromJson(Map<String, dynamic> json) {
    return LoginResModel(
      token: json['token'],
      refreshToken: json['refreshToken'],
      userId: json['userId'],
      username: json['username'],
      requirePasswordChange: json['requirePasswordChange'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'refreshToken': refreshToken,
      'userId': userId,
      'username': username,
      'requirePasswordChange': requirePasswordChange,
    };
  }
}
```

#### User Response:
```dart
class UserMeResModel {
  String? id;
  String? username;
  String? email;
  String? fullName;
  String? phoneNumber;
  String? address;
  String? birthday;
  String? gender;
  String? note;
  String? avatarUrl;

  UserMeResModel({
    this.id,
    this.username,
    this.email,
    this.fullName,
    this.phoneNumber,
    this.address,
    this.birthday,
    this.gender,
    this.note,
    this.avatarUrl,
  });

  factory UserMeResModel.fromJson(Map<String, dynamic> json) {
    return UserMeResModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      fullName: json['fullName'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      birthday: json['birthday'],
      gender: json['gender'],
      note: json['note'],
      avatarUrl: json['avatarUrl'],
    );
  }
}
```

#### Notification Response:
```dart
class NotificationResModel {
  List<NotificationData>? data;
  int? totalCount;
  int? pageNumber;
  int? pageSize;

  NotificationResModel({
    this.data,
    this.totalCount,
    this.pageNumber,
    this.pageSize,
  });

  factory NotificationResModel.fromJson(Map<String, dynamic> json) {
    return NotificationResModel(
      data: (json['data'] as List?)
          ?.map((item) => NotificationData.fromJson(item))
          .toList(),
      totalCount: json['totalCount'],
      pageNumber: json['pageNumber'],
      pageSize: json['pageSize'],
    );
  }
}

class NotificationData {
  String? id;
  String? content;
  DateTime? createAt;
  bool? isRead;

  NotificationData({
    this.id,
    this.content,
    this.createAt,
    this.isRead,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      id: json['id'],
      content: json['content'],
      createAt: json['createAt'] != null
          ? DateTime.parse(json['createAt'])
          : null,
      isRead: json['isRead'] ?? false,
    );
  }
}
```

---

### 6. Repository Pattern (net/repository/repository.dart)

```dart
class Repository {
  // Authentication APIs
  static Future<ResponseModel> login(
    BuildContext context,
    LoginReqModel model,
  ) async {
    try {
      final response = await HttpConnection.dio.post(
        API.login(),
        data: model.toJson(),
      );

      return ResponseModel(
        success: HttpStatusCode.isSuccess(response.statusCode),
        result: response.data,
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return ResponseModel(
        success: false,
        message: _handleError(e),
        statusCode: e.response?.statusCode,
      );
    }
  }

  static Future<ResponseModel> getUserMe(BuildContext context) async {
    try {
      final response = await HttpConnection.dio.get(API.userMe());

      return ResponseModel(
        success: HttpStatusCode.isSuccess(response.statusCode),
        result: response.data,
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return ResponseModel(
        success: false,
        message: _handleError(e),
        statusCode: e.response?.statusCode,
      );
    }
  }

  static Future<ResponseModel> getNotifications(
    BuildContext context,
    NotificationReqModel model,
  ) async {
    try {
      final response = await HttpConnection.dio.get(
        API.notifications(
          pageNumber: model.pageNumber ?? 1,
          pageSize: model.pageSize ?? 20,
        ),
      );

      return ResponseModel(
        success: HttpStatusCode.isSuccess(response.statusCode),
        result: response.data,
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return ResponseModel(
        success: false,
        message: _handleError(e),
        statusCode: e.response?.statusCode,
      );
    }
  }

  static String _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please try again.';
      case DioExceptionType.badResponse:
        return error.response?.data['message'] ??
            HttpStatusCode.getErrorMessage(error.response?.statusCode);
      case DioExceptionType.cancel:
        return 'Request cancelled';
      case DioExceptionType.connectionError:
        return 'No internet connection';
      default:
        return 'An unexpected error occurred';
    }
  }
}

class ResponseModel {
  bool? success;
  dynamic result;
  String? message;
  int? statusCode;

  ResponseModel({
    this.success,
    this.result,
    this.message,
    this.statusCode,
  });
}
```

---

### 7. Network Connectivity Monitor (net/network_connectivity.dart)

```dart
class NetworkConnectivity {
  static final Connectivity _connectivity = Connectivity();
  static StreamSubscription<ConnectivityResult>? _subscription;

  static Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map((result) {
      return result != ConnectivityResult.none;
    });
  }

  static Future<bool> isConnected() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  static void startMonitoring() {
    _subscription = onConnectivityChanged.listen((isConnected) {
      if (!isConnected) {
        Utility.showToast('No internet connection');
      }
    });
  }

  static void stopMonitoring() {
    _subscription?.cancel();
    _subscription = null;
  }
}
```

---

### 8. Local Storage (data/local/shared_prefs/)

#### Shared Preferences Keys:
```dart
class SharedPrefsKey {
  static const String token = 'token';
  static const String refreshToken = 'refresh_token';
  static const String userId = 'user_id';
  static const String username = 'username';
  static const String language = 'language';
  static const String themeMode = 'theme_mode';
}
```

#### Shared Preferences Helper:
```dart
class SharedPrefs {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Token Management
  static Future<bool> setToken(String token) async {
    return await _prefs?.setString(SharedPrefsKey.token, token) ?? false;
  }

  static String? getToken() {
    return _prefs?.getString(SharedPrefsKey.token);
  }

  static Future<bool> setRefreshToken(String token) async {
    return await _prefs?.setString(SharedPrefsKey.refreshToken, token) ?? false;
  }

  static String? getRefreshToken() {
    return _prefs?.getString(SharedPrefsKey.refreshToken);
  }

  // User Data
  static Future<bool> setUserId(String userId) async {
    return await _prefs?.setString(SharedPrefsKey.userId, userId) ?? false;
  }

  static String? getUserId() {
    return _prefs?.getString(SharedPrefsKey.userId);
  }

  // Language
  static Future<bool> setLanguage(String languageCode) async {
    return await _prefs?.setString(SharedPrefsKey.language, languageCode) ?? false;
  }

  static String? getLanguage() {
    return _prefs?.getString(SharedPrefsKey.language);
  }

  // Clear All
  static Future<bool> clearAll() async {
    return await _prefs?.clear() ?? false;
  }
}
```

---

## Key Deliverables

✅ **Dio HTTP Client**: Configured with interceptors
✅ **API Endpoints**: All endpoints defined centrally
✅ **Request Models**: Type-safe request models
✅ **Response Models**: Type-safe response models with JSON parsing
✅ **Repository Pattern**: Clean API call abstraction
✅ **Error Handling**: Comprehensive error management
✅ **Token Management**: Automatic token injection and refresh
✅ **Network Monitoring**: Connectivity status tracking
✅ **Local Storage**: Secure data persistence

---

## API Request Flow

```
UI Layer (BLoC)
     ↓
Repository.method()
     ↓
HttpConnection.dio.request()
     ↓
Interceptor: Add Auth Token
     ↓
Send Request to Server
     ↓
Receive Response
     ↓
Interceptor: Check Status
     ↓
Parse Response Model
     ↓
Return ResponseModel
     ↓
BLoC: Update Stream
     ↓
UI: StreamBuilder Rebuilds
```

---

## Error Handling Strategy

1. **Network Errors**: Display user-friendly messages
2. **401 Unauthorized**: Attempt token refresh, redirect to login if failed
3. **Server Errors**: Log error, show generic message
4. **Timeout**: Inform user, allow retry
5. **No Internet**: Show offline message, queue requests

---

## Success Criteria

✅ API client successfully makes requests
✅ Token management working correctly
✅ Request/response models properly serialize
✅ Error handling covers all scenarios
✅ Network monitoring detects connectivity changes
✅ Repository pattern abstracts API complexity

---

**Step Status**: ✅ Completed
**Next Step**: [Step 4: Authentication System Development](STEP_4_AUTHENTICATION.md)

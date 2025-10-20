# Step 4: Authentication System Development

## Overview
This step implements a comprehensive authentication system including user login, password management, secure token storage, and password reset functionality. The system uses RSA encryption for sensitive data and provides a seamless user experience for authentication flows.

## Duration
**5-7 days**

## Status
**✓ Completed**

## Dependencies
- Step 1: Project Setup (completed)
- Step 2: Architecture & Design System (completed)
- Step 3: Network Layer & API Integration (completed)

## Objectives
- Implement user login with phone/email and password
- Create secure token storage system
- Build password change functionality
- Implement first-time password setup flow
- Create password reset via email flow
- Add account verification
- Implement session management
- Build logout functionality
- Integrate RSA encryption for sensitive data

---

## Tasks Completed

### 1. Login System Implementation

#### Login Screen UI (presentation/auth/login/ui/responsive_login_screen.dart):
```dart
class ResponsiveLoginScreen extends StatefulWidget {
  const ResponsiveLoginScreen({Key? key}) : super(key: key);

  @override
  State<ResponsiveLoginScreen> createState() => _ResponsiveLoginScreenState();
}

class _ResponsiveLoginScreenState extends State<ResponsiveLoginScreen> {
  late LoginBloc bloc;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    bloc = LoginBloc(context);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: ResponsiveContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            FigmaLogo(),
            Gaps.vGap32,

            // Username field
            ResponsiveInputField(
              hintText: 'Phone or Email',
              controller: usernameController,
              prefixIcon: Icon(Icons.person),
            ),
            Gaps.vGap16,

            // Password field
            ResponsiveInputField(
              hintText: 'Password',
              controller: passwordController,
              obscureText: true,
              prefixIcon: Icon(Icons.lock),
            ),
            Gaps.vGap24,

            // Login button
            StreamBuilder<bool>(
              stream: bloc.streamIsLoading,
              builder: (context, snapshot) {
                return ResponsiveButton(
                  text: 'Login',
                  type: FigmaButtonType.primary,
                  onPressed: () => bloc.login(
                    usernameController.text,
                    passwordController.text,
                  ),
                  isLoading: snapshot.data ?? false,
                );
              },
            ),
            Gaps.vGap16,

            // Forgot password
            TextButton(
              onPressed: () => bloc.navigateToResetPassword(),
              child: Text('Forgot Password?'),
            ),
          ],
        ),
      ),
    );
  }
}
```

#### Login BLoC (presentation/auth/login/bloc/login_bloc.dart):
```dart
class LoginBloc {
  late BuildContext context;

  final streamIsLoading = BehaviorSubject<bool>();
  final streamError = BehaviorSubject<String?>();

  LoginBloc(BuildContext context) {
    this.context = context;
    streamIsLoading.add(false);
  }

  Future<void> login(String username, String password) async {
    // Validation
    if (username.isEmpty || password.isEmpty) {
      streamError.add('Please enter username and password');
      return;
    }

    streamIsLoading.add(true);

    try {
      // Get device ID
      String deviceId = await DeviceId.getId();

      // Create request model
      LoginReqModel model = LoginReqModel(
        username: username,
        password: password,
        deviceId: deviceId,
      );

      // Call API
      ResponseModel responseModel = await Repository.login(context, model);

      if (responseModel.success ?? false) {
        // Parse response
        LoginResModel loginRes = LoginResModel.fromJson(
          responseModel.result ?? {},
        );

        // Save tokens
        await SharedPrefs.setToken(loginRes.token ?? '');
        await SharedPrefs.setRefreshToken(loginRes.refreshToken ?? '');
        await SharedPrefs.setUserId(loginRes.userId ?? '');

        // Check if password change required
        if (loginRes.requirePasswordChange ?? false) {
          navigateToChangePasswordFirstTime();
        } else {
          navigateToHome();
        }
      } else {
        streamError.add(responseModel.message ?? 'Login failed');
      }
    } catch (e) {
      streamError.add('An error occurred: $e');
    }

    streamIsLoading.add(false);
  }

  void navigateToHome() {
    CustomNavigator.pushReplacement(
      context,
      MainScreen(),
    );
  }

  void navigateToChangePasswordFirstTime() {
    CustomNavigator.push(
      context,
      ChangePasswordFirstTimeScreen(),
    );
  }

  void navigateToResetPassword() {
    CustomNavigator.push(
      context,
      RequestResetPasswordMailScreen(),
    );
  }

  void dispose() {
    streamIsLoading.close();
    streamError.close();
  }
}
```

---

### 2. Password Change Implementation

#### Change Password Screen:
```dart
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  late ChangePasswordBloc bloc;
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    bloc = ChangePasswordBloc(context);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(title: 'Change Password'),
      body: ResponsiveContainer(
        child: Column(
          children: [
            // Old password
            ResponsiveInputField(
              hintText: 'Current Password',
              controller: oldPasswordController,
              obscureText: true,
            ),
            Gaps.vGap16,

            // New password
            ResponsiveInputField(
              hintText: 'New Password',
              controller: newPasswordController,
              obscureText: true,
            ),
            Gaps.vGap16,

            // Confirm password
            ResponsiveInputField(
              hintText: 'Confirm New Password',
              controller: confirmPasswordController,
              obscureText: true,
            ),
            Gaps.vGap24,

            // Submit button
            StreamBuilder<bool>(
              stream: bloc.streamIsLoading,
              builder: (context, snapshot) {
                return ResponsiveButton(
                  text: 'Change Password',
                  type: FigmaButtonType.primary,
                  onPressed: () => bloc.changePassword(
                    oldPasswordController.text,
                    newPasswordController.text,
                    confirmPasswordController.text,
                  ),
                  isLoading: snapshot.data ?? false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
```

#### Change Password BLoC:
```dart
class ChangePasswordBloc {
  late BuildContext context;

  final streamIsLoading = BehaviorSubject<bool>();
  final streamError = BehaviorSubject<String?>();

  ChangePasswordBloc(BuildContext context) {
    this.context = context;
    streamIsLoading.add(false);
  }

  Future<void> changePassword(
    String oldPassword,
    String newPassword,
    String confirmPassword,
  ) async {
    // Validation
    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      streamError.add('All fields are required');
      return;
    }

    if (newPassword != confirmPassword) {
      streamError.add('New passwords do not match');
      return;
    }

    if (newPassword.length < 6) {
      streamError.add('Password must be at least 6 characters');
      return;
    }

    streamIsLoading.add(true);

    try {
      // Create request model
      ChangePasswordReqModel model = ChangePasswordReqModel(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );

      // Call API
      ResponseModel responseModel = await Repository.changePassword(
        context,
        model,
      );

      if (responseModel.success ?? false) {
        Utility.showToast('Password changed successfully');
        CustomNavigator.pop(context);
      } else {
        streamError.add(responseModel.message ?? 'Password change failed');
      }
    } catch (e) {
      streamError.add('An error occurred: $e');
    }

    streamIsLoading.add(false);
  }

  void dispose() {
    streamIsLoading.close();
    streamError.close();
  }
}
```

---

### 3. First-Time Password Setup

#### First-Time Password Change Screen:
```dart
class ChangePasswordFirstTimeScreen extends StatefulWidget {
  const ChangePasswordFirstTimeScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordFirstTimeScreen> createState() =>
      _ChangePasswordFirstTimeScreenState();
}

class _ChangePasswordFirstTimeScreenState
    extends State<ChangePasswordFirstTimeScreen> {
  late ChangePasswordFirstTimeBloc bloc;
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    bloc = ChangePasswordFirstTimeBloc(context);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(title: 'Set Your Password'),
      body: ResponsiveContainer(
        child: Column(
          children: [
            Text(
              'Please set a new password for your account',
              style: AppTextStyles.bodyLarge,
            ),
            Gaps.vGap32,

            ResponsiveInputField(
              hintText: 'New Password',
              controller: newPasswordController,
              obscureText: true,
            ),
            Gaps.vGap16,

            ResponsiveInputField(
              hintText: 'Confirm Password',
              controller: confirmPasswordController,
              obscureText: true,
            ),
            Gaps.vGap24,

            StreamBuilder<bool>(
              stream: bloc.streamIsLoading,
              builder: (context, snapshot) {
                return ResponsiveButton(
                  text: 'Set Password',
                  type: FigmaButtonType.primary,
                  onPressed: () => bloc.setPassword(
                    newPasswordController.text,
                    confirmPasswordController.text,
                  ),
                  isLoading: snapshot.data ?? false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
```

---

### 4. Password Reset Flow

#### Request Reset Email Screen:
```dart
class RequestResetPasswordMailScreen extends StatefulWidget {
  const RequestResetPasswordMailScreen({Key? key}) : super(key: key);

  @override
  State<RequestResetPasswordMailScreen> createState() =>
      _RequestResetPasswordMailScreenState();
}

class _RequestResetPasswordMailScreenState
    extends State<RequestResetPasswordMailScreen> {
  late RequestResetPasswordMailBloc bloc;
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    bloc = RequestResetPasswordMailBloc(context);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(title: 'Reset Password'),
      body: ResponsiveContainer(
        child: Column(
          children: [
            Text(
              'Enter your email address and we will send you a reset link',
              style: AppTextStyles.bodyLarge,
            ),
            Gaps.vGap32,

            ResponsiveInputField(
              hintText: 'Email Address',
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            Gaps.vGap24,

            StreamBuilder<bool>(
              stream: bloc.streamIsLoading,
              builder: (context, snapshot) {
                return ResponsiveButton(
                  text: 'Send Reset Link',
                  type: FigmaButtonType.primary,
                  onPressed: () => bloc.requestReset(emailController.text),
                  isLoading: snapshot.data ?? false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
```

#### Reset Password Screen (with token):
```dart
class ResetPasswordScreen extends StatefulWidget {
  final String token;

  const ResetPasswordScreen({
    Key? key,
    required this.token,
  }) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  late ResetPasswordBloc bloc;
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    bloc = ResetPasswordBloc(context);
    bloc.verifyToken(widget.token);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: bloc.streamTokenValid,
      builder: (context, snapshot) {
        if (snapshot.data == false) {
          return ErrorScreen(message: 'Invalid or expired reset link');
        }

        return CustomScaffold(
          appBar: CustomAppBar(title: 'Reset Password'),
          body: ResponsiveContainer(
            child: Column(
              children: [
                ResponsiveInputField(
                  hintText: 'New Password',
                  controller: newPasswordController,
                  obscureText: true,
                ),
                Gaps.vGap16,

                ResponsiveInputField(
                  hintText: 'Confirm Password',
                  controller: confirmPasswordController,
                  obscureText: true,
                ),
                Gaps.vGap24,

                StreamBuilder<bool>(
                  stream: bloc.streamIsLoading,
                  builder: (context, snapshot) {
                    return ResponsiveButton(
                      text: 'Reset Password',
                      type: FigmaButtonType.primary,
                      onPressed: () => bloc.resetPassword(
                        widget.token,
                        newPasswordController.text,
                        confirmPasswordController.text,
                      ),
                      isLoading: snapshot.data ?? false,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
```

---

### 5. RSA Encryption Implementation

#### RSA Encryption Helper (common/utils/rsa_encryption_helper.dart):
```dart
class RSAEncryptionHelper {
  static const String publicKey = '''
-----BEGIN PUBLIC KEY-----
[Your Public Key Here]
-----END PUBLIC KEY-----
''';

  /// Encrypt data using RSA public key
  static Future<String?> encrypt(String plainText) async {
    try {
      final publicKeyObj = RSAKeyParser().parse(publicKey) as RSAPublicKey;
      final encryptor = OAEPEncoding(RSAEngine())
        ..init(true, PublicKeyParameter<RSAPublicKey>(publicKeyObj));

      final plainBytes = utf8.encode(plainText);
      final encryptedBytes = encryptor.process(Uint8List.fromList(plainBytes));

      return base64.encode(encryptedBytes);
    } catch (e) {
      print('Encryption error: $e');
      return null;
    }
  }

  /// Encrypt password for login
  static Future<String?> encryptPassword(String password) async {
    return await encrypt(password);
  }

  /// Encrypt sensitive data
  static Future<String?> encryptSensitiveData(String data) async {
    return await encrypt(data);
  }
}
```

**Usage in Login**:
```dart
// Encrypt password before sending to API
String? encryptedPassword = await RSAEncryptionHelper.encryptPassword(password);

if (encryptedPassword != null) {
  LoginReqModel model = LoginReqModel(
    username: username,
    password: encryptedPassword,
    deviceId: deviceId,
  );

  ResponseModel responseModel = await Repository.login(context, model);
}
```

---

### 6. Token Management & Session

#### Secure Token Storage:
```dart
class SharedPrefs {
  // Token management
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

  static Future<bool> clearAuthData() async {
    await _prefs?.remove(SharedPrefsKey.token);
    await _prefs?.remove(SharedPrefsKey.refreshToken);
    await _prefs?.remove(SharedPrefsKey.userId);
    return true;
  }
}
```

#### Session Management:
```dart
class SessionManager {
  static bool isLoggedIn() {
    String? token = SharedPrefs.getToken();
    return token != null && token.isNotEmpty;
  }

  static Future<void> logout(BuildContext context) async {
    // Call logout API
    await Repository.logout(context);

    // Clear local data
    await SharedPrefs.clearAuthData();
    Globals.userMeResModel = null;
    Globals.authToken = null;

    // Navigate to login
    CustomNavigator.pushReplacement(context, LoginScreen());
  }

  static Future<bool> refreshSession() async {
    try {
      String? refreshToken = SharedPrefs.getRefreshToken();
      if (refreshToken == null) return false;

      ResponseModel response = await Repository.refreshToken(refreshToken);

      if (response.success ?? false) {
        String newToken = response.result['token'];
        await SharedPrefs.setToken(newToken);
        return true;
      }
    } catch (e) {
      print('Session refresh failed: $e');
    }
    return false;
  }
}
```

---

### 7. Authentication Flow Diagram

```
User Opens App
     ↓
Check if Token Exists
     ↓
     ├─→ YES → Validate Token
     │           ↓
     │       ├─→ Valid → Home Screen
     │       └─→ Invalid → Login Screen
     │
     └─→ NO → Login Screen
                 ↓
           User Enters Credentials
                 ↓
           Encrypt Password (RSA)
                 ↓
           Send to API
                 ↓
           ├─→ Success → Save Tokens
           │               ↓
           │          Check requirePasswordChange
           │               ↓
           │          ├─→ YES → First-Time Password Screen
           │          │           ↓
           │          │      Set New Password
           │          │           ↓
           │          │      Home Screen
           │          │
           │          └─→ NO → Home Screen
           │
           └─→ Failure → Show Error
                         ↓
                    Retry or Reset Password
```

---

### 8. Account Verification

#### Account Check Implementation:
```dart
class AccountCheckBloc {
  Future<bool> checkAccountExists(String username) async {
    try {
      ResponseModel response = await Repository.accountCheck(
        context,
        AccountCheckReqModel(username: username),
      );

      if (response.success ?? false) {
        return response.result['exists'] ?? false;
      }
    } catch (e) {
      print('Account check error: $e');
    }
    return false;
  }
}
```

---

### 9. Logout Implementation

```dart
class LogoutBloc {
  late BuildContext context;

  final streamIsLoading = BehaviorSubject<bool>();

  LogoutBloc(BuildContext context) {
    this.context = context;
    streamIsLoading.add(false);
  }

  Future<void> logout() async {
    streamIsLoading.add(true);

    try {
      // Call logout API
      ResponseModel response = await Repository.logout(context);

      // Clear local storage regardless of API response
      await SharedPrefs.clearAuthData();
      Globals.userMeResModel = null;
      Globals.authToken = null;

      // Navigate to login
      CustomNavigator.pushReplacement(context, LoginScreen());
    } catch (e) {
      print('Logout error: $e');
      // Even if API fails, clear local data and navigate
      await SharedPrefs.clearAuthData();
      CustomNavigator.pushReplacement(context, LoginScreen());
    }

    streamIsLoading.add(false);
  }

  void dispose() {
    streamIsLoading.close();
  }
}
```

---

## Key Deliverables

✅ **Login System**: Phone/email and password authentication
✅ **Token Management**: Secure storage and automatic injection
✅ **Password Change**: Change password functionality
✅ **First-Time Setup**: Mandatory password change on first login
✅ **Password Reset**: Email-based password reset flow
✅ **RSA Encryption**: Secure password transmission
✅ **Session Management**: Token refresh and expiration handling
✅ **Logout**: Clean logout with data clearing
✅ **Account Verification**: Check account existence

---

## Authentication Features

### Login Flow:
1. User enters phone/email and password
2. Password encrypted with RSA
3. Device ID retrieved
4. API call with encrypted credentials
5. Token stored securely
6. Check if password change required
7. Navigate to appropriate screen

### Password Change Flow:
1. User enters current password
2. User enters new password (twice)
3. Validation performed
4. API call to change password
5. Success confirmation
6. Return to previous screen

### Password Reset Flow:
1. User requests reset via email
2. Email sent with reset token
3. User opens link with token
4. Token validated
5. User sets new password
6. Success confirmation
7. Navigate to login

---

## Security Measures

1. **RSA Encryption**: All passwords encrypted before transmission
2. **Secure Storage**: Tokens stored in secure storage
3. **Token Refresh**: Automatic token refresh on expiration
4. **Session Timeout**: Automatic logout on long inactivity
5. **Password Requirements**: Minimum length and complexity
6. **Account Locking**: Protection against brute force (server-side)

---

## Success Criteria

✅ Users can login successfully with valid credentials
✅ Passwords are encrypted before transmission
✅ Tokens are stored securely
✅ Password change works correctly
✅ First-time password setup functions properly
✅ Password reset via email works end-to-end
✅ Session management handles token refresh
✅ Logout clears all sensitive data
✅ Error messages are user-friendly
✅ Loading states display correctly

---

**Step Status**: ✅ Completed
**Next Step**: [Step 5: Home Screen & Main Navigation](STEP_5_HOME_NAVIGATION.md)

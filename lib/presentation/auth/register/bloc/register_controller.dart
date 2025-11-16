import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_mep_application/common/theme/globals/globals.dart';
import 'package:go_mep_application/common/utils/custom_navigator.dart';
import 'package:go_mep_application/common/utils/gps_utils.dart';
import 'package:go_mep_application/common/utils/utility.dart';
import 'package:go_mep_application/data/local/local/shared_prefs/shared_prefs_key.dart';
import 'package:go_mep_application/presentation/auth/login/ui/login_screen.dart';

enum RegisterStep {
  phone,
  otp,
  password,
  information,
}

class RegisterState {
  final RegisterStep step;
  final String phoneNumber;
  final String otp;
  final String password;
  final String fullName;
  final String dateOfBirth;
  final String address;
  final bool isLoading;
  final String? errorMessage;

  RegisterState({
    this.step = RegisterStep.phone,
    this.phoneNumber = '',
    this.otp = '',
    this.password = '',
    this.fullName = '',
    this.dateOfBirth = '',
    this.address = '',
    this.isLoading = false,
    this.errorMessage,
  });

  RegisterState copyWith({
    RegisterStep? step,
    String? phoneNumber,
    String? otp,
    String? password,
    String? fullName,
    String? dateOfBirth,
    String? address,
    bool? isLoading,
    String? errorMessage,
  }) {
    return RegisterState(
      step: step ?? this.step,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      otp: otp ?? this.otp,
      password: password ?? this.password,
      fullName: fullName ?? this.fullName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      address: address ?? this.address,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class RegisterController {
  final BuildContext context;
  final _stateController = StreamController<RegisterState>.broadcast();
  Stream<RegisterState> get stateStream => _stateController.stream;

  RegisterState _currentState = RegisterState();

  // Controllers
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final fullNameController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final addressController = TextEditingController();

  // Focus nodes
  final phoneFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();

  // Streams for validation
  final _phoneErrorController = StreamController<String?>.broadcast();
  final _passwordErrorController = StreamController<String?>.broadcast();
  final _confirmPasswordErrorController = StreamController<String?>.broadcast();
  final _enableSubmitController = StreamController<bool>.broadcast();
  final _showPasswordController = StreamController<bool>.broadcast();
  final _showConfirmPasswordController = StreamController<bool>.broadcast();
  final _fetchingLocationController = StreamController<bool>.broadcast();

  Stream<String?> get phoneErrorStream => _phoneErrorController.stream;
  Stream<String?> get passwordErrorStream => _passwordErrorController.stream;
  Stream<String?> get confirmPasswordErrorStream => _confirmPasswordErrorController.stream;
  Stream<bool> get enableSubmitStream => _enableSubmitController.stream;
  Stream<bool> get showPasswordStream => _showPasswordController.stream;
  Stream<bool> get showConfirmPasswordStream => _showConfirmPasswordController.stream;
  Stream<bool> get fetchingLocationStream => _fetchingLocationController.stream;

  bool _showPassword = false;
  bool _showConfirmPassword = false;

  RegisterController(this.context) {
    _stateController.add(_currentState);
    _enableSubmitController.add(false);
    _showPasswordController.add(false);
    _showConfirmPasswordController.add(false);
    _fetchingLocationController.add(false);

    // Add listeners
    phoneController.addListener(_validatePhone);
    passwordController.addListener(_validatePasswordFields);
    confirmPasswordController.addListener(_validatePasswordFields);
    fullNameController.addListener(_validateInformationFields);
  }

  void _updateState(RegisterState newState) {
    _currentState = newState;
    _stateController.add(_currentState);
  }

  // Phone validation
  void _validatePhone() {
    final phone = phoneController.text.trim();
    if (phone.isEmpty) {
      _phoneErrorController.add(null);
      _enableSubmitController.add(false);
      return;
    }
    final phoneRegex = RegExp(r'^0[0-9]{9}$');
    if (!phoneRegex.hasMatch(phone)) {
      _phoneErrorController.add('Số điện thoại không hợp lệ (phải có 10 số và bắt đầu bằng 0)');
      _enableSubmitController.add(false);
    } else {
      _phoneErrorController.add(null);
      _enableSubmitController.add(true);
    }
  }

  void _validatePasswordFields() {
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (password.isNotEmpty && !Utility.isPassword(password)) {
      _passwordErrorController.add(
        'Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ cái viết hoa, chữ cái viết thường, số và ký tự đặc biệt',
      );
    } else {
      _passwordErrorController.add(null);
    }

    if (confirmPassword.isNotEmpty && password != confirmPassword) {
      _confirmPasswordErrorController.add('Mật khẩu không khớp');
    } else {
      _confirmPasswordErrorController.add(null);
    }

    final isValid = password.isNotEmpty &&
        confirmPassword.isNotEmpty &&
        Utility.isPassword(password) &&
        password == confirmPassword;
    _enableSubmitController.add(isValid);
  }

  Future<void> submitPhoneNumber() async {
    final phone = phoneController.text.trim();
    if (phone.isEmpty) {
      Utility.toast('Vui lòng nhập số điện thoại');
      return;
    }

    _validatePhone();
    if (_phoneErrorController.hasValue &&
        _phoneErrorController.value != null) {
      return;
    }

    _updateState(_currentState.copyWith(isLoading: true));

    try {
      // TODO: Call API to send OTP
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call

      _updateState(_currentState.copyWith(
        phoneNumber: phone,
        step: RegisterStep.otp,
        isLoading: false,
      ));
    } catch (e) {
      _updateState(_currentState.copyWith(
        isLoading: false,
        errorMessage: 'Đã có lỗi xảy ra, vui lòng thử lại',
      ));
      Utility.toast('Đã có lỗi xảy ra, vui lòng thử lại');
    }
  }

  // Verify OTP
  Future<void> verifyOTP(String otp) async {
    if (otp.length != 4) {
      Utility.toast('Vui lòng nhập đầy đủ mã OTP');
      return;
    }

    _updateState(_currentState.copyWith(isLoading: true));

    try {
      // TODO: Call API to verify OTP
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call

      _updateState(_currentState.copyWith(
        otp: otp,
        step: RegisterStep.password,
        isLoading: false,
      ));
    } catch (e) {
      _updateState(_currentState.copyWith(
        isLoading: false,
        errorMessage: 'Mã OTP không đúng, vui lòng thử lại',
      ));
      Utility.toast('Mã OTP không đúng, vui lòng thử lại');
    }
  }

  // Resend OTP
  Future<void> resendOTP() async {
    _updateState(_currentState.copyWith(isLoading: true));

    try {
      // TODO: Call API to resend OTP
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call

      _updateState(_currentState.copyWith(isLoading: false));
      Utility.toast('Mã OTP mới đã được gửi');
    } catch (e) {
      _updateState(_currentState.copyWith(isLoading: false));
      Utility.toast('Đã có lỗi xảy ra, vui lòng thử lại');
    }
  }

  // Submit password and complete registration
  Future<void> submitPassword() async {
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;
    final fullName = fullNameController.text.trim();
    final dateOfBirth = dateOfBirthController.text.trim();
    final address = addressController.text.trim();

    if (password.isEmpty || confirmPassword.isEmpty) {
      Utility.toast('Vui lòng nhập đầy đủ mật khẩu');
      return;
    }

    if (password != confirmPassword) {
      Utility.toast('Mật khẩu không khớp');
      return;
    }

    if (!Utility.isPassword(password)) {
      Utility.toast('Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ cái viết hoa, chữ cái viết thường, số và ký tự đặc biệt');
      return;
    }

    _updateState(_currentState.copyWith(isLoading: true));

    try {
      // Register user to local database
      final authRepo = Globals.authRepository;
      if (authRepo == null) {
        _updateState(_currentState.copyWith(isLoading: false));
        Utility.toast('Lỗi hệ thống, vui lòng thử lại');
        return;
      }

      final newUser = await authRepo.register(
        phoneNumber: _currentState.phoneNumber,
        password: password,
        fullName: fullName.isEmpty ? 'User ${_currentState.phoneNumber}' : fullName,
        dateOfBirth: dateOfBirth.isEmpty ? null : dateOfBirth,
        address: address.isEmpty ? null : address,
      );

      _updateState(_currentState.copyWith(isLoading: false));

      if (newUser != null) {
        // Save password to state for later use
        _updateState(_currentState.copyWith(
          password: password,
          step: RegisterStep.information,
        ));

        // Cache user info
        await Globals.userRepository?.cacheUser(newUser);
      } else {
        // Phone number already exists
        Utility.toast('Số điện thoại đã được đăng ký');
      }
    } catch (e) {
      _updateState(_currentState.copyWith(
        isLoading: false,
        errorMessage: 'Đã có lỗi xảy ra, vui lòng thử lại',
      ));
      Utility.toast('Đã có lỗi xảy ra: ${e.toString()}');
    }
  }

  // Toggle password visibility
  void toggleShowPassword() {
    _showPassword = !_showPassword;
    _showPasswordController.add(_showPassword);
  }

  void toggleShowConfirmPassword() {
    _showConfirmPassword = !_showConfirmPassword;
    _showConfirmPasswordController.add(_showConfirmPassword);
  }

  // Validate information fields
  void _validateInformationFields() {
    final fullName = fullNameController.text.trim();
    final isValid = fullName.isNotEmpty;
    _enableSubmitController.add(isValid);
  }

  // Select date of birth
  Future<void> selectDateOfBirth(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      final formattedDate =
          '${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}';
      dateOfBirthController.text = formattedDate;
    }
  }

  // Get current location and parse to address
  Future<void> getCurrentLocation() async {
    _fetchingLocationController.add(true);
    try {
      // Get current position
      final position = await GpsUtils.determinePosition();

      // Reverse geocoding to get address
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        final addressParts = [
          placemark.street,
          placemark.subLocality,
          placemark.locality,
          placemark.administrativeArea,
          placemark.country,
        ].where((part) => part != null && part.isNotEmpty).join(', ');

        if (addressParts.isNotEmpty) {
          addressController.text = addressParts;
          Utility.toast('Đã lấy địa chỉ hiện tại');
        } else {
          Utility.toast('Không thể lấy địa chỉ từ vị trí hiện tại');
        }
      } else {
        Utility.toast('Không thể lấy địa chỉ từ vị trí hiện tại');
      }
    } catch (e) {
      Utility.toast('Lỗi khi lấy vị trí: ${e.toString()}');
    }
    _fetchingLocationController.add(false);
  }

  // Submit information and complete registration
  Future<void> submitInformation() async {
    final fullName = fullNameController.text.trim();
    final dateOfBirth = dateOfBirthController.text.trim();
    final address = addressController.text.trim();

    if (fullName.isEmpty) {
      Utility.toast('Vui lòng nhập họ và tên');
      return;
    }

    _updateState(_currentState.copyWith(isLoading: true));

    try {
      // Update user information in database
      final authRepo = Globals.authRepository;
      if (authRepo == null) {
        _updateState(_currentState.copyWith(isLoading: false));
        Utility.toast('Lỗi hệ thống, vui lòng thử lại');
        return;
      }

      // Get current user and update
      final currentUser = await authRepo.getUserByPhone(_currentState.phoneNumber);
      if (currentUser != null) {
        // Update user with new information
        final updatedUser = await Globals.userRepository?.updateUserInfo(
          phoneNumber: _currentState.phoneNumber,
          fullName: fullName,
          dateOfBirth: dateOfBirth.isEmpty ? null : dateOfBirth,
          address: address.isEmpty ? null : address,
        );

        if (updatedUser != null) {
          // Mark profile as completed
          await Globals.prefs.setBool(
            SharedPrefsKey.is_profile_completed,
            true,
          );

          _updateState(_currentState.copyWith(isLoading: false));
          Utility.toast('Hoàn thành đăng ký!');
          CustomNavigator.popToRootAndPushReplacement(context, LoginScreen());
        } else {
          _updateState(_currentState.copyWith(isLoading: false));
          Utility.toast('Không thể cập nhật thông tin');
        }
      }
    } catch (e) {
      _updateState(_currentState.copyWith(
        isLoading: false,
        errorMessage: 'Đã có lỗi xảy ra',
      ));
      Utility.toast('Đã có lỗi xảy ra: ${e.toString()}');
    }
  }

  // Skip information step
  Future<void> skipInformation() async {
    // Mark profile as NOT completed (user can complete later)
    await Globals.prefs.setBool(SharedPrefsKey.is_profile_completed, false);

    Utility.toast('Bạn có thể hoàn thiện thông tin sau');
    CustomNavigator.popToRootAndPushReplacement(context, LoginScreen());
  }

  // Go back to previous step
  void goBack() {
    if (_currentState.step == RegisterStep.otp) {
      _updateState(_currentState.copyWith(step: RegisterStep.phone));
    } else if (_currentState.step == RegisterStep.password) {
      _updateState(_currentState.copyWith(step: RegisterStep.otp));
    } else if (_currentState.step == RegisterStep.information) {
      // If going back from information, go to login instead
      CustomNavigator.popToRootAndPushReplacement(context, LoginScreen());
    } else {
      CustomNavigator.pop(context);
    }
  }

  void dispose() {
    phoneController.dispose();
    otpController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    fullNameController.dispose();
    dateOfBirthController.dispose();
    addressController.dispose();
    phoneFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    _stateController.close();
    _phoneErrorController.close();
    _passwordErrorController.close();
    _confirmPasswordErrorController.close();
    _enableSubmitController.close();
    _showPasswordController.close();
    _showConfirmPasswordController.close();
    _fetchingLocationController.close();
  }
}

// Extension for StreamController
extension StreamControllerExtension<T> on StreamController<T> {
  bool get hasValue => isClosed ? false : true;
  T? get value {
    try {
      return stream.value;
    } catch (e) {
      return null;
    }
  }
}

extension StreamExtension<T> on Stream<T> {
  T? get value {
    T? lastValue;
    listen((value) {
      lastValue = value;
    });
    return lastValue;
  }
}

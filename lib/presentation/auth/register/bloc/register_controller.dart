import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_mep_application/common/utils/custom_navigator.dart';
import 'package:go_mep_application/common/utils/utility.dart';
import 'package:go_mep_application/data/model/req/register_req_model.dart';
import 'package:go_mep_application/net/api/interaction.dart';
import 'package:go_mep_application/net/repository/repository.dart';
import 'package:go_mep_application/net/http/http_connection.dart';
import 'package:go_mep_application/presentation/auth/login/ui/login_screen.dart';

enum RegisterStep {
  phone,
  otp,
  password,
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

  Stream<String?> get phoneErrorStream => _phoneErrorController.stream;
  Stream<String?> get passwordErrorStream => _passwordErrorController.stream;
  Stream<String?> get confirmPasswordErrorStream => _confirmPasswordErrorController.stream;
  Stream<bool> get enableSubmitStream => _enableSubmitController.stream;
  Stream<bool> get showPasswordStream => _showPasswordController.stream;
  Stream<bool> get showConfirmPasswordStream => _showConfirmPasswordController.stream;

  bool _showPassword = false;
  bool _showConfirmPassword = false;

  RegisterController(this.context) {
    _stateController.add(_currentState);
    _enableSubmitController.add(false);
    _showPasswordController.add(false);
    _showConfirmPasswordController.add(false);

    // Add listeners
    phoneController.addListener(_validatePhone);
    passwordController.addListener(_validatePasswordFields);
    confirmPasswordController.addListener(_validatePasswordFields);
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

    if (password.isNotEmpty && !_isValidPasswordFigma(password)) {
      _passwordErrorController.add(
        'Mật khẩu phải có 6-12 ký tự chữ hoặc số, không có ký tự đặc biệt',
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
        _isValidPasswordFigma(password) &&
        password == confirmPassword;
    _enableSubmitController.add(isValid);
  }

  bool _isValidPasswordFigma(String password) {
    if (password.length < 6 || password.length > 12) return false;
    final validCharsOnly = RegExp(r'^[a-zA-Z0-9]+$');
    return validCharsOnly.hasMatch(password);
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

    // if (fullName.isEmpty) {
    //   Utility.toast('Vui lòng nhập họ tên');
    //   return;
    // }

    // if (dateOfBirth.isEmpty) {
    //   Utility.toast('Vui lòng nhập ngày sinh');
    //   return;
    // }

    // if (address.isEmpty) {
    //   Utility.toast('Vui lòng nhập địa chỉ');
    //   return;
    // }

    if (password != confirmPassword) {
      Utility.toast('Mật khẩu không khớp');
      return;
    }

    if (!_isValidPasswordFigma(password)) {
      Utility.toast('Mật khẩu phải có 6-12 ký tự chữ hoặc số');
      return;
    }

    _updateState(_currentState.copyWith(isLoading: true));

    await Future.delayed(const Duration(seconds: 3));

    try {
      final registerModel = RegisterReqModel(
        phoneNumber: _currentState.phoneNumber,
        password: password,
        fullName: fullName,
        dateOfBirth: dateOfBirth,
        address: address,
      );
      Utility.toast('Đăng ký thành công!');

      CustomNavigator.popToRootAndPushReplacement(context, LoginScreen());

      // ResponseModel responseModel = await Repository.register(context, registerModel);

      // if (responseModel.success ?? false) {
      //   _updateState(_currentState.copyWith(isLoading: false));
      //   Utility.toast('Đăng ký thành công!');
      //   CustomNavigator.pop(context);
      // } else {
      //   _updateState(_currentState.copyWith(
      //     isLoading: false,
      //     errorMessage: 'Đăng ký thất bại, vui lòng thử lại',
      //   ));
      //   Utility.toast('Đăng ký thất bại, vui lòng thử lại');
      // }
    } catch (e) {
      _updateState(_currentState.copyWith(
        isLoading: false,
        errorMessage: 'Đã có lỗi xảy ra, vui lòng thử lại',
      ));
      Utility.toast('Đã có lỗi xảy ra, vui lòng thử lại');
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

  // Go back to previous step
  void goBack() {
    if (_currentState.step == RegisterStep.otp) {
      _updateState(_currentState.copyWith(step: RegisterStep.phone));
    } else if (_currentState.step == RegisterStep.password) {
      _updateState(_currentState.copyWith(step: RegisterStep.otp));
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

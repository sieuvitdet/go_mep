class ResetPasswordRequestReqModel {
  final String phoneNumber;
  final String resetType;

  ResetPasswordRequestReqModel({
    required this.phoneNumber,
    this.resetType = 'IT_SUPPORT',
  });

  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'resetType': resetType,
    };
  }
}


class OtpVerifyReqModel {
  final String phoneNumber;
  final String otp;

  OtpVerifyReqModel({
    required this.phoneNumber,
    required this.otp,
  });

  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'otp': otp,
    };
  }
}
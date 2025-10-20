class ResetPasswordReqModel {
  final String deviceId;
  final String deviceName;
  final String devicePlatform;
  final String appVersion;
  final String resetToken;
  final String newPassword;
  final String confirmPassword;

  ResetPasswordReqModel({
    required this.deviceId,
    required this.deviceName,
    required this.devicePlatform,
    required this.appVersion,
    required this.resetToken,
    required this.newPassword,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'deviceId': deviceId,
      'deviceName': deviceName,
      'devicePlatform': devicePlatform,
      'appVersion': appVersion,
      'resetToken': resetToken,
      'newPassword': newPassword,
      'confirmPassword': confirmPassword,
    };
  }
}

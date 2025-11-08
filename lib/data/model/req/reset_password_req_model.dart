class ResetPasswordReqModel {
  final String newPassword;
  final String confirmPassword;

  ResetPasswordReqModel({
    required this.newPassword,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'newPassword': newPassword,
      'confirmPassword': confirmPassword,
    };
  }
}

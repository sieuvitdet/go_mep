class ResetPasswordRequestResModel {
  final bool? success;
  final String? message;
  final String? resetToken;

  ResetPasswordRequestResModel({
    this.success,
    this.message,
    this.resetToken,
  });

  factory ResetPasswordRequestResModel.fromJson(Map<String, dynamic> json) {
    return ResetPasswordRequestResModel(
      success: json['success'],
      message: json['message'],
      resetToken: json['resetToken'],
    );
  }
}

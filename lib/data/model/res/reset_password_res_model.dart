class ResetPasswordResModel {
  final bool? success;
  final String? message;

  ResetPasswordResModel({
    this.success,
    this.message,
  });

  factory ResetPasswordResModel.fromJson(Map<String, dynamic> json) {
    return ResetPasswordResModel(
      success: json['success'],
      message: json['message'],
    );
  }
}

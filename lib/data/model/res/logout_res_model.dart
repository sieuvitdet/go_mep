class LogoutResModel {
  final bool? success;
  final String? message;

  LogoutResModel({
    this.success,
    this.message,
  });

  factory LogoutResModel.fromJson(Map<String, dynamic> json) {
    return LogoutResModel(
      success: json['success'],
      message: json['message'],
    );
  }
}

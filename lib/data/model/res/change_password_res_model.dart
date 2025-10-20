class ChangePasswordResModel {
  final bool? success;
  final String? message;

  ChangePasswordResModel({
    this.success,
    this.message,
  });

  factory ChangePasswordResModel.fromJson(Map<String, dynamic> json) {
    return ChangePasswordResModel(
      success: json['success'],
      message: json['message'],
    );
  }
}

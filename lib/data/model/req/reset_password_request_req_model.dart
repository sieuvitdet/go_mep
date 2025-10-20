class ResetPasswordRequestReqModel {
  final String username;
  final String resetType;

  ResetPasswordRequestReqModel({
    required this.username,
    this.resetType = 'IT_SUPPORT',
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'resetType': resetType,
    };
  }
}

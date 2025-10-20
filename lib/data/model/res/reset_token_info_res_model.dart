class ResetTokenInfoResModel {
  final String? username;
  final String? fullName;
  final String? avatar;
  final String? resetToken;
  final DateTime? resetPasswordTokenExpiry;

  ResetTokenInfoResModel({
    this.username,
    this.fullName,
    this.avatar,
    this.resetToken,
    this.resetPasswordTokenExpiry,
  });

  factory ResetTokenInfoResModel.fromJson(Map<String, dynamic> json) {
    return ResetTokenInfoResModel(
      username: json['username'],
      fullName: json['fullName'],
      avatar: json['avatar'],
      resetToken: json['resetToken'],
      resetPasswordTokenExpiry: json['resetPasswordTokenExpiry'] != null
          ? DateTime.parse(json['resetPasswordTokenExpiry'])
          : null,
    );
  }
}

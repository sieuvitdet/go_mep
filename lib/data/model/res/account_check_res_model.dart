class AccountCheckResModel {
  String? fullName;
  String? username;
  String? maskedEmail;
  String? avatar;

  AccountCheckResModel(
      {this.fullName, this.username, this.maskedEmail, this.avatar});

  AccountCheckResModel.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    username = json['username'];
    maskedEmail = json['maskedEmail'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fullName'] = this.fullName;
    data['username'] = this.username;
    data['maskedEmail'] = this.maskedEmail;
    data['avatar'] = this.avatar;
    return data;
  }
}

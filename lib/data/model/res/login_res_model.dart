class LoginResModel {
  String? accessToken;
  String? created;
  String? expiration;
  String? refreshToken;
  bool? isRequirePasswordChange;
  int? expiresIn;

  LoginResModel(
      {this.accessToken,
      this.created,
      this.expiration,
      this.refreshToken,
      this.isRequirePasswordChange,
      this.expiresIn});

  LoginResModel.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    created = json['created'];
    expiration = json['expiration'];
    refreshToken = json['refreshToken'];
    isRequirePasswordChange = json['isRequirePasswordChange'];
    expiresIn = json['expiresIn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accessToken'] = this.accessToken;
    data['created'] = this.created;
    data['expiration'] = this.expiration;
    data['refreshToken'] = this.refreshToken;
    data['isRequirePasswordChange'] = this.isRequirePasswordChange;
    data['expiresIn'] = this.expiresIn;
    return data;
  }
}

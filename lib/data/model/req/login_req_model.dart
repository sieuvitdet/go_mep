class LoginReqModel {
  String? deviceId;
  String? deviceName;
  String? devicePlatform;
  String? appVersion;
  String? username;
  String? password;
  bool? rememberMe;

  LoginReqModel(
      {this.deviceId,
      this.deviceName,
      this.devicePlatform,
      this.appVersion,
      this.username,
      this.password,
      this.rememberMe});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deviceId'] = this.deviceId;
    data['deviceName'] = this.deviceName;
    data['devicePlatform'] = this.devicePlatform;
    data['appVersion'] = this.appVersion;
    data['username'] = this.username;
    data['password'] = this.password;
    data['rememberMe'] = this.rememberMe;
    return data;
  }
}

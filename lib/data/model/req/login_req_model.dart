class LoginReqModel {
  String? phoneNumber;
  String? password;

  LoginReqModel(
      {this.phoneNumber,
      this.password,});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone_number'] = this.phoneNumber; // Map to phone_number for API
    data['password'] = this.password;
    return data;
  }
}

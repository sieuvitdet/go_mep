class RegisterReqModel {
  String? phoneNumber;
  String? password;
  String? fullName;
  String? dateOfBirth;
  String? address;

  RegisterReqModel({
    this.phoneNumber,
    this.password,
    this.fullName,
    this.dateOfBirth,
    this.address,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['phone_number'] = phoneNumber;
    data['password'] = password;
    data['full_name'] = fullName;
    data['date_of_birth'] = dateOfBirth;
    data['address'] = address;
    return data;
  }

  RegisterReqModel.fromJson(Map<String, dynamic> json) {
    phoneNumber = json['phone_number'];
    password = json['password'];
    fullName = json['full_name'];
    dateOfBirth = json['date_of_birth'];
    address = json['address'];
  }
}
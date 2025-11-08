class UpdateProfileReqModel {
  String? fullName;
  String? dateOfBirth;
  String? address;

  UpdateProfileReqModel({
    this.fullName,
    this.dateOfBirth,
    this.address,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['full_name'] = fullName;
    data['date_of_birth'] = dateOfBirth;
    data['address'] = address;
    return data;
  }

  UpdateProfileReqModel.fromJson(Map<String, dynamic> json) {
    fullName = json['full_name'];
    dateOfBirth = json['date_of_birth'];
    address = json['address'];
  }
}
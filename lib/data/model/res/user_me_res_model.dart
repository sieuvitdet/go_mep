
class UserMeResModel {
  int? id;
  String? hashId;
  String? phoneNumber;
  String? fullName;
  String? dateOfBirth;
  String? address;
  String? userType;
  bool? isActive;
  bool? isSuperuser;

  UserMeResModel({
    this.id,
    this.hashId,
    this.phoneNumber,
    this.fullName,
    this.dateOfBirth,
    this.address,
    this.userType,
    this.isActive,
    this.isSuperuser,
  });

  UserMeResModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    hashId = json['hash_id'];
    phoneNumber = json['phone_number'];
    fullName = json['full_name'];
    dateOfBirth = json['date_of_birth'];
    address = json['address'];
    userType = json['user_type'];
    isActive = json['is_active'];
    isSuperuser = json['is_superuser'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['hash_id'] = hashId;
    data['phone_number'] = phoneNumber;
    data['full_name'] = fullName;
    data['date_of_birth'] = dateOfBirth;
    data['address'] = address;
    data['user_type'] = userType;
    data['is_active'] = isActive;
    data['is_superuser'] = isSuperuser;
    return data;
  }
}

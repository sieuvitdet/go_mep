
class UserMeResModel {
  String? id;
  String? username;
  String? email;
  String? fullName;
  String? birthday;
  String? gender;
  String? phoneNumber;
  String? address;
  String? avatar;
  String? note;

  UserMeResModel({
    this.id,
    this.username,
    this.email,
    this.fullName,
    this.birthday,
    this.gender,
    this.phoneNumber,
    this.address,
    this.avatar,
    this.note,
  });

  UserMeResModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    fullName = json['fullName'];
    birthday = json['birthday'];
    gender = json['gender'];
    phoneNumber = json['phoneNumber'];
    address = json['address'];
    avatar = json['avatar'];
    note = json['note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    data['fullName'] = this.fullName;
    data['birthday'] = this.birthday;
    data['gender'] = this.gender;
    data['phoneNumber'] = this.phoneNumber;
    data['address'] = this.address;
    data['avatar'] = this.avatar;
    data['note'] = this.note;
    return data;
  }
}

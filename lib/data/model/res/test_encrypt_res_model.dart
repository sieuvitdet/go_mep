class TestEncryptResModel {
  String? result;
  bool? isAcknowledge;
  int? statusCode;
  dynamic errors;

  TestEncryptResModel({
    this.result,
    this.isAcknowledge,
    this.statusCode,
    this.errors,
  });

  TestEncryptResModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    isAcknowledge = json['isAcknowledge'];
    statusCode = json['statusCode'];
    errors = json['errors'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['result'] = result;
    data['isAcknowledge'] = isAcknowledge;
    data['statusCode'] = statusCode;
    data['errors'] = errors;
    return data;
  }
}

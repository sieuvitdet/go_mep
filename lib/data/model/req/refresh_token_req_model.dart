class RefreshTokenReqModel {
  final String token;

  RefreshTokenReqModel({required this.token});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['token'] = token;
    return data;
  }
}

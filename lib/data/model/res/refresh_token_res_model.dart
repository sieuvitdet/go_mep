class RefreshTokenResModel {
  final String? refreshToken;
  final String? accessToken;

  RefreshTokenResModel({this.refreshToken, this.accessToken});

  factory RefreshTokenResModel.fromJson(Map<String, dynamic> json) {
    return RefreshTokenResModel(
      refreshToken: json['refreshToken'],
      accessToken: json['accessToken'],
    );
  }
}

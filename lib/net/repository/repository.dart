import 'package:go_mep_application/data/model/req/login_req_model.dart';
import 'package:go_mep_application/data/model/req/refresh_token_req_model.dart';
import 'package:go_mep_application/data/model/req/change_password_req_model.dart';
import 'package:go_mep_application/data/model/req/reset_password_request_req_model.dart';
import 'package:go_mep_application/data/model/req/reset_password_req_model.dart';
import 'package:go_mep_application/data/model/req/notification_req_model.dart';
import 'package:go_mep_application/data/model/req/geocoding_req_model.dart';
import 'package:go_mep_application/data/model/res/test_encrypt_res_model.dart';
import 'package:go_mep_application/net/http/http_connection.dart';
import 'package:go_mep_application/net/api/api.dart';
import 'package:go_mep_application/net/api/interaction.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Repository {
  static login(BuildContext context, LoginReqModel model,
          {bool showError = false}) =>
      Interaction(
              context: context,
              url: API.login(),
              param: model.toJson(),
              showError: true)
          .post();

  static refreshToken(BuildContext context, RefreshTokenReqModel model,
          {bool showError = false}) =>
      Interaction(
              context: context,
              url: API.refreshToken(),
              param: model.toJson(),
              showError: true)
          .post();

  static changePassword(BuildContext context, ChangePasswordReqModel model,
          {bool showError = false}) =>
      Interaction(
              context: context,
              url: API.changePassword(),
              param: model.toJson(),
              showError: true)
          .post();

  static requestResetPassword(
          BuildContext context, ResetPasswordRequestReqModel model,
          {bool showError = false}) =>
      Interaction(
              context: context,
              url: API.requestResetPassword(),
              param: model.toJson(),
              showError: true)
          .post();

  static logout(BuildContext context, {bool showError = false}) => Interaction(
          context: context, url: API.logout(), param: {}, showError: true)
      .post();

  static accountCheck(BuildContext context, String username,
          {bool showError = false}) =>
      Interaction(
              context: context,
              url:
                  "/api/auth/account-check?username=$username&${API.apiVersion}",
              param: null,
              showError: true)
          .post();

  static resetPassword(BuildContext context, ResetPasswordReqModel model,
          {bool showError = false}) =>
      Interaction(
              context: context,
              url: API.resetPassword(),
              param: model.toJson(),
              showError: true)
          .post();

  static resetTokenInfo(BuildContext context, {bool showError = false}) =>
      Interaction(
              context: context,
              url: API.resetTokenInfo(),
              param: {},
              showError: true)
          .get();

  static getUserMe(BuildContext context, {bool showError = false}) =>
      Interaction(
              context: context, url: API.userMe(), param: {}, showError: false)
          .get();

  static getNotifications(BuildContext context, NotificationReqModel model,
          {bool showError = false}) =>
      Interaction(
              context: context,
              url: API.notifications(
                  pageNumber: model.pageNumber, pageSize: model.pageSize),
              param: {},
              showError: showError)
          .get();

  static getGeocodingReverse(BuildContext context, GeocodingReqModel model,
          {bool showError = false}) =>
      Interaction(
              context: context,
              url: API.geocodingReverse(model),
              showError: showError)
          .get();

  static bulkUploadAttachments(
          BuildContext context, List<MultipartFileModel> files,
          {bool showError = false, int expiryInSeconds = 3600}) =>
      Interaction(
              context: context,
              url: API.bulkUploadAttachments(expiryInSeconds: expiryInSeconds),
              param: {},
              files: files,
              showError: showError)
          .post();

  static getVehicleDetail(BuildContext context, String vehicleId,
          {bool showError = false}) =>
      Interaction(
              context: context,
              url: API.vehicleDetail(vehicleId),
              param: {},
              showError: showError)
          .get();

  static testEncrypt(BuildContext context, String password,
          {bool showError = false}) =>
      _TestEncryptInteraction(
              context: context,
              password: password,
              showError: false)
          .post();
}

class _TestEncryptInteraction extends Interaction {
  final String password;

  _TestEncryptInteraction({
    required BuildContext context,
    required this.password,
    bool showError = false,
  }) : super(
          context: context,
          url: API.testEncrypt(),
          param: null,
          showError: showError,
        );

  @override
  Map<String, dynamic>? get bodyParam => null;

  // Override to send raw string instead of JSON object
  @override
  Future<ResponseModel> post() async {
    try {
      final dio = Dio();
      Map<String, String> headers = {
        'Content-Type': 'application/json-patch+json',
        'Accept': '*/*',
      };

      final response = await dio.post(
        baseUrl! + apiUrl,
        data: '"$password"',
        options: Options(headers: headers),
      );

      TestEncryptResModel testEncryptResModel = TestEncryptResModel.fromJson(response.data);

      return ResponseModel(
        result: testEncryptResModel.toJson(),
        success: true,
        statusCode: response.statusCode,
        isAcknowledge: testEncryptResModel.isAcknowledge,
        errors: testEncryptResModel.errors,
      );
    } catch (e) {
      return ResponseModel(
        result: null,
        success: false,
        statusCode: 400,
        isAcknowledge: false,
        errors: null,
      );
    }
  }
}

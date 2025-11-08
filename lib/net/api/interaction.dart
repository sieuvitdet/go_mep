import 'package:go_mep_application/common/theme/globals/globals.dart';
import 'package:go_mep_application/common/utils/custom_navigator.dart';
import 'package:go_mep_application/common/utils/utility.dart';
import 'package:go_mep_application/common/widgets/widget.dart';
import 'package:go_mep_application/data/local/local/shared_prefs/shared_prefs_key.dart';
import 'package:go_mep_application/data/model/req/refresh_token_req_model.dart';
import 'package:go_mep_application/data/model/res/refresh_token_res_model.dart';
import 'package:go_mep_application/net/http/http_connection.dart';
import 'package:go_mep_application/net/http/http_status_code.dart';
import 'package:go_mep_application/net/repository/repository.dart';
import 'package:go_mep_application/presentation/auth/login/ui/login_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'api.dart';

class Interaction extends HttpConnection<ResponseModel> {
  final BuildContext context;
  final String url;
  final Map<String, dynamic>? param;
  final Map<String, String>? header;
  final List<MultipartFileModel>? files;
  final bool showError;
  final String screenName;

  static bool _isShowingErrorPopup = false;
  static String? _lastErrorMessage;

  // Refresh token concurrency management
  static bool _isRefreshing = false;
  static Completer<ResponseModel>? _refreshCompleter;
  static final List<Completer<ResponseModel>> _waitingRequestsCompleters = [];

  Interaction({
    required this.context,
    required this.url,
    this.param,
    this.header,
    this.files,
    this.screenName = "",
    this.showError = true,
  });

  @override
  // TODO: implement apiUrl
  String get apiUrl => url;

  @override
  // TODO: implement bodyParam
  Map<String, dynamic>? get bodyParam => param;

  @override
  // TODO: implement headerParam
  Map<String, String>? get headerParam => header;

  @override
  // TODO: implement listFile
  List<MultipartFileModel>? get listFile => files;

  @override
  // TODO: implement baseUrl
  String? get baseUrl => API.server;

  @override
  // TODO: implement tokenKey
  String get tokenKey => SharedPrefsKey.token;

  @override
  // TODO: implement tokenKey
  String get versionName => SharedPrefsKey.version_name;

  /// Handles refresh token with concurrency control to prevent multiple simultaneous calls
  static Future<ResponseModel> _handleRefreshToken(BuildContext context) async {
    // If already refreshing, wait for the result
    if (_isRefreshing) {
      final completer = Completer<ResponseModel>();
      _waitingRequestsCompleters.add(completer);
      return completer.future;
    }

    // Start refreshing
    _isRefreshing = true;
    _refreshCompleter = Completer<ResponseModel>();

    try {
      String refreshToken =
          Globals.prefs.getString(SharedPrefsKey.refresh_token);
      ResponseModel response = await Repository.refreshToken(
        context,
        RefreshTokenReqModel(token: refreshToken),
      );

      // Complete all waiting requests with the same result
      for (final completer in _waitingRequestsCompleters) {
        if (!completer.isCompleted) {
          completer.complete(response);
        }
      }
      _waitingRequestsCompleters.clear();

      if (!_refreshCompleter!.isCompleted) {
        _refreshCompleter!.complete(response);
      }

      return response;
    } catch (error) {
      // Handle error for all waiting requests
      final errorResponse = ResponseModel(
        success: false,
        statusCode: 401,
        message: "Refresh token failed",
      );

      for (final completer in _waitingRequestsCompleters) {
        if (!completer.isCompleted) {
          completer.complete(errorResponse);
        }
      }
      _waitingRequestsCompleters.clear();

      if (!_refreshCompleter!.isCompleted) {
        _refreshCompleter!.complete(errorResponse);
      }

      return errorResponse;
    } finally {
      _isRefreshing = false;
      _refreshCompleter = null;
    }
  }

  /// Resets the refresh token state - call this when user logs out or app starts
  static void resetRefreshTokenState() {
    _isRefreshing = false;
    _refreshCompleter = null;

    // Complete any pending requests with error
    for (final completer in _waitingRequestsCompleters) {
      if (!completer.isCompleted) {
        completer.complete(ResponseModel(
          success: false,
          statusCode: 401,
          message: "Session reset",
        ));
      }
    }
    _waitingRequestsCompleters.clear();
  }

  @override
  Future<ResponseModel> handleError(ResponseModel model) async {
    // Check for token expiration error
    if (HttpStatusCode.tokenExpire.contains(model.statusCode) &&
        (model.message == "")) {
      // Use concurrency-controlled refresh token
      ResponseModel response = await _handleRefreshToken(context);

      if (response.success == true) {
        RefreshTokenResModel responseModel =
            RefreshTokenResModel.fromJson(response.result ?? {});
        Globals.prefs.setString(
            SharedPrefsKey.refresh_token, responseModel.refreshToken ?? "");
        Globals.prefs
            .setString(SharedPrefsKey.token, responseModel.accessToken ?? "");

        // Retry với token mới
        ResponseModel retryResult = await retry();

        // Nếu retry vẫn trả về 401, thì mới hiện popup đăng nhập lại
        if (HttpStatusCode.tokenExpire.contains(retryResult.statusCode)) {
          if (!Globals.alreadyShowPopupExpired) {
            Globals.alreadyShowPopupExpired = true;
            await CustomNavigator.showCustomAlertDialog(
                context, "Vui lòng đăng nhập lại",
                title: "Phiên làm việc đã hết hạn",
                type: CustomAlertDialogType.error,
                enableCancel: false,
                textSubmitted: "Đăng nhập lại",
                cancelable: false, onSubmitted: () async {
              CustomNavigator.pop(context);
              Globals.prefs.dispose();
              CustomNavigator.popToRootAndPushReplacement(
                  context, LoginScreen());
            });
          }
          return retryResult;
        }

        // Nếu retry thành công, trả về kết quả
        return retryResult;
      } else {
        // Refresh token thất bại, hiện popup đăng nhập lại
        if (!Globals.alreadyShowPopupExpired) {
          Globals.alreadyShowPopupExpired = true;
          await CustomNavigator.showCustomAlertDialog(
              context, "Vui lòng đăng nhập lại",
              title: "Phiên làm việc đã hết hạn",
              type: CustomAlertDialogType.error,
              enableCancel: false,
              textSubmitted: "Đăng nhập lại",
              cancelable: false, onSubmitted: () async {
            CustomNavigator.pop(context);
            Globals.prefs.dispose();
            CustomNavigator.popToRootAndPushReplacement(context, LoginScreen());
          });
        }
      }
    } else {
      if (Globals.connectFail) {
        if (!_isShowingErrorPopup && model.message != _lastErrorMessage) {
          _isShowingErrorPopup = true;
          _lastErrorMessage = model.message;
          await CustomNavigator.showCustomAlertDialog(
              context, model.message ?? "Hãy kiểm tra lại kết nối mạng",
              title: "Lỗi kết nối mạng",
              type: CustomAlertDialogType.error,
              cancelable: false, onSubmitted: () async {
            _lastErrorMessage = "resetCheckConenect";
            CustomNavigator.pop(context);
          });
          _isShowingErrorPopup = false;
        }
      } else {
        if (showError && model.message != null && model.message != "") {
          await CustomNavigator.showCustomAlertDialog(
            context,
            model.message!,
            title: "Lỗi",
            type: CustomAlertDialogType.error,
            cancelable: false,
          );
        }
      }
    }
    return model;
  }

  @override
  Future<ResponseModel> handleResponse(Response? response) async {
    if (response == null) {
      return getError("Lỗi kết nối", errorCode: 401);
    }
    var responseBody = response.data;
    Utility.customPrint(responseBody);

    if (response.data is String &&
        response.data != "" &&
        response.statusCode == 200) {
      return ResponseModel(
        result: {"result": response.data},
        success: true,
        statusCode: 200,
        isAcknowledge: false,
      );
    }

    ResponseModel responseModel = ResponseModel.fromJson(response.data);

    if (HttpStatusCode.success.contains(response.statusCode)) {
      if (responseModel.isAcknowledge == false ||
          responseModel.errors != null) {
        return await handleError(responseModel);
      }

      return responseModel;
    } else {
      if (responseModel.message == null || responseModel.message == "") {
        responseModel.message = "Lỗi server";
      }
      return await handleError(responseModel);
    }
  }

  @override
  ResponseModel getError(String? error, {int? errorCode}) {
    return ResponseModel(
      message: error,
      success: false,
      statusCode: errorCode,
      isAcknowledge: false,
    );
  }
}

class GlobalError {
  String? code;
  String? message;

  GlobalError({this.code, this.message});

  GlobalError.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
    };
  }
}

class FieldError {
  String? field;
  String? code;
  String? message;

  FieldError({this.field, this.code, this.message});

  FieldError.fromJson(Map<String, dynamic> json) {
    field = json['field'];
    code = json['code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    return {
      'field': field,
      'code': code,
      'message': message,
    };
  }
}

class ErrorsModel {
  GlobalError? globalError;
  List<FieldError>? fieldErrors;

  ErrorsModel({this.globalError, this.fieldErrors});

  ErrorsModel.fromJson(Map<String, dynamic> json) {
    globalError = json['globalError'] != null
        ? GlobalError.fromJson(json['globalError'])
        : null;
    fieldErrors = json['fieldErrors'] != null
        ? (json['fieldErrors'] as List)
            .map((e) => FieldError.fromJson(e))
            .toList()
        : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'globalError': globalError?.toJson(),
      'fieldErrors': fieldErrors?.map((e) => e.toJson()).toList(),
    };
  }
}

class ResponseModel {
  Map<String, dynamic>? result;
  List<dynamic>? results;
  String? message;
  bool? success;
  int? statusCode;
  bool? isAcknowledge;
  ErrorsModel? errors;

  ResponseModel({
    this.result,
    this.results,
    this.message,
    this.success,
    this.statusCode,
    this.isAcknowledge,
    this.errors,
  });

  ResponseModel.fromJson(Map<String, dynamic> json) {
    // Handle message from root or from errors.globalError
    if (json['message'] != null) {
      message = json['message'].toString();
    } else if (json['errors'] != null &&
        json['errors']['globalError'] != null &&
        json['errors']['globalError']['message'] != null) {
      message = json['errors']['globalError']['message'].toString();
    }

    // Handle result/results - Map 'data' field to 'result'
    result = null;
    results = null;
    if (json['data'] != null) {
      if (json['data'] is Map<String, dynamic>) {
        result = json['data'];
      } else if (json['data'] is List<dynamic>) {
        results = json['data'];
      }
    } else if (json['result'] != null) {
      // Fallback to old 'result' field for backward compatibility
      if (json['result'] is Map<String, dynamic>) {
        result = json['result'];
      } else if (json['result'] is List<dynamic>) {
        results = json['result'];
      }
    }

    // Handle status code and success - Use 'success' field directly
    statusCode = json['statusCode'];
    success = json['success'] ?? HttpStatusCode.success.contains(statusCode);
    isAcknowledge = json['isAcknowledge'];

    // Handle errors
    if (json['errors'] != null) {
      errors = ErrorsModel.fromJson(json['errors']);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'data': result ?? results,
      'result': result ?? results, // Keep for backward compatibility
      'message': message,
      'success': success,
      'statusCode': statusCode,
      'isAcknowledge': isAcknowledge,
      'errors': errors?.toJson(),
    };
  }
}

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:go_mep_application/common/theme/globals/globals.dart';
import 'package:go_mep_application/common/utils/utility.dart';
import 'package:go_mep_application/net/http/http_status_code.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';

abstract class HttpConnection<T> {
  final String _typeApplication = "application/json";
  final String _typeMultipart = "multipart/form-data";
  final String _typeUrlencoded = "application/x-www-form-urlencoded";
  final String _tag = "HttpConnection";
  final int _timeOut = 120;
  ApiConnectionMethod? _method;
  String? _fullURL;
  late bool _isJson;

  String get apiUrl;
  String? get baseUrl;
  Map<String, dynamic>? get bodyParam;
  Map<String, String>? get headerParam;
  List<MultipartFileModel>? get listFile;
  String get tokenKey;
  String get versionName;
  String get screenName;

  static Dio? _dio;

  static createDio() {
    _dio = Dio();
  }

  Future<Map<String, String>> _headers(Map<String, String>? content) async {
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader:
          listFile == null ? _typeApplication : _typeMultipart,
      HttpHeaders.userAgentHeader: "Delta-Innvie-Mobile/1.0.0",
      'Accept': 'application/json',
      'Cache-Control': 'no-cache',
    };

    String token = Globals.prefs.getString(tokenKey);
    if (token != "") {
      headers['Authorization'] = "Bearer $token";
    }

    if (content != null) {
      content.forEach((key, value) {
        headers[key] = value;
      });
    }

    return headers;
  }

  Future<T> retry() {
    if (_dio == null) createDio();
    if (_method == ApiConnectionMethod.GET) {
      return get();
    } else if (_method == ApiConnectionMethod.POST) {
      return post();
    } else if (_method == ApiConnectionMethod.PATCH) {
      return patch();
    } else if (_method == ApiConnectionMethod.PUT) {
      return put();
    } else if (_method == ApiConnectionMethod.DELETE) {
      return delete();
    }  else {
      return getGoogleApi();
    }
  }

  Future<T> get({bool getBytes = false}) async {
    if (_dio == null) createDio();
    _method = ApiConnectionMethod.GET;
    _isJson = false;
    String fullUrl = baseUrl! + apiUrl;

    if (bodyParam != null) {
      String body = "?";
      bodyParam!.forEach((key, value) {
        try {
          List<dynamic> values = value;
          values.forEach((data) {
            body = body + key + "=" + data.toString() + "&";
          });
        } catch (ex) {
          body = body + key + "=" + value.toString() + "&";
        }
      });
      body = body.substring(0, body.length - 1);
      fullUrl = fullUrl + body;
    }

    _fullURL = fullUrl;

    return await _handleConnection(getBytes: getBytes);
  }

  Future<T> post() async {
    if (_dio == null) createDio();
    _method = ApiConnectionMethod.POST;

    bool isJson = true;
    if (bodyParam == null)
      isJson = false;
    else {
      if (headerParam != null) {
        isJson = !headerParam!.values.contains(_typeUrlencoded);
      }
    }

    _fullURL = baseUrl! + apiUrl;
    _isJson = isJson;
    return await _handleConnection();
  }

  Future<T> patch() async {
    if (_dio == null) createDio();
    _method = ApiConnectionMethod.PATCH;

    bool isJson = true;
    if (bodyParam == null)
      isJson = false;
    else {
      if (headerParam != null) {
        isJson = !headerParam!.values.contains(_typeUrlencoded);
      }
    }

    _fullURL = baseUrl! + apiUrl;
    _isJson = isJson;
    return await _handleConnection();
  }

  Future<T> put() async {
    if (_dio == null) createDio();
    _method = ApiConnectionMethod.PUT;

    bool isJson = true;
    if (bodyParam == null)
      isJson = false;
    else {
      if (headerParam != null) {
        isJson = !headerParam!.values.contains(_typeUrlencoded);
      }
    }

    _fullURL = baseUrl! + apiUrl;
    _isJson = isJson;
    return await _handleConnection();
  }

  Future<T> delete() async {
    if (_dio == null) createDio();
    _method = ApiConnectionMethod.DELETE;

    bool isJson = true;
    if (bodyParam == null)
      isJson = false;
    else {
      if (headerParam != null) {
        isJson = !headerParam!.values.contains(_typeUrlencoded);
      }
    }

    _fullURL = baseUrl! + apiUrl;
    _isJson = isJson;
    return await _handleConnection();
  }

  Future<T> getGoogleApi() async {
    if (_dio == null) createDio();
    _method = ApiConnectionMethod.GET;

    _fullURL = apiUrl;

    return _handleConnection();
  }

  Future<bool> checkConnectivity() async {
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());
    if (!connectivityResult.contains(ConnectivityResult.mobile) &&
        !connectivityResult.contains(ConnectivityResult.wifi)) {
      return false;
    } else {
      return true;
    }
  }

  Future<T?> _checkConnectivity() async {
    if ((await checkConnectivity()) == false) {
      Globals.connectFail = true;
      return getError("Lỗi kết nối");
    }
    Globals.connectFail = false;
    return null;
  }

  Future<T> _handleConnection({bool getBytes = false}) async {
    T? data = await _checkConnectivity();
    if (data != null) {
      return await handleError(data);
    }
    Map<String, String?> finalHeader = await _headers(headerParam);

    String curlCommand =
        "curl -X ${_method.toString().split('.').last} '$_fullURL'";
    if (finalHeader.isNotEmpty) {
      finalHeader.forEach((key, value) {
        curlCommand += " -H '$key: $value'";
      });
    }
    String path = baseUrl! + apiUrl;

    var response;
    try {
      dynamic body = _isJson ? json.encode(bodyParam) : bodyParam;

      if ((_method == ApiConnectionMethod.POST ||
              _method == ApiConnectionMethod.PATCH ||
              _method == ApiConnectionMethod.PUT) &&
          bodyParam != null) {
        curlCommand += " -d '" + json.encode(bodyParam) + "'";
      }

      Utility.customPrint("$_tag Curl Command: $curlCommand");
      Utility.customPrint("$_tag Request Body: $body");
      Utility.customPrint("$_tag Body Param: $bodyParam");
      if (listFile == null) {
        var options = getOptionAPI(
            method: _method?.valueOf ?? "",
            headers: finalHeader,
            responseType: getBytes ? ResponseType.bytes : ResponseType.json);
        if (getBytes) {
          response = await _dio?.get(
            path,
            queryParameters: bodyParam,
            options: options,
          );
        } else {
          response = await _dio?.request(path, options: options, data: body);
          
        }
      } else {
        // Headers
        var options =
            getOptionAPI(method: _method?.valueOf ?? "", headers: finalHeader);
        // Form data
        FormData formData = FormData();

        if (bodyParam != null && bodyParam!.isNotEmpty) {
          bodyParam!.forEach((key, value) {
            try {
              Map<String, dynamic>? map = value;
              formData.fields.add(MapEntry(key, json.encode(map)));
            } catch (_) {
              formData.fields.add(MapEntry(key, value.toString()));
            }
          });
        }

        if (listFile != null && listFile!.isNotEmpty) {
          for (int i = 0; i < listFile!.length; i++) {
            MultipartFileModel model = listFile![i];

            if (model.file != null) {
              String name = basename(model.file!.path);
              formData.files.add(
                MapEntry(
                  model.name ?? name,
                  await MultipartFile.fromFile(
                    model.file!.path,
                    contentType: MediaType.parse(_typeMultipart),
                    filename: model.nameFormat?.isNotEmpty == true
                        ? model.nameFormat
                        : name,
                  ),
                ),
              );
            } else if (model.bytes != null) {
              String name = "${DateTime.now().millisecondsSinceEpoch}$i.jpg";
              formData.files.add(
                MapEntry(
                  model.name ?? name,
                  MultipartFile.fromBytes(
                    model.bytes!,
                    contentType: MediaType.parse(_typeMultipart),
                    filename: model.nameFormat?.isNotEmpty == true
                        ? model.nameFormat
                        : name,
                  ),
                ),
              );
            }
          }
        }

        // Send the request
        try {
          response = await _dio!
              .post(
                path,
                data: formData,
                options: options,
              )
              .timeout(Duration(seconds: _timeOut));
        } catch (e) {
          Utility.customPrint("$_tag Error: $e");
          rethrow; // Re-throw the error after logging
        }
      }
    } on TimeoutException catch (error) {
      response = getError("$_fullURL \n$error");
      return await handleError(getError(""));
    } on SocketException catch (_) {
      response = getError("Lỗi kết nối mạng: Không thể kết nối tới server");
      return await handleError(getError("Lỗi kết nối mạng"));
    } on ArgumentError catch (error) {
      response = getError("$_fullURL \n$error");
      return await handleError(getError(""));
    } on DioException catch (e) {
      if (HttpStatusCode.error.contains(e.response?.statusCode)) {
        String errorMessage = "";
        try {
          if (e.response?.data is Map) {
            // Check for standard API response message field first
            if (e.response?.data["message"] != null) {
              errorMessage = e.response?.data["message"]?.toString() ?? "";
            }
            // Check for the new error structure
            else if (e.response?.data["errors"] != null &&
                e.response?.data["errors"]["globalError"] != null) {
              errorMessage =
                  e.response?.data["errors"]["globalError"]["message"] ?? "";
            } else if (e.response?.data["errors"] != null &&
                e.response?.data["errors"]["fieldErrors"] != null &&
                e.response?.data["errors"]["fieldErrors"] is List &&
                e.response?.data["errors"]["fieldErrors"].isNotEmpty) {
              // Fallback to old structure
              errorMessage =
                  e.response?.data["errors"]["fieldErrors"][0]["message"];
            }
          }
        } catch (_) {
          errorMessage = "";
        }
        response = getError(errorMessage, errorCode: e.response?.statusCode!);
      } else {
        response = getError("");
      }
      return await handleError(response);
    } catch (error) {
      response = getError("$_fullURL \n$error");
      return await handleError(getError(""));
    }
    return await handleResponse(response);
  }

  T getError(String? error, {int? errorCode});

  Future<T> handleError(T model);

  Future<T> handleResponse(Response? response);

  Options getOptionAPI({
    required String method,
    required Map<String, dynamic>? headers,
    ResponseType responseType = ResponseType.json,
  }) {
    return Options(
        sendTimeout: Duration(seconds: _timeOut),
        receiveTimeout: Duration(seconds: _timeOut),
        contentType: _typeApplication,
        headers: headers,
        method: method,
        responseType: responseType);
  }
}

enum ApiConnectionMethod { GET, POST, PATCH, PUT, DELETE, GOOGLE, APPLE }

extension MethodExtension on ApiConnectionMethod {
  String get valueOf {
    switch (this) {
      case ApiConnectionMethod.GET:
        return 'GET';
      case ApiConnectionMethod.POST:
        return 'POST';
      case ApiConnectionMethod.PATCH:
        return 'PATCH';
      case ApiConnectionMethod.PUT:
        return 'PUT';
      case ApiConnectionMethod.DELETE:
        return 'DELETE';
      case ApiConnectionMethod.GOOGLE:
        return 'GOOGLE';
      case ApiConnectionMethod.APPLE:
        return 'APPLE';
    }
  }
}

class MultipartFileModel {
  File? file;
  Uint8List? bytes;
  String? name;
  String? nameFormat;

  MultipartFileModel({this.file, this.bytes, this.name, this.nameFormat});
}

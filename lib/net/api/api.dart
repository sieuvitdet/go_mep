import 'package:go_mep_application/common/theme/globals/globals.dart';
import 'package:go_mep_application/data/model/req/geocoding_req_model.dart';

class API {
  static String? get server => Globals.config.server;
  static String get successCode => "success";
  static String get fail => "fail";
  static bool get success => true;
  static String get gateway => "/api";

  static login() => "$gateway/v1/auth/login";
  static register() => "$gateway/v1/auth/register";
  static refreshToken() => "$gateway/auth/refresh-token";
  static changePassword() => "$gateway/auth/change-password";
  static requestResetPassword() =>
      "$gateway/auth/request-reset-password";
  static verifyResetPassword() => "$gateway/auth/verify-reset-password";
  static logout() => "$gateway/v1/auth/logout";
  static accountCheck() => "$gateway/auth/account-check";
  static resetPassword() => "$gateway/auth/reset-password";
  static resetTokenInfo() => "$gateway/auth/reset-token-info";
  static userMe() => "$gateway/v1/auth/me";
  static updateProfile() => "$gateway/v1/auth/update-profile";
  static placesSearch() => "$gateway/v1/places/search";
  static notifications({required int pageNumber, required int pageSize}) =>
      "$gateway/v1/notifications?pageNumber=$pageNumber&pageSize=$pageSize";
}

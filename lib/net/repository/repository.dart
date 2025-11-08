import 'package:go_mep_application/data/model/req/login_req_model.dart';
import 'package:go_mep_application/data/model/req/register_req_model.dart';
import 'package:go_mep_application/data/model/req/update_profile_req_model.dart';
import 'package:go_mep_application/data/model/req/places_search_req_model.dart';
import 'package:go_mep_application/data/model/req/refresh_token_req_model.dart';
import 'package:go_mep_application/data/model/req/change_password_req_model.dart';
import 'package:go_mep_application/data/model/req/reset_password_request_req_model.dart';
import 'package:go_mep_application/data/model/req/reset_password_req_model.dart';
import 'package:go_mep_application/data/model/req/notification_req_model.dart';
import 'package:go_mep_application/net/api/api.dart';
import 'package:go_mep_application/net/api/interaction.dart';
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

  static register(BuildContext context, RegisterReqModel model,
          {bool showError = false}) =>
      Interaction(
              context: context,
              url: API.register(),
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


  static logout(BuildContext context, {bool showError = false}) => Interaction(
          context: context, url: API.logout(), param: {}, showError: true)
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

  static updateProfile(BuildContext context, UpdateProfileReqModel model,
          {bool showError = false}) =>
      Interaction(
              context: context,
              url: API.updateProfile(),
              param: model.toJson(),
              showError: true)
          .put();

  static getNotifications(BuildContext context, NotificationReqModel model,
          {bool showError = false}) =>
      Interaction(
              context: context,
              url: API.notifications(
                  pageNumber: model.pageNumber, pageSize: model.pageSize),
              param: {},
              showError: showError)
          .get();

  static searchPlaces(BuildContext context, PlacesSearchReqModel model,
          {bool showError = false}) =>
      Interaction(
              context: context,
              url: API.placesSearch(),
              param: model.toJson(),
              showError: showError)
          .post();

  static requestResetPassword(BuildContext context, ResetPasswordRequestReqModel model,
          {bool showError = false}) =>
      Interaction(
              context: context,
              url: API.requestResetPassword(),
              param: model.toJson(),
              showError: true)
          .post();

  static verifyResetPassword(BuildContext context, OtpVerifyReqModel model,
          {bool showError = false}) =>
      Interaction(
              context: context,
              url: API.verifyResetPassword(),
              param: model.toJson(),
              showError: true)
          .post();
}
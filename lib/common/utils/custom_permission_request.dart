import 'dart:io';
import 'package:go_mep_application/common/utils/custom_navigator.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class CustomPermissionRequest {
  static Future<bool> request(BuildContext context, Permission type) async {
    PermissionStatus status = await (await parsePermission(type)).request();
    if (status.isPermanentlyDenied || status.isLimited) {
      String? permission;
      if (type == Permission.camera) {
        permission = "Camera";
      } else if (type == Permission.location ||
          type == Permission.locationWhenInUse ||
          type == Permission.locationAlways) {
        permission = "Location";
      } else if (type == Permission.storage || type == Permission.photos) {
        permission = "Storage";
      } else if (type == Permission.notification) {
        permission = "Notification";
      } else if (type == Permission.microphone) {
        permission = "Microphone";
      }

      if (status.isPermanentlyDenied) {
        CustomNavigator.showCustomAlertDialog(
            context, "Bạn cần cấp quyền $permission để sử dụng tính năng này",
            title: "Yêu cầu quyền",
            enableCancel: true,
            textSubmitted: "Cho phép", onSubmitted: () {
          CustomNavigator.pop(context);
          openAppSettings();
        });
      } else {
        CustomNavigator.showCustomAlertDialog(
            context, "Bạn cần cấp quyền $permission để sử dụng tính năng này",
            title: "Yêu cầu quyền",
            enableCancel: true,
            textSubmitted: "Cho phép", onSubmitted: () {
          CustomNavigator.pop(context);
          openAppSettings();
        });
      }
    }

    return status.isGranted;
  }

  static Future<bool> check(Permission type) async {
    return (await parsePermission(type)).isGranted;
  }

  static Future<Permission> parsePermission(Permission type) async {
    if (Platform.isAndroid) {
      if (type == Permission.photos || type == Permission.storage) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        if (androidInfo.version.sdkInt <= 32) {
          return Permission.storage;
        }
        return Permission.photos;
      } else if (type == Permission.locationAlways) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        if (androidInfo.version.sdkInt <= 28) {
          return Permission.location;
        }
      }
    }
    return type;
  }
}

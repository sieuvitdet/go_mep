import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:go_mep_application/common/utils/custom_permission_request.dart';
import 'package:go_mep_application/common/utils/device_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_actions/keyboard_actions_config.dart';
import 'package:keyboard_actions/keyboard_actions_item.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:go_mep_application/common/lang_key/lang_key.dart';
import 'package:go_mep_application/common/localization/app_localizations.dart';
import 'package:go_mep_application/common/theme/app_colors.dart';
import 'package:go_mep_application/common/theme/app_dimens.dart';
import 'package:go_mep_application/common/theme/app_format.dart';
import 'package:go_mep_application/common/theme/constant/constant.dart';
import 'package:go_mep_application/common/theme/globals/globals.dart';
import 'package:go_mep_application/common/widgets/widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher.dart' as urlLauncher;

import 'custom_navigator.dart';

class Utility {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9]([a-zA-Z0-9._+-]*[a-zA-Z0-9])?@[a-zA-Z0-9]([a-zA-Z0-9.-]*[a-zA-Z0-9])?\.[a-zA-Z]{2,}$',
  );

  static closeApp() {
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }

  static hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  static fieldFocus(BuildContext context, FocusNode? focusNode) {
    FocusScope.of(context).requestFocus(focusNode);
  }

  static configKeyboardActions(List<KeyboardActionsItem> actions) {
    return KeyboardActionsConfig(
        keyboardBarColor: Colors.grey[200], actions: actions);
  }

  /// Gets the safe area bottom padding for Android gesture navigation
  /// This ensures buttons aren't covered by system navigation
  static double getBottomSafeAreaPadding(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    // On Android, add extra padding if there's system navigation
    if (Platform.isAndroid && bottomPadding > 0) {
      return bottomPadding;
    }
    return 0.0;
  }

  /// Wraps a widget with safe area padding for bottom buttons
  static Widget wrapWithBottomSafeArea(BuildContext context, Widget child, {EdgeInsets? additionalPadding}) {
    final bottomSafeArea = getBottomSafeAreaPadding(context);
    final padding = additionalPadding ?? EdgeInsets.zero;
    
    return Padding(
      padding: EdgeInsets.only(
        left: padding.left,
        top: padding.top,
        right: padding.right,
        bottom: padding.bottom + bottomSafeArea,
      ),
      child: child,
    );
  }

  static changeStatusBarColor(Color color, bool isDark) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: color,
        statusBarIconBrightness: isDark ? Brightness.dark : Brightness.light));
  }

  static setStatusBarForBackground(Color backgroundColor) {
    final isDark = _isColorDark(backgroundColor);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness:
          isDark ? Brightness.light : Brightness.dark,
    ));
  }

  static bool _isColorDark(Color color) {
    final double relativeLuminance = color.computeLuminance();
    return relativeLuminance < 0.5;
  }

  static bool isEmail(String? value) {
    if (value == null || value.isEmpty) return false;
    return _emailRegExp.hasMatch(value);
  }

  static bool isPassword(String? value) {
    if (value == null || value.isEmpty) return false;

    if (value.length < 8) return false;
    bool hasUppercase = RegExp(r'[A-Z]').hasMatch(value);

    bool hasLowercase = RegExp(r'[a-z]').hasMatch(value);

    bool hasNumber = RegExp(r'[0-9]').hasMatch(value);

    bool hasSpecialChar =
        RegExp(r'[!@#$%^&*()_+\-=\[\]{};:"\\|,.<>/?]').hasMatch(value);

    return hasUppercase && hasLowercase && hasNumber && hasSpecialChar;
  }

  static String jsonToString(dynamic event) {
    return json.encode(event);
  }

  static dynamic stringToJson(String? event) {
    if (event == null || event == "") return null;
    return json.decode(event);
  }

  static customPrint(dynamic object) {
    if (Globals.config.displayPrint!) {
      log(object.toString());
    }
  }

  static toast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppColors.primary,
        textColor: Colors.white);
  }

  static String formatDate(DateTime? event, {DateFormat? format}) {
    if (event == null) {
      return "";
    }

    return (format ?? AppFormat.date).format(event);
  }

  static String parseAndFormatDate(String? event,
      {DateFormat? format, DateFormat? parse}) {
    if ((event ?? "").isEmpty) {
      return "";
    }

    return (format ?? AppFormat.date)
        .format((parse ?? AppFormat.dateTimeResponse1).parse(event!));
  }

  static String formatDateTime(String isoDateTime) {
    DateTime dateTime = DateTime.parse(isoDateTime);
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  static String formatDateTimeMobinet(String isoDateTime) {
    if (isoDateTime == "") {
      return NULL_VALUE;
    }
    DateFormat inputFormat = DateFormat('MM/dd/yyyy HH:mm:ss');
    DateTime dateTime = inputFormat.parse(isoDateTime);
    DateFormat outputFormat = DateFormat('dd/MM/yyyy');
    String formattedDateTime = outputFormat.format(dateTime);
    return formattedDateTime;
  }

  static String formatStringMoney(int? number) {
    if (number == null) return "0đ";
    final formatter = NumberFormat("#,##0", "vi_VN");
    return "${formatter.format(number)}đ";
  }

  static double getWidthOfItemPerRow(BuildContext context, int itemPerRow,
      {double? padding, double? separate}) {
    return (AppSizes.screenSize(context).width -
            (padding ?? AppSizes.regular) * 2 -
            ((itemPerRow - 1) * (separate ?? AppSizes.semiRegular)) -
            1) /
        itemPerRow;
  }

  static showOptionsBottomSheet(BuildContext context,
      {String? title,
      List<CustomDropdownModel>? menus,
      CustomDropdownModel? value,
      Function(CustomDropdownModel)? onChanged}) {
    List<CustomBottomOptionModel> models = menus!
        .map((e) => CustomBottomOptionModel(
            text: e.text,
            textColor: e.color,
            isSelected: value?.id == e.id,
            onTap: () {
              CustomNavigator.pop(context);
              onChanged!(e);
            }))
        .toList();
    CustomNavigator.showCustomBottomDialog(
        context,
        CustomBottomOption(
          title: title ?? AppLocalizations.text(LangKey.choose),
          options: models,
        ));
  }

  static saveNetworkImage(BuildContext context, String url) async {
    if (url.isEmpty) {
      Utility.toast("Lưu ảnh thất bại");
      return;
    }
    try {
      CustomNavigator.showProgressDialog(context);
      var response = await http.get(Uri.parse(url));
      CustomNavigator.hideProgressDialog();
      if (response.statusCode == 200) {
        await ImageGallerySaverPlus.saveImage(
          Uint8List.fromList(response.bodyBytes),
          quality: 60,
          name: "test",
        );
        Utility.toast("Lưu ảnh thành công");
      } else {
        Utility.toast("Lưu ảnh thất bại");
      }
    } catch (e) {
      Utility.toast("Lưu ảnh thất bại");
    }
  }

  static saveImageUint8List(Uint8List imageBytes) async {
    if (imageBytes.isEmpty) {
      Utility.toast("Lưu ảnh thất bại");
      return;
    }
    final result = await ImageGallerySaverPlus.saveImage(
      imageBytes,
      quality: 60,
      name: "qr_code_pay_${DateTime.now().millisecondsSinceEpoch}",
    );
    if (result['isSuccess']) {
      Utility.toast("Lưu ảnh thành công");
    } else {
      Utility.toast("Lưu ảnh thất bại");
    }
  }

  static Future<void> callPhoneNumber(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  static launch(String? url) {
    if ((url ?? "").isEmpty) {
      return;
    }
    urlLauncher.launchUrl(
      Uri.parse(url!),
      mode: urlLauncher.LaunchMode.externalApplication,
    );
  }

  static copyText(BuildContext context, String text,
      {String? message = "Copied to Clipboard"}) {
    Clipboard.setData(ClipboardData(text: text)).then((_) {
      if (message != null) toast(message);
    });
  }

  static KeyboardActionsConfig getKeyboardActionsConfig(
    BuildContext context,
    List<FocusNode> list,
  ) {
    return KeyboardActionsConfig(
      keyboardBarColor: AppColors.background,
      nextFocus: true,
      actions: List.generate(
        list.length,
        (i) => KeyboardActionsItem(
          focusNode: list[i],
          toolbarButtons: [
            (node) {
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: Padding(
                  padding: EdgeInsets.only(right: AppSizes.regular),
                  child: Text(
                    'Đóng',
                    style: TextStyle(
                        color: AppColors.primary, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
          ],
        ),
      ),
    );
  }

  static Future<String> getDeviceId() async {
    return await DeviceId.get();
  }

  static Future<String> getModelDevice() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      var android = await deviceInfo.androidInfo;
      return android.model;
    } else {
      var ios = await deviceInfo.iosInfo;
      return ios.utsname.machine;
    }
  }

  static String getDevicePlatform() {
    return Platform.isAndroid ? "android" : "ios";
  }

  static Future<bool> checkGPSWithAlert(BuildContext context, {String? content}) async {
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (isLocationServiceEnabled) {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
          await CustomNavigator.showCustomPopupAction(context, AppLocalizations.text(LangKey.notification),
                  textAlign: TextAlign.center,
                  content: content ?? "Vui lòng bật GPS để lấy vị trí hiện tại của bạn.",
                  titleUnSubmit: AppLocalizations.text(LangKey.close),
                  titleSubmit: AppLocalizations.text(LangKey.confirm),
                  onConfirm: () async {
                    await CustomNavigator.pop(context);
                    CustomPermissionRequest.request(context, Permission.location);
                  },
                  onClose: () => CustomNavigator.pop(context));
          return false;
      }
      return true;
    } else {
      return false;
    }
  }

  static Future<String> getCurrentLocation() async {
    try {
      Position position = await determinePosition()
          .timeout(Duration(seconds: 15), onTimeout: () {
        return Position(
            latitude: 0.0,
            longitude: 0.0,
            timestamp: DateTime.now(),
            accuracy: 0,
            altitude: 0,
            heading: 0,
            speed: 0,
            speedAccuracy: 0,
            altitudeAccuracy: 0,
            headingAccuracy: 0,
            floor: null);
      });

      double latitude = position.latitude;
      double longitude = position.longitude;
      if (latitude == 0.0 || longitude == 0.0) {
        return "";
      } else {
        return '$latitude,$longitude';
      }
    } catch (e) {
      print('Lỗi khi lấy vị trí: $e');
      return "";
    }
  }

  static Future<Position> determinePosition({BuildContext? context}) async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Location services are disabled');
        // Try to open location settings
        if (context != null)
          await CustomPermissionRequest.request(context, Permission.location);
        throw Exception(
            'Location services are disabled. Please enable location services.');
      }
      var permission = await Geolocator.checkPermission();
      print('Current location permission status: $permission');
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        print('New permission status after request: $permission');

        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print('Location permissions are permanently denied');
        await Geolocator.requestPermission();
        throw Exception(
            'Location permissions are permanently denied. Please enable in app settings.');
      }
      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        print('Permission granted: $permission - attempting to get location');
        try {
          return await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(
                accuracy: LocationAccuracy.high,
                timeLimit: Duration(seconds: 15)),
          );
        } catch (highAccuracyError) {
          print('Failed with high accuracy: $highAccuracyError');
          return await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(
                accuracy: LocationAccuracy.medium,
                timeLimit: Duration(seconds: 15)),
          );
        }
      }

      // This should not happen but handle it anyway
      throw Exception('Unexpected permission status: $permission');
    } catch (e) {
      print('Error in _determinePosition: $e');
      rethrow;
    }
  }
}

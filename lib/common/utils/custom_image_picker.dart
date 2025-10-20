import 'dart:io';

import 'package:go_mep_application/common/theme/app_colors.dart';
import 'package:go_mep_application/common/theme/app_dimens.dart';
import 'package:go_mep_application/common/theme/app_format.dart';
import 'package:go_mep_application/common/theme/assets.dart';
import 'package:go_mep_application/common/theme/globals/globals.dart';
import 'package:go_mep_application/common/utils/custom_navigator.dart';
import 'package:go_mep_application/common/utils/custom_permission_request.dart';
import 'package:go_mep_application/common/utils/image_text_overplay.dart';
import 'package:go_mep_application/common/utils/utility.dart';
import 'package:go_mep_application/common/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;

class CustomImagePicker {
  static showPicker(BuildContext context, Function(Uint8List) onConfirm,
      {bool isSelfie = false, String? numberCar}) {
    CustomNavigator.showCustomBottomDialog(
        context,
        CustomBottomOption(
          options: [
            CustomBottomOptionModel(
                icon: Assets.icCameraFill,
                iconColor: AppColors.blue,
                text: "Chụp ảnh",
                onTap: () async {
                  CustomNavigator.showProgressDialog(context);
                  Uint8List? file = await pickImage(context, ImageSource.camera,
                      isSelfie: isSelfie);
                  if (file != null) {
                    CustomNavigator.showProgressDialog(context);
                    final location = await Utility.getCurrentLocation();
                    final String numberCarText = numberCar != null
                        ? "Số xe: $numberCar"
                        : "Số xe: --:--";
                    final dateTime = Utility.formatDate(DateTime.now(),
                        format: AppFormat.dateTime);
                    final versionName = "Version: ${Globals.config.versionName}";
                    final watermark = "$dateTime\n$location\n$numberCarText\n$versionName";
                    Uint8List watermarked =
                        await ImageTextOverlay.overlayTextWithCustomFont(
                            imageBytes: file, text: watermark);
                    CustomNavigator.hideProgressDialog();
                    onConfirm(watermarked);
                  }
                }),
            // CustomBottomOptionModel(
            //     icon: Assets.icGalleryFill,
            //     iconColor: AppColors.blue,
            //     text: "Chọn từ thư viện",
            //     onTap: () async {
            //       CustomNavigator.showProgressDialog(context);
            //       Uint8List? file =
            //           await pickImage(context, ImageSource.gallery);
            //       CustomNavigator.hideProgressDialog();
            //       if (file != null) {
            //         CustomNavigator.pop(context);
            //         onConfirm(file);
            //       }
            //     })
          ],
        ));
  }

  static showMultiPicker(
      BuildContext context, Function(List<Uint8List>)? onConfirm,
      {bool isSelfie = false, String? numberCar}) {
    CustomNavigator.showCustomBottomDialog(
        context,
        CustomBottomOption(
          options: [
            CustomBottomOptionModel(
                icon: Assets.icCameraFill,
                iconColor: AppColors.blue,
                text: "Chụp ảnh",
                onTap: () async {
                  Uint8List? file = await pickImage(context, ImageSource.camera,
                      isSelfie: isSelfie);
                  if (file != null) {
                    CustomNavigator.showProgressDialog(context);
                    final location = await Utility.getCurrentLocation();
                    final String numberCarText = numberCar != null
                        ? "Số xe: $numberCar"
                        : "Số xe: --:--";
                    final dateTime = Utility.formatDate(DateTime.now(),
                        format: AppFormat.dateTime);
                    final versionName = "Version: ${Globals.config.versionName}";
                    final watermark = "$dateTime\n$location\n$numberCarText\n$versionName";
                    final watermarked =
                        await ImageTextOverlay.overlayTextWithCustomFont(
                            imageBytes: file, text: watermark);
                    
                    CustomNavigator.hideProgressDialog();
                    onConfirm!([watermarked]);
                  }
                }),
            // CustomBottomOptionModel(
            //     icon: Assets.icGalleryFill,
            //     iconColor: AppColors.blue,
            //     text: "Chọn từ thư viện",
            //     onTap: () async {
            //       CustomNavigator.showProgressDialog(context);
            //       List<File>? files = await pickMultiImage(context);
            //       CustomNavigator.hideProgressDialog();
            //       if (files != null) {
            //         CustomNavigator.pop(context);
            //         onConfirm!(
            //             await Future.wait(files.map((e) => e.readAsBytes())));
            //       }
            //     })
          ],
        ));
  }

  static Future<Uint8List?> pickImage(BuildContext context, ImageSource source,
      {bool isSelfie = false}) async {
    try {
      bool permission = false;
      if (source == ImageSource.camera) {
        permission =
            await CustomPermissionRequest.request(context, Permission.camera);
      } else {
        permission =
            await CustomPermissionRequest.request(context, Permission.storage);
      }
      if (!permission) return null;
    } catch (_) {
      return null;
    }

    final pickedFile = await ImagePicker().pickImage(
        source: source,
        preferredCameraDevice:
            isSelfie ? CameraDevice.front : CameraDevice.rear,
        maxWidth: AppSizes.maxWidth,
        imageQuality: 80);
    if (pickedFile == null) return null;

    return pickedFile.readAsBytes();
  }

  static Future<List<File>?> pickMultiImage(BuildContext? context) async {
    try {
      bool permission = false;
      permission =
          await CustomPermissionRequest.request(context!, Permission.storage);
      if (!permission) return null;
    } catch (_) {
      return null;
    }
    List<XFile> pickedFile = await ImagePicker()
        .pickMultiImage(maxWidth: 800, maxHeight: 800, imageQuality: 50);
    if (pickedFile.isEmpty) return null;
    return pickedFile.map((e) => File(e.path)).toList();
  }
  Future<Position?>? _warmupPosition;

  void warmUpLocation() {
    // Gọi sớm (ví dụ onInit của screen hoặc trước khi _picker.pickImage)
    _warmupPosition ??= () async {
      try {
        if (!await Geolocator.isLocationServiceEnabled()) return null;

        // Ưu tiên last known (rất nhanh)
        final last = await Geolocator.getLastKnownPosition();
        if (last != null) return last;

        // Lắng nghe 1 mẫu nhanh rồi hủy
        final sub = Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.medium,
            distanceFilter: 50,
          ),
        ).listen(null);
        try {
          final first = await sub
              .asFuture<Position?>()
              .timeout(const Duration(seconds: 1), onTimeout: () => null);
          return first;
        } finally {
          await sub.cancel();
        }
      } catch (_) {
        return null;
      }
    }();
  }

  Future<String> _getLocationText(
      {Duration overallTimeout = const Duration(seconds: 4)}) async {
    // Quyền
    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    if (perm == LocationPermission.denied ||
        perm == LocationPermission.deniedForever) {
      return "Location: N/A";
    }

    Future<Position?> lastKnown() => Geolocator.getLastKnownPosition();
    Future<Position?> warmup() async =>
        await (_warmupPosition ?? Future.value(null));
    Future<Position?> current() => Geolocator.getCurrentPosition(
          timeLimit: const Duration(seconds: 3),
          desiredAccuracy: LocationAccuracy.high,
        ).then((p) => p, onError: (_) => null);

    final pos = await Future.any<Position?>([
      lastKnown().then((p) => p),
      warmup(),
      current(),
      Future<Position?>.delayed(overallTimeout, () => null),
    ]);

    if (pos == null) return "Location: N/A (timeout)";

    final latStr = pos.latitude.toStringAsFixed(6);
    final lngStr = pos.longitude.toStringAsFixed(6);

    // Reverse geocoding có timeout riêng để không chặn
    try {
      final placemarks =
          await placemarkFromCoordinates(pos.latitude, pos.longitude)
              .timeout(const Duration(seconds: 1));
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final pieces = [
          if ((p.subLocality ?? '').isNotEmpty) p.subLocality,
          if ((p.locality ?? '').isNotEmpty) p.locality,
          if ((p.administrativeArea ?? '').isNotEmpty) p.administrativeArea,
          if ((p.country ?? '').isNotEmpty) p.country,
        ].whereType<String>().toList();
        final place = pieces.join(", ");
        return place.isNotEmpty
            ? "$latStr,$lngStr ($place)"
            : "$latStr,$lngStr";
      }
    } catch (_) {
      /* nuốt lỗi, fallback lat/lng */
    }
    return "$latStr,$lngStr";
  }

  static Future<WatermarkedPhoto?> captureAndWatermark({
    int cornerPadding = 16,
    int targetMaxBytes = 1024 * 1024,
    int initialJpegQuality = 92,
    String? extraNote,
  }) async {
    CustomImagePicker().warmUpLocation();
    final shot = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: null);
    if (shot == null) return null;

    // Bắt đầu location (không chờ ngay)
    final locFuture = CustomImagePicker()._getLocationText();

    // Đọc bytes và xử lý ảnh song song
    final original = await shot.readAsBytes();
    final now = DateTime.now();
    final ts =
        "${CustomImagePicker()._two(now.day)}/${CustomImagePicker()._two(now.month)}/${now.year} ${CustomImagePicker()._two(now.hour)}:${CustomImagePicker()._two(now.minute)}";

    final locText = await locFuture; // đợi khi cần ghép watermark
    final watermarkText =
        [ts, locText, if ((extraNote ?? '').isNotEmpty) extraNote!].join(' • ');

    // Xử lý nặng trên isolate
    final out = await compute<_ProcessArgs, Uint8List>(
        CustomImagePicker()._processImageOnIsolate,
        _ProcessArgs(
          original: original,
          watermarkText: watermarkText,
          cornerPadding: cornerPadding,
          targetMaxBytes: targetMaxBytes,
          initialQuality: initialJpegQuality,
        ));

    final path = await CustomImagePicker()._persistTemp(out);
    return WatermarkedPhoto(
        bytes: out, path: path, watermarkText: watermarkText);
  }

  Future<String> _persistTemp(Uint8List bytes) async {
    final dir = await getTemporaryDirectory();
    final file =
        File('${dir.path}/wm_${DateTime.now().millisecondsSinceEpoch}.jpg');
    await file.writeAsBytes(bytes, flush: true);
    return file.path;
  }

  Future<Uint8List> _processImageOnIsolate(_ProcessArgs a) async {
    // Decode ảnh thành ui.Image
    final codec = await ui.instantiateImageCodec(a.original);
    final frame = await codec.getNextFrame();
    final originalImage = frame.image;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // Vẽ ảnh gốc
    canvas.drawImage(originalImage, Offset.zero, Paint());

    // Tạo text painter
    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: 20,
      backgroundColor: Colors.black54,
    );
    final textSpan = TextSpan(text: a.watermarkText, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    // Vị trí vẽ: góc dưới phải
    final dx =
        originalImage.width - textPainter.width - a.cornerPadding.toDouble();
    final dy =
        originalImage.height - textPainter.height - a.cornerPadding.toDouble();
    textPainter.paint(canvas, Offset(dx, dy));

    // Chuyển về bytes
    final picture = recorder.endRecording();
    final img =
        await picture.toImage(originalImage.width, originalImage.height);
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  String _two(int v) => v < 10 ? '0$v' : '$v';
}

class _ProcessArgs {
  final Uint8List original;
  final String watermarkText;
  final int cornerPadding;
  final int targetMaxBytes;
  final int initialQuality;
  _ProcessArgs({
    required this.original,
    required this.watermarkText,
    required this.cornerPadding,
    required this.targetMaxBytes,
    required this.initialQuality,
  });
}

class WatermarkedPhoto {
  final Uint8List bytes;
  final String path;
  final String watermarkText;

  WatermarkedPhoto({
    required this.bytes,
    required this.path,
    required this.watermarkText,
  });
}

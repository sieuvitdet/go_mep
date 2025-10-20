import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_mep_application/common/utils/utility.dart';
import 'package:go_mep_application/common/theme/app_colors.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/foundation.dart';

class ImageTextOverlay {
  static Future<Uint8List> overlayTextWithCustomFont({
    required Uint8List imageBytes,
    required String text,
    double? fontSize,
    double x = 10,
    int quality = 85,
  }) async {
    final ui.Codec codec = await ui.instantiateImageCodec(imageBytes);
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    final ui.Image originalImage = frameInfo.image;

    double dynamicFontSize = 16.0;
    // if (originalImage.height / originalImage.width > 1.5) {
    //   dynamicFontSize = (originalImage.height / 32).clamp(16.0, 32.0);
    // } else {
    //   dynamicFontSize = (originalImage.height / 20).clamp(24.0, 40.0);
    // }
    final List<String> lines = text.split('\n');
    while (lines.length < 4) {
      lines.add("");
    }

    final double lineSpacing = dynamicFontSize * 0.4;
    final double dynamicSizeLTWH = (dynamicFontSize * 4 + lineSpacing * 3 + 40);

    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    final Size size =
        Size(originalImage.width.toDouble(), originalImage.height.toDouble());

    final Paint paint = Paint();
    canvas.drawImage(originalImage, Offset.zero, paint);

    final Paint bgPaint = Paint()
      ..color = AppColors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    canvas.drawRect(
        Rect.fromLTWH(
            0, size.height - dynamicSizeLTWH, size.width, dynamicSizeLTWH),
        bgPaint);

    double y = size.height - dynamicSizeLTWH + 20; // padding top
    for (int i = 0; i < lines.length; i++) {
      final tp = createTextPainter(lines[i], dynamicFontSize);
      tp.paint(canvas, Offset(x, y));
      y += dynamicFontSize + lineSpacing;
    }

    final ui.Picture picture = recorder.endRecording();
    final ui.Image image =
        await picture.toImage(originalImage.width, originalImage.height);

    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    if (byteData == null) {
      throw Exception('Không thể chuyển đổi ảnh');
    }

    final Uint8List rawBytes = byteData.buffer.asUint8List();
    final img.Image? processedImage = img.Image.fromBytes(
      width: originalImage.width,
      height: originalImage.height,
      bytes: rawBytes.buffer,
      format: img.Format.uint8,
      numChannels: 4,
    );

    if (processedImage == null) {
      throw Exception('Không thể xử lý ảnh');
    }

    final Uint8List processedBytes =
        Uint8List.fromList(img.encodeJpg(processedImage, quality: quality));

    const int maxSize = 1024 * 1024; // 1MB
    if (processedBytes.length > maxSize) {
      int reducedQuality = (quality * 0.7).round().clamp(30, 85);
      final Uint8List compressedBytes = Uint8List.fromList(
          img.encodeJpg(processedImage, quality: reducedQuality));

      if (kDebugMode) {
        Utility.customPrint(
            'Watermark added - Original: ${(processedBytes.length / 1024).toStringAsFixed(0)}KB, Compressed: ${(compressedBytes.length / 1024).toStringAsFixed(0)}KB');
      }

      return compressedBytes;
    }

    return processedBytes;
  }

  static TextPainter createTextPainter(String text, double fontSize) {
    final textStyle = ui.TextStyle(
      color: AppColors.white,
      fontSize: fontSize,
      fontFamily: 'Inter',
      fontWeight: FontWeight.w500,
    );

    final paragraphStyle = ui.ParagraphStyle(
      textDirection: TextDirection.ltr,
    );

    final paragraphBuilder = ui.ParagraphBuilder(paragraphStyle)
      ..pushStyle(textStyle)
      ..addText(text);

    final paragraph = paragraphBuilder.build();
    paragraph.layout(ui.ParagraphConstraints(width: double.infinity));

    return TextPainter(
      text: TextSpan(
          text: text,
          style: TextStyle(
            color: AppColors.white,
            fontSize: fontSize,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          )),
      textDirection: TextDirection.ltr,
    )..layout();
  }
}

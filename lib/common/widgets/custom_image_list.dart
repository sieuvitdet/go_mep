part of widget;

class CustomImageList extends StatelessWidget {
  final List<CustomImageListModel>? models;
  final bool enableAdd;
  final Function(List<Uint8List>)? onAdd;
  final Function(int)? onRemove;
  final Function(Uint8List)? onSingleAdd;
  final String? hintText;
  final int? limit;
  final bool? isRequired;
  final String? errorMessage;
  final double? maxWidth;
  final String? numberCar;

  CustomImageList(
      {this.models,
      this.enableAdd = true,
      this.onAdd,
      this.onRemove,
      Key? key,
      this.onSingleAdd,
      this.hintText,
      this.limit,
      this.errorMessage,
      this.isRequired,
      this.maxWidth,
      this.numberCar})
      : super(key: key);

  Widget _buildAdd(BuildContext context) {
    double width = maxWidth ?? Utility.getWidthOfItemPerRow(context, 4);
    if (width > 80) {
      width = 80;
    }
    return InkWell(
      child: Container(
        width: width,
        child: Column(
          children: [
            if (hintText != null) ...[
              CustomText(
                text: hintText,
                color: AppColors.hint,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: AppSizes.semiRegular,
              )
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                    onTap: (enableAdd)
                        ? () {
                            if (onAdd != null) {
                              CustomImagePicker.showMultiPicker(context,
                                  numberCar: numberCar, (files) {
                                if (limit != null) {
                                  if (((models?.length ?? 0) + files.length) >
                                      limit!) {
                                    CustomNavigator.showCustomAlertDialog(
                                        context,
                                        AppLocalizations.text(
                                            "Lỗi khi chọn ảnh"),
                                        type: CustomAlertDialogType.warning);
                                  } else {
                                    onAdd!(files);
                                  }
                                } else {
                                  onAdd!(files);
                                }
                              });
                            } else {
                              CustomImagePicker.showPicker(context,
                                  numberCar: numberCar, (bytes) {
                                if (onAdd != null) {
                                  onAdd!([bytes]);
                                }
                              });
                            }
                          }
                        : null,
                    child: _buildAddImage(context)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAddImage(BuildContext context) {
    return CustomPaint(
      painter: DashedBorderPainter(
        color: AppColors.greyLight,
        strokeWidth: 1.0,
        gap: 3.0,
      ),
      child: Container(
        width: 80,
        height: 75,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.transparent,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(AppSizes.small / 2),
              decoration: BoxDecoration(
                color: AppColors.greyLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.image_outlined,
                color: AppColors.hint,
                size: 16,
              ),
            ),
            Gaps.vGap8,
            CustomText(
              text: "Thêm ảnh",
              fontSize: AppTextSizes.body,
              color: AppColors.hint,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeleton() {
    return CustomSkeleton();
  }

  @override
  Widget build(BuildContext context) {
    double removeSize = 18.0;
    double width = maxWidth ?? Utility.getWidthOfItemPerRow(context, 4);
    if (width > 90) {
      width = 90;
    }

    if (onRemove != null) {
      width = width - removeSize / 2;
    }

    if (models == null) {
      return _buildSkeleton();
    }

    List<Widget> children = List.generate(models?.length ?? 0, (index) {
      String? url = models![index].url;
      Uint8List? file = models![index].file;

      return InkWell(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              padding: onRemove == null
                  ? null
                  : EdgeInsets.only(top: removeSize / 2, right: removeSize / 2),
              child: file == null
                  ? CachedNetworkImage(
                          imageUrl: url ?? '',
                          width: width,
                          height: width,
                          placeholder: (context, url) => CustomPlaceholder(),
                          errorWidget: (context, url, error) =>
                              CustomPlaceholder(),
                          fit: BoxFit.cover,
                        )
                  : Image.memory(
                      file,
                      width: width,
                      height: width,
                      fit: BoxFit.cover,
                    ),
            ),
            if (onRemove != null)
              Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  child: CustomImageIcon(
                    icon: Assets.icCloseFill,
                    size: removeSize,
                    color: AppColors.red,
                  ),
                  onTap: () => onRemove!(index),
                ),
              ),
          ],
        ),
        onTap: () => CustomNavigator.push(
            context,
            PhotoViewScreen(
              models: models!,
              initialIndex: index,
            )),
      );
    }).toList();

    if (onAdd != null || onSingleAdd != null) {
      if (limit == null) {
        children.add(_buildAdd(context));
      } else if ((models?.length ?? 0) < limit!) {
        children.add(_buildAdd(context));
      }
    }

    return SizedBox(
      width: double.infinity,
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.end,
        alignment: WrapAlignment.start,
        spacing: AppSizes.semiRegular,
        runSpacing: AppSizes.semiRegular,
        children: children,
      ),
    );
  }
}

class CustomImageListModel {
  String? url;
  Uint8List? file;
  String? note;
  DateTime? createdAt;
  String? id;

  CustomImageListModel({this.url, this.file, this.note, this.createdAt, this.id});
}

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;
  final double dashWidth;
  final double borderRadius;

  DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.gap,
    this.dashWidth = 5.0,
    this.borderRadius = 8.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(borderRadius),
    );
    final borderPath = Path()..addRRect(rrect);
    Path dashedPath = _createDashedPath(borderPath);
    canvas.drawPath(dashedPath, paint);
  }

  Path _createDashedPath(Path originalPath) {
    final Path dashedPath = Path();
    final PathMetrics pathMetrics = originalPath.computeMetrics();
    for (final metric in pathMetrics) {
      double distance = 0.0;

      while (distance < metric.length) {
        final double nextSegment = distance + dashWidth;
        dashedPath.addPath(
          metric.extractPath(distance, nextSegment),
          Offset.zero,
        );
        distance = nextSegment + gap;
      }
    }
    return dashedPath;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

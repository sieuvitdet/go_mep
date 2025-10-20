part of widget;

class CustomLine extends StatelessWidget {
  final bool isVertical;
  final double? size;
  final Color? color;

  CustomLine({this.isVertical = true, this.size, this.color});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return isVertical
        ? Container(
            color: color ?? AppColors.border,
            height: size ?? AppSizes.line,
          )
        : Container(
            color: color ?? AppColors.border,
            width: size ?? AppSizes.line,
          );
  }
}

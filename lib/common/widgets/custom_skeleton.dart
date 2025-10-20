part of widget;

class CustomSkeleton extends StatelessWidget {
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final double? radius;
  final BorderRadiusGeometry? borderRadius;

  CustomSkeleton({
    this.width,
    this.height,
    this.margin,
    this.radius,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height ?? 15.0,
      margin: margin,
      decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: borderRadius ??
              BorderRadius.all(Radius.circular(radius ?? 1000.0))),
    );
  }
}

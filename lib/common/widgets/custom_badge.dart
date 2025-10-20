part of widget;

class CustomBadge extends StatelessWidget {
  final int? badge;
  final Widget? child;
  final bgd.BadgePosition? position;
  final bool toAnimate;
  final Color? badgeColor;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;

  CustomBadge({
    this.badge,
    this.child,
    this.position,
    this.toAnimate = true,
    this.badgeColor,
    this.textColor,
    this.fontSize,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    String event;
    if ((badge ?? 0) > 9)
      event = "9+";
    else
      event = (badge ?? 0).toString();
    return bgd.Badge(
      badgeContent: CustomText(
        text: event,
        fontSize: fontSize ?? AppTextSizes.subBody,
        color: textColor ?? AppColors.white,
        fontWeight: fontWeight ?? FontWeight.w400,
      ),
      child: child,
      badgeStyle: bgd.BadgeStyle(
        badgeColor: badgeColor ?? AppColors.red,
        borderRadius: BorderRadius.circular(10.0),
      ),
      badgeAnimation: bgd.BadgeAnimation.slide(
        toAnimate: toAnimate,
      ),
      showBadge: (badge ?? 0) != 0,
      position: position ?? bgd.BadgePosition.topEnd(top: -10, end: -10),
    );
  }
}

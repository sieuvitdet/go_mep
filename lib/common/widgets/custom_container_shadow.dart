part of widget;

class CustomContainerShadow extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Color? color;
  const CustomContainerShadow(
      {super.key, required this.child, this.padding, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.semiRegular),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 2.0,
            color: AppColors.black.withValues(alpha: 0.25),
          ),
        ],
      ),
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: child,
      ),
    );
  }
}

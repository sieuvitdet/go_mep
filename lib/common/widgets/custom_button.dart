part of widget;

class CustomButton extends StatelessWidget {
  final String? text;
  final bool enable;
  final bool expand;
  final Color? color;
  final Color? textColor;
  final Color? borderColor;
  final double? radius;
  final GestureTapCallback? onTap;
  final bool isMain;
  final TextStyle? style;
  final bool isButtonSecond;
  final String? icon;

  CustomButton(
      {this.text,
      this.enable = true,
      this.expand = true,
      this.color,
      this.radius,
      this.onTap,
      this.textColor,
      this.borderColor,
      this.style,
      this.isButtonSecond = false,
      this.isMain = true,
      this.icon});

  Widget _buildText() {
    return CustomText(
      text: text ?? "",
      color: isButtonSecond ? AppColors.black : textColor ?? AppColors.white,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );
  }

  Widget _buildBody() {
    // Xác định background decoration
    final BoxDecoration? decoration = !enable
        ? BoxDecoration(
            color: AppColors.greyLight,
            borderRadius: BorderRadius.circular(radius ?? 8),
          )
        : isButtonSecond
            ? BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppColors.gradientStart, width: 1),
                borderRadius: BorderRadius.circular(radius ?? 8),
              )
            : (color != null
                ? BoxDecoration(
                    color: color,
                    border: borderColor != null
                        ? Border.all(color: borderColor!, width: 1)
                        : null,
                    borderRadius: BorderRadius.circular(radius ?? 8),
                  )
                : BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.gradientStart, AppColors.gradientEnd],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    border: borderColor != null
                        ? Border.all(color: borderColor!, width: 1)
                        : null,
                    borderRadius: BorderRadius.circular(radius ?? 8),
                  ));

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enable
            ? () {
                if (onTap != null) {
                  onTap!();
                }
              }
            : null,
        borderRadius: BorderRadius.circular(radius ?? 8),
        child: Ink(
          decoration: decoration,
          child: Container(
            padding: EdgeInsets.all(AppSizes.semiRegular),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  CustomImageIcon(
                    icon: icon!,
                    size: 20,
                    color: style?.color ??
                        (isButtonSecond
                            ? AppColors.gradientStart
                            : textColor ?? AppColors.white),
                  ),
                  Gaps.hGap2
                ],
                if (expand) Flexible(child: _buildText()) else _buildText()
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return expand
        ? SizedBox(
            width: double.infinity,
            child: _buildBody(),
          )
        : _buildBody();
  }
}

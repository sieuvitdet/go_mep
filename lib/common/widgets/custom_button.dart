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
    return ElevatedButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            CustomImageIcon(
              icon: icon!,
              size: 20,
              color: style?.color ??
                  (isButtonSecond
                      ? AppColors.primary
                      : textColor ?? AppColors.white),
            ),
            Gaps.hGap2
          ],
          if (expand) Flexible(child: _buildText()) else _buildText()
        ],
      ),
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(!enable
            ? AppColors.greyLight
            : isButtonSecond
                ? Colors.white
                : color ?? AppColors.primary),
        side: isButtonSecond
            ? WidgetStateProperty.all(
                BorderSide(color: AppColors.primary, width: 1),
              )
            : (borderColor != null
                ? WidgetStateProperty.all(
                    BorderSide(color: borderColor!, width: 1),
                  )
                : null),
        padding: WidgetStateProperty.all(EdgeInsets.all(AppSizes.semiRegular)),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? 8),
          ),
        ),
      ),
      onPressed: enable
          ? () {
              // Wrap onTap with trackEvent
              if (onTap != null) {
                onTap!(); // Gọi hàm onTap gốc
              }
            }
          : null,
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

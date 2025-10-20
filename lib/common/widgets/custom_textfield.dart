part of widget;

class CustomTextField extends StatelessWidget {
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final String? hintText;
  final String? suffixIcon;
  final Widget? suffixIconWidget;
  final String? prefixText;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String)? onSubmitted;
  final bool? enable;
  final CustomImageIcon? customSuffixIcon;
  final Color? suffixIconColor;
  final double? suffixIconSize;
  final String? errorMessage;
  final Function(String)? onChanged;
  final int? maxLength;
  final int? maxLines;
  final Color? backgroundColor;
  final Color? borDerColor;
  final String? text;
  final bool isText;
  final GestureTapCallback? onTap;
  final bool? obscureText;
  final GestureTapCallback? onSuffixIconTap;
  final EdgeInsets? contentPadding;
  final double? fontSizeHint;
  final Color? textInputColor;
  final bool isRequired;
  final Widget? label;
  final BoxConstraints? prefixIconConstraints;
  final Widget? prefixIconWidget;
  final String? counterText;

  const CustomTextField(
      {super.key,
      this.focusNode,
      this.controller,
      this.hintText,
      this.suffixIcon,
      this.suffixIconWidget,
      this.textInputAction,
      this.textInputType,
      this.inputFormatters,
      this.onSubmitted,
      this.prefixText,
      this.enable = true,
      this.customSuffixIcon,
      this.suffixIconColor,
      this.errorMessage,
      this.onChanged,
      this.maxLength,
      this.maxLines,
      this.backgroundColor,
      this.borDerColor,
      this.text,
      this.isText = false,
      this.onTap,
      this.obscureText = false,
      this.onSuffixIconTap,
      this.suffixIconSize = 16.0,
      this.contentPadding,
      this.fontSizeHint,
      this.textInputColor,
      this.isRequired = false,
      this.label,
      this.prefixIconConstraints,
      this.prefixIconWidget,
      this.counterText});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isText)
          InkWell(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: borDerColor ?? AppColors.grey),
                color: backgroundColor ?? AppColors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                  vertical: AppSizes.semiRegular, horizontal: AppSizes.small),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomText(
                    text: (text ?? "").isEmpty ? hintText : text,
                    color:
                        (text ?? "").isEmpty ? AppColors.hint : AppColors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ),
            onTap: onTap,
          )
        else
          TextField(
            focusNode: focusNode,
            controller: controller,
            onChanged: onChanged,
            maxLength: maxLength,
            decoration: InputDecoration(
                label: label ??
                    RichText(
                      text: TextSpan(
                        text: hintText ?? "",
                        style: TextStyle(
                          color: AppColors.hint,
                          fontSize: fontSizeHint ?? AppTextSizes.body,
                        ),
                        children: [
                          TextSpan(
                            text: isRequired ? ' *' : '',
                            style: TextStyle(
                              color: AppColors.error,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                hint: (label == null)
                    ? null
                    : RichText(
                        text: TextSpan(
                          text: hintText ?? "",
                          style: TextStyle(
                            color: AppColors.hint,
                            fontSize: fontSizeHint ?? AppTextSizes.body,
                          ),
                          children: [
                            TextSpan(
                              text: isRequired ? ' *' : '',
                              style: TextStyle(
                                color: AppColors.error,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: borDerColor ?? AppColors.greyLight, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: (errorMessage != null && errorMessage!.isNotEmpty) ? AppColors.red : AppColors.primary, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                isDense: true,
                contentPadding: contentPadding ??
                    EdgeInsets.symmetric(
                        vertical: AppSizes.regular, horizontal: AppSizes.small),
                // hintText: hintText ?? AppLocalizations.text(LangKey.search),
                hintStyle: TextStyle(
                    color: AppColors.hint,
                    fontSize: fontSizeHint ?? AppTextSizes.body),
                suffixIcon: suffixIconWidget == null
                    ? suffixIcon == null
                        ? null
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (suffixIcon != null)
                                GestureDetector(
                                  onTap: onSuffixIconTap,
                                  child: CustomImageIcon(
                                    icon: suffixIcon,
                                    size: suffixIconSize,
                                    color: suffixIconColor,
                                  ),
                                ),
                              Gaps.hGap8
                            ],
                          )
                    : suffixIconWidget,
                suffixIconConstraints: BoxConstraints(
                  maxWidth: AppSizes.icon * 2,
                  maxHeight: AppSizes.icon,
                ),
                prefixIcon: prefixIconWidget == null
                    ? prefixText == null
                        ? null
                        : CustomText(
                            text: "$prefixText: ",
                            fontSize: AppTextSizes.subTitle,
                            fontWeight: FontWeight.bold,
                          )
                    : prefixIconWidget,
                prefixIconConstraints:
                    prefixIconConstraints ?? BoxConstraints(),
                counterText: counterText ?? "",
                fillColor: backgroundColor ?? AppColors.white,
                filled: true),
            style: TextStyle(
                fontSize: AppTextSizes.body,
                color: textInputColor ?? AppColors.black,
                fontWeight: FontWeight.w500),
            textInputAction: textInputAction,
            keyboardType: textInputType,
            inputFormatters: inputFormatters,
            onSubmitted: onSubmitted,
            enabled: enable,
            maxLines: maxLines,
            obscureText: obscureText!,
          ),
        if (errorMessage != null && errorMessage!.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: 4),
            child: CustomText(
              text: errorMessage,
              color: AppColors.error,
            ),
          )
      ],
    );
  }
}

part of widget;

class CustomColumnInformation extends StatelessWidget {
  final String? title;
  final Widget? titleWidget;
  final Widget? suffixTitle;
  final String? content;
  final Color? contentColor;
  final bool contentBold;
  final GestureTapCallback? onContentTap;
  final bool? isUnderline;
  final Widget? childContent;

  CustomColumnInformation(
      {super.key,
      this.title,
      this.titleWidget,
      this.suffixTitle,
      this.content,
      this.contentColor,
      this.contentBold = false,
      this.onContentTap,
      this.isUnderline = false,
      this.childContent});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
                child: titleWidget ??
                    CustomText(
                      text: title,
                    )),
            if (suffixTitle != null) ...[
              SizedBox(
                width: AppSizes.semiRegular,
              ),
              suffixTitle!
            ]
          ],
        ),
        GestureDetector(
          child: childContent ??
              CustomText(
                text: content,
                color: contentColor ?? AppColors.grey,
                fontWeight: contentBold ? FontWeight.bold : null,
              ),
          onTap: onContentTap,
        ),
      ],
    );
  }
}

class CustomColumnWidget extends StatelessWidget {
  final String title;
  final Color? titleColor;
  final String? subTitle;
  final TextStyle? subTitleStyle;
  final bool? isRequired;
  final Widget? suffixTitle;
  final Widget child;
  final bool isCustomLine;
  final String? errorMessage;

  const CustomColumnWidget(
      {super.key,
      required this.title,
      required this.child,
      this.isRequired,
      this.suffixTitle,
      this.titleColor,
      this.subTitle,
      this.isCustomLine = false,
      this.errorMessage,
      this.subTitleStyle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text.rich(TextSpan(
                  text: title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppTextSizes.body,
                      color: titleColor ?? AppColors.primary),
                  children: [
                    if (subTitle != null)
                      TextSpan(
                          text: " ($subTitle)",
                          style: subTitleStyle ??
                              TextStyle(color: AppColors.hint)),
                    if (isRequired != null && isRequired!)
                      TextSpan(
                          text: "*", style: TextStyle(color: AppColors.red)),
                    if (errorMessage != null && errorMessage != "")
                      TextSpan(
                          text: "  $errorMessage",
                          style: TextStyle(
                              color: AppColors.error,
                              fontWeight: FontWeight.normal))
                  ])),
            ),
            if (suffixTitle != null) ...[
              SizedBox(
                width: AppSizes.semiRegular,
              ),
              suffixTitle!
            ]
          ],
        ),
        child,
        isCustomLine
            ? CustomLine(
                size: 1.0,
              )
            : Container()
      ],
    );
  }
}

class CustomTwoColumn extends StatelessWidget {
  final List<Widget> children1;
  final List<Widget> children2;

  const CustomTwoColumn(
      {super.key, required this.children1, required this.children2});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: CustomListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(right: AppSizes.regular),
          children: children1,
        )),
        Expanded(
            child: Container(
          decoration: BoxDecoration(
              border: Border(left: BorderSide(color: AppColors.border))),
          child: CustomListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(left: AppSizes.regular),
            children: children2,
          ),
        )),
      ],
    );
  }
}

part of widget;

class CustomEmpty extends StatelessWidget {
  final String? title;
  final String? content;
  final EdgeInsetsGeometry? padding;
  final bool isScrollable;
  final String? icon;

  CustomEmpty(
      {this.title,
      this.padding,
      this.isScrollable = true,
      this.content,
      this.icon});

  @override
  Widget build(BuildContext context) {
    return CustomListView(
      shrinkWrap: !isScrollable,
      physics: isScrollable
          ? AlwaysScrollableScrollPhysics()
          : NeverScrollableScrollPhysics(),
      padding: padding ?? EdgeInsets.all(AppSizes.regular),
      children: [
        Center(
          child: CustomImage(
            image: icon ?? Assets.appImage,
            width: 50,
          ),
        ),
        title != '' && title != null
            ? CustomText(
                text: title,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.bold,
                fontSize: AppTextSizes.title,
                color: AppColors.black,
              )
            : Container(),
        CustomText(
          text: content ?? AppLocalizations.text(LangKey.data_empty),
          color: AppColors.hint,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

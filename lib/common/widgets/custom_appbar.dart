part of widget;

class CustomAppBar extends StatelessWidget {
  final String? title;
  final Widget? customTitle;
  final List<CustomOptionAppBar>? options;
  final IconData? icon;
  final GestureTapCallback? onWillPop;
  final bool isBottomSheet;
  final Widget? child;

  const CustomAppBar(
      {super.key,
      this.title,
      this.customTitle,
      this.options,
      this.icon,
      this.onWillPop,
      this.isBottomSheet = false,
      this.child});

  Widget _buildIcon(int index, Color color) {
    CustomOptionAppBar model = options![index];
    return CustomIconButton(
        onTap: model.onTap,
        icon: model.icon,
        isText: model.text != null,
        color: color,
        child: model.text == null
            ? null
            : CustomText(
                text: options![index].text,
                color: AppColors.primary,
              ));
  }

  @override
  Widget build(BuildContext context) {
    double top = MediaQuery.of(context).padding.top + 32;
    bool canPop = CustomNavigator.canPop(context);
    Color color = AppColors.black;
    Color optionColor = isBottomSheet ? AppColors.primary : AppColors.white;
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.only(top: isBottomSheet ? 0.0 : top),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: kToolbarHeight,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.small +
                          ((options == null || options!.isEmpty)
                              ? (canPop ? AppSizes.onTap : 0.0)
                              : (options!.length * AppSizes.onTap))),
                  child: customTitle ??
                      Center(
                        child: CustomText(
                          text: title,
                          fontSize: AppTextSizes.title,
                          color: color,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                ),
                Row(
                  children: [
                    Opacity(
                      //opacity: canPop ? 1.0 : 0.0,
                      opacity: customTitle != null ? 0 : 1.0,
                      child: GestureDetector(
                        onTap:
                            // canPop
                            //     ? (
                            onWillPop ?? () => CustomNavigator.pop(context),
                        //: null,
                        child: Container(
                          width: AppSizes.onTap,
                          height: AppSizes.onTap,
                          padding:
                              const EdgeInsets.only(left: AppSizes.regular),
                          child: Icon(
                            icon ?? Icons.arrow_back_ios_sharp,
                            color: color,
                            size: 20.0,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    (options == null || options!.isEmpty)
                        ? Container()
                        : SizedBox(
                            height: AppSizes.onTap,
                            child: ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: AppSizes.small),
                                itemCount: options!.length,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (_, index) =>
                                    options![index].child ??
                                    _buildIcon(index, optionColor)),
                          )
                  ],
                )
              ],
            ),
          ),
          if (child != null) child!
        ],
      ),
    );
  }
}

class CustomOptionAppBar {
  final String? icon;
  final GestureTapCallback? onTap;
  final bool showIcon;
  final Widget? child;
  final String? text;

  CustomOptionAppBar(
      {this.icon, this.showIcon = true, this.onTap, this.child, this.text});
}

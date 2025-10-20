part of widget;

class CustomBottomOption extends StatefulWidget {
  final String? title;
  final List<CustomBottomOptionModel>? options;
  final CustomRefreshCallback? onRefresh;
  final bool shrinkWrap;
  final Function(CustomBottomOptionModel)? onSingleChoice;
  final GestureTapCallback? onMultiChoice;

  CustomBottomOption(
      {this.options,
      this.onRefresh,
      this.shrinkWrap = true,
      this.onSingleChoice,
      this.title,
      this.onMultiChoice});

  @override
  CustomBottomOptionState createState() => CustomBottomOptionState();
}

class CustomBottomOptionState extends State<CustomBottomOption> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  _onSelected(CustomBottomOptionModel model) {
    if (widget.onMultiChoice != null) {
      model.isSelected = !(model.isSelected ?? false);
      setState(() {});
    } else {
      CustomNavigator.pop(context);
      widget.onSingleChoice?.call(model);
    }
  }

  Widget _buildContainer(List<Widget> children) {
    return Container(
      margin: EdgeInsets.all(AppSizes.regular),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: AppColors.white,
      ),
      child: CustomListView(
          padding: EdgeInsets.zero,
          shrinkWrap: widget.shrinkWrap,
          separator: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.regular),
            child: CustomLine(),
          ),
          children: children),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: Colors.transparent,
      isBottomSheet: true,
      safeAreaButton: false,
      body: InkWell(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: AppSizes.screenSize(context).height * 0.3,
            ),
            Flexible(
              fit: FlexFit.loose,
              child: InkWell(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16.0)),
                    color: AppColors.border,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.title != null)
                        Padding(
                          padding: EdgeInsets.only(
                              top: AppSizes.regular,
                              right: AppSizes.regular,
                              left: AppSizes.regular),
                          child: CustomText(
                            text: widget.title,
                            color: AppColors.grey,
                            fontWeight: FontWeight.w500,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: ContainerDataBuilder(
                          data: widget.options,
                          emptyBuilder: CustomEmpty(
                            isScrollable: false,
                          ),
                          bodyBuilder: () => _buildContainer(widget.options!
                              .map((e) => InkWell(
                                    child: Padding(
                                      padding: EdgeInsets.all(AppSizes.regular),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (e.icon != null || e.image != null)
                                            Container(
                                              padding: EdgeInsets.only(
                                                  right: AppSizes.small),
                                              child: e.icon != null
                                                  ? CustomImageIcon(
                                                      icon: e.icon,
                                                      size: AppSizes.icon,
                                                      color: e.iconColor ??
                                                          AppColors.hint,
                                                    )
                                                  : CustomImage(
                                                      image: e.image!,
                                                      width: AppSizes.icon,
                                                    ),
                                            ),
                                          Expanded(
                                            child: CustomText(
                                              text: e.text,
                                              color: AppColors.black,
                                              fontSize: AppTextSizes.subTitle,
                                              textAlign: e.isSelected != null
                                                  ? TextAlign.left
                                                  : TextAlign.center,
                                            ),
                                          ),
                                          if ((e.isSelected ?? false))
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: AppSizes.regular),
                                              child: Icon(
                                                Icons.check,
                                                size: 24.0,
                                                color: AppColors.blue,
                                              ),
                                            )
                                        ],
                                      ),
                                    ),
                                    onTap: e.onTap ?? () => _onSelected(e),
                                  ))
                              .toList()),
                          onRefresh: widget.onRefresh,
                        ),
                      ),
                      if (widget.onMultiChoice != null &&
                          (widget.options?.length ?? 0) > 0)
                        Container(
                          padding: EdgeInsets.all(AppSizes.regular),
                          decoration: BoxDecoration(
                              border: Border(
                                  top: BorderSide(color: AppColors.border))),
                          child: Row(
                            children: [
                              Expanded(
                                child: CustomButton(
                                  color: Colors.blue[50],
                                  textColor: AppColors.primary,
                                  text: AppLocalizations.text(LangKey.cancel),
                                  onTap: () => CustomNavigator.pop(context),
                                ),
                              ),
                              Gaps.hGap12,
                              Expanded(
                                child: CustomButton(
                                  text: AppLocalizations.text(LangKey.choose),
                                  onTap: widget.onMultiChoice,
                                ),
                              )
                            ],
                          ),
                        )
                    ],
                  ),
                ),
                onTap: Utility.hideKeyboard,
              ),
            ),
          ],
        ),
        onTap: () => CustomNavigator.pop(context),
      ),
    );
  }
}

class CustomBottomOptionCupertino extends StatelessWidget {
  final String? title;
  final List<CustomBottomOptionModel>? options;

  const CustomBottomOptionCupertino({super.key, this.title, this.options});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: Colors.transparent,
      isBottomSheet: true,
      safeAreaButton: true,
      body: InkWell(
        child: Padding(
          padding: EdgeInsets.only(
            top: AppSizes.screenSize(context).height * 0.3,
            right: AppSizes.small,
            bottom: AppSizes.small,
            left: AppSizes.small,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14.0),
                      color: AppColors.white,
                    ),
                    child: CustomListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      separator: CustomLine(),
                      children: [
                        if (title != null)
                          Padding(
                            padding: EdgeInsets.all(AppSizes.regular),
                            child: CustomText(
                              text: title,
                              fontSize: AppTextSizes.subBody,
                              color: AppColors.grey,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ...options
                                ?.map((e) => InkWell(
                                      child: Padding(
                                        padding:
                                            EdgeInsets.all(AppSizes.regular),
                                        child: CustomText(
                                          text: e.text,
                                          fontSize: AppTextSizes.subTitle,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      onTap: e.onTap,
                                    ))
                                .toList() ??
                            []
                      ],
                    ),
                  ),
                  onTap: Utility.hideKeyboard,
                ),
              ),
              Gaps.vGap8,
              InkWell(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14.0),
                    color: AppColors.white,
                  ),
                  padding: EdgeInsets.all(AppSizes.regular),
                  child: CustomText(
                    text: AppLocalizations.text(LangKey.back),
                    fontSize: AppTextSizes.subTitle,
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.center,
                  ),
                ),
                onTap: () => CustomNavigator.pop(context),
              )
            ],
          ),
        ),
        onTap: () => CustomNavigator.pop(context),
      ),
    );
  }
}

class CustomBottomOptionSearch extends StatefulWidget {
  final String title;
  final List<CustomBottomOptionModel>? options;
  final Function(CustomBottomOptionModel)? onTap;

  const CustomBottomOptionSearch(
      {super.key, required this.title, this.options, this.onTap});

  @override
  CustomBottomOptionSearchState createState() =>
      CustomBottomOptionSearchState();
}

class CustomBottomOptionSearchState extends State<CustomBottomOptionSearch> {
  final FocusNode focusSearch = FocusNode();
  final TextEditingController controllerSearch = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  _onSearch() {
    setState(() {});
  }

  _onSelected(CustomBottomOptionModel model) {
    CustomNavigator.pop(context);
    widget.onTap?.call(model);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: Colors.transparent,
      isBottomSheet: true,
      safeAreaButton: true,
      body: InkWell(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: AppSizes.screenSize(context).height * 0.3,
            ),
            Expanded(
              child: InkWell(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16.0)),
                    color: AppColors.white,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(AppSizes.regular),
                        child: CustomText(
                          text: widget.title,
                          color: AppColors.primary,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: AppSizes.regular),
                        child: CustomSearch(
                          focusNode: focusSearch,
                          controller: controllerSearch,
                          autoFocus: false,
                          onChanged: (_) => _onSearch(),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.hint),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        ),
                      ),
                      Gaps.vGap8,
                      Expanded(
                        child: CustomListView(
                          padding: EdgeInsets.zero,
                          separator: CustomLine(),
                          children: widget.options
                                  ?.where((e) => (e.text ?? "")
                                      .toLowerCase()
                                      .contains(
                                          controllerSearch.text.toLowerCase()))
                                  .toList()
                                  .map((e) => InkWell(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              right: AppSizes.regular),
                                          child: Row(
                                            children: [
                                              Radio(
                                                  value: e.isSelected,
                                                  groupValue: true,
                                                  onChanged: (_) {
                                                    if (e.onTap != null) {
                                                      e.onTap!();
                                                    } else {
                                                      _onSelected(e);
                                                    }
                                                  }),
                                              Expanded(
                                                  child: CustomText(
                                                text: e.text,
                                                color: AppColors.black,
                                                fontSize: AppTextSizes.subTitle,
                                                fontWeight: FontWeight.w500,
                                              ))
                                            ],
                                          ),
                                        ),
                                        onTap: e.onTap ?? () => _onSelected(e),
                                      ))
                                  .toList() ??
                              [],
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: Utility.hideKeyboard,
              ),
            ),
          ],
        ),
        onTap: () => CustomNavigator.pop(context),
      ),
    );
  }
}

class CustomBottomCheckBoxOption extends StatefulWidget {
  final String? title;
  final List<CustomBottomOptionModel>? options;
  final CustomRefreshCallback? onRefresh;
  final bool shrinkWrap;
  final Function(CustomBottomOptionModel)? onSingleChoice;
  final GestureTapCallback? onMultiChoice;

  CustomBottomCheckBoxOption(
      {this.options,
      this.onRefresh,
      this.shrinkWrap = true,
      this.onSingleChoice,
      this.title,
      this.onMultiChoice});

  @override
  CustomBottomCheckBoxOptionState createState() =>
      CustomBottomCheckBoxOptionState();
}

class CustomBottomCheckBoxOptionState
    extends State<CustomBottomCheckBoxOption> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  _onSelected(CustomBottomOptionModel model) {
    if (widget.onMultiChoice != null) {
      model.isSelected = !(model.isSelected ?? false);
      setState(() {});
    } else {
      CustomNavigator.pop(context);
      widget.onSingleChoice?.call(model);
    }
  }

  Widget _buildContainer(List<Widget> children) {
    return Container(
      // margin: EdgeInsets.all(AppSizes.regular),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: AppColors.white,
      ),
      child: CustomListView(
          padding: EdgeInsets.zero,
          shrinkWrap: widget.shrinkWrap,
          separator: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.regular),
            child: CustomLine(),
          ),
          children: children),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: Colors.transparent,
      body: InkWell(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: AppSizes.screenSize(context).height * 0.3,
            ),
            Flexible(
              fit: FlexFit.loose,
              child: InkWell(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16.0)),
                    color: AppColors.white,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.title != null)
                        Padding(
                          padding: EdgeInsets.only(
                              top: AppSizes.regular,
                              right: AppSizes.regular,
                              left: AppSizes.regular),
                          child: CustomText(
                            text: widget.title,
                            color: AppColors.grey,
                            fontWeight: FontWeight.w500,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: ContainerDataBuilder(
                          data: widget.options,
                          emptyBuilder: CustomEmpty(
                            isScrollable: false,
                          ),
                          bodyBuilder: () => _buildContainer(widget.options!
                              .map((e) => InkWell(
                                    child: Padding(
                                      padding: EdgeInsets.all(AppSizes.regular),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          (widget.onMultiChoice != null &&
                                                  (widget.options?.length ??
                                                          0) >
                                                      0)
                                              ? Icon(
                                                  (e.isSelected ?? false)
                                                      ? Icons.check_box
                                                      : Icons
                                                          .check_box_outline_blank,
                                                  size: 24.0,
                                                  color: AppColors.blue,
                                                )
                                              : Icon(
                                                  (e.isSelected ?? false)
                                                      ? Icons
                                                          .radio_button_checked
                                                      : Icons
                                                          .radio_button_off_outlined,
                                                  size: 24.0,
                                                  color: AppColors.blue,
                                                ),
                                          Gaps.hGap8,
                                          if (e.icon != null || e.image != null)
                                            Container(
                                              padding: EdgeInsets.only(
                                                  right: AppSizes.small),
                                              child: e.icon != null
                                                  ? CustomImageIcon(
                                                      icon: e.icon,
                                                      size: AppSizes.icon,
                                                      color: e.iconColor ??
                                                          AppColors.hint,
                                                    )
                                                  : CustomImage(
                                                      image: e.image!,
                                                      width: AppSizes.icon,
                                                    ),
                                            ),
                                          Expanded(
                                            child: CustomText(
                                              text: e.text,
                                              color: AppColors.black,
                                              fontSize: AppTextSizes.subTitle,
                                              textAlign: e.isSelected != null
                                                  ? TextAlign.left
                                                  : TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: e.onTap ?? () => _onSelected(e),
                                  ))
                              .toList()),
                          onRefresh: widget.onRefresh,
                        ),
                      ),
                      if (widget.onMultiChoice != null &&
                          (widget.options?.length ?? 0) > 0)
                        Container(
                          padding: EdgeInsets.all(AppSizes.regular),
                          decoration: BoxDecoration(
                              border: Border(
                                  top: BorderSide(color: AppColors.border))),
                          child: Row(
                            children: [
                              Expanded(
                                child: CustomButton(
                                  color: Colors.blue[50],
                                  textColor: AppColors.primary,
                                  text: AppLocalizations.text(LangKey.cancel),
                                  onTap: () => CustomNavigator.pop(context),
                                ),
                              ),
                              Gaps.hGap12,
                              Expanded(
                                child: CustomButton(
                                  text: AppLocalizations.text(LangKey.choose),
                                  onTap: widget.onMultiChoice,
                                ),
                              )
                            ],
                          ),
                        )
                    ],
                  ),
                ),
                onTap: Utility.hideKeyboard,
              ),
            ),
          ],
        ),
        onTap: () => CustomNavigator.pop(context),
      ),
    );
  }
}

class CustomBottomOptionSearchV2 extends StatefulWidget {
  final String title;
  final List<CustomBottomOptionModel>? options;
  final Function(CustomBottomOptionModel)? onTap;
  final bool? showSearch;
  final FontWeight? fontWeight;
  final Color? color;
  final double? fontSize;

  const CustomBottomOptionSearchV2(
      {super.key,
      required this.title,
      this.options,
      this.onTap,
      this.showSearch = true,
      this.fontWeight,
      this.color,
      this.fontSize});

  @override
  CCustomBottomOptionSearchV2State createState() =>
      CCustomBottomOptionSearchV2State();
}

class CCustomBottomOptionSearchV2State
    extends State<CustomBottomOptionSearchV2> {
  final FocusNode focusSearch = FocusNode();
  final TextEditingController controllerSearch = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  _onSearch() {
    setState(() {});
  }

  _onSelected(CustomBottomOptionModel model) {
    CustomNavigator.pop(context);
    widget.onTap?.call(model);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: Colors.transparent,
      isBottomSheet: true,
      body: InkWell(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: AppSizes.screenSize(context).height * 0.3,
            ),
            Expanded(
              child: InkWell(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16.0)),
                    color: AppColors.white,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(AppSizes.regular),
                        child: CustomText(
                          text: widget.title,
                          color: widget.color ?? AppColors.hint,
                          fontWeight: widget.fontWeight,
                          fontSize: widget.fontSize,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      if (widget.showSearch!)
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: AppSizes.regular),
                          child: CustomSearch(
                            focusNode: focusSearch,
                            controller: controllerSearch,
                            onSearch: _onSearch,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.hint),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                          ),
                        ),
                      Expanded(
                        child: CustomListView(
                          padding: EdgeInsets.zero,
                          separator: CustomLine(),
                          children: widget.options
                                  ?.where((e) => (e.text ?? "")
                                      .toLowerCase()
                                      .contains(controllerSearch.text))
                                  .toList()
                                  .map((e) => InkWell(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              right: AppSizes.regular),
                                          child: Row(
                                            children: [
                                              Radio(
                                                  value: e.isSelected,
                                                  groupValue: true,
                                                  onChanged: (_) {
                                                    if (e.onTap != null) {
                                                      e.onTap!();
                                                    } else {
                                                      _onSelected(e);
                                                    }
                                                  }),
                                              Expanded(
                                                  child: CustomText(
                                                text: e.text,
                                                color: AppColors.black,
                                                fontSize: AppTextSizes.subTitle,
                                                fontWeight: FontWeight.w500,
                                              ))
                                            ],
                                          ),
                                        ),
                                        onTap: e.onTap ?? () => _onSelected(e),
                                      ))
                                  .toList() ??
                              [],
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: Utility.hideKeyboard,
              ),
            ),
          ],
        ),
        onTap: () => CustomNavigator.pop(context),
      ),
    );
  }
}

class CustomBottomOptionModel {
  dynamic id;
  String? icon;
  String? image;
  String? text;
  Color? textColor;
  Color? iconColor;
  bool? isSelected;
  dynamic data;
  GestureTapCallback? onTap;

  CustomBottomOptionModel(
      {this.id,
      this.icon,
      this.image,
      this.text,
      this.textColor,
      this.iconColor,
      this.isSelected,
      this.data,
      this.onTap});
}

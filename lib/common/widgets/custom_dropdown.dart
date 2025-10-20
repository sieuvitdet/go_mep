part of widget;

class CustomDropdown extends StatelessWidget {
  final String? title;
  final List<CustomDropdownModel>? menus;
  final CustomDropdownModel? value;
  final Function(CustomDropdownModel)? onChanged;
  final String? hint;

  CustomDropdown(
      {this.menus, this.value, this.onChanged, this.hint, this.title});

  final double _radius = 5.0;

  _showOptions(BuildContext context) {
    List<CustomBottomOptionModel> models = menus!
        .map((e) => CustomBottomOptionModel(
            text: e.text,
            textColor: e.color,
            isSelected: value?.id == e.id,
            onTap: () {
              CustomNavigator.pop(context);
              onChanged!(e);
            }))
        .toList();
    CustomNavigator.showCustomBottomDialog(
        context,
        CustomBottomOption(
          title: title ?? AppLocalizations.text(LangKey.choose),
          options: models,
        ));
  }

  Widget _buildBody(BuildContext context, String? text,
      {bool isHint = false, Color? textColor}) {
    return InkWell(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_radius),
            color:
                (menus ?? []).isNotEmpty ? Colors.transparent : Colors.grey[50],
            border: Border.all(
              color: AppColors.greyLight,
            )),
        padding: EdgeInsets.all(AppSizes.semiRegular),
        child: Row(
          children: [
            Expanded(
                child: CustomText(
              text: (isHint ? hint : text) ?? "",
              fontSize: AppTextSizes.body,
              color: isHint ? AppColors.hint : (textColor ?? AppColors.black),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )),
            Gaps.hGap12,
            CustomImageIcon(
              icon: Assets.iconArrowDown,
              size: 20.0,
              color: AppColors.primary,
            )
          ],
        ),
      ),
      onTap: onChanged == null ? null : () => _showOptions(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (menus == null) {
      return LoadingWidget(
        child: CustomSkeleton(
          height: AppSizes.regular * 2,
          radius: _radius,
        ),
      );
    }

    if (value == null) {
      return _buildBody(context, hint, isHint: true);
    }

    return _buildBody(context, value!.text, textColor: value!.color);
  }
}

class CustomDropdownMenu extends StatelessWidget {
  final String? title;
  final String? iconUrl;
  final List<CustomDropdownModel>? menus;
  final CustomDropdownModel? value;
  final Function(CustomDropdownModel)? onChanged;

  const CustomDropdownMenu(
      {super.key,
      this.title,
      this.iconUrl,
      this.menus,
      this.value,
      this.onChanged});

  final _iconSize = 20.0;

  _showOptions(BuildContext context) {
    List<CustomBottomOptionModel> models = menus!
        .map((e) => CustomBottomOptionModel(
            text: e.text,
            textColor: e.color,
            isSelected: value?.id == e.id,
            onTap: () {
              CustomNavigator.pop(context);
              onChanged!(e);
            }))
        .toList();
    CustomNavigator.showCustomBottomDialog(
        context,
        CustomBottomOption(
          title: title ?? AppLocalizations.text(LangKey.choose),
          options: models,
        ));
  }

  Widget _buildSkeleton() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppSizes.regular,
      ),
      child: LoadingWidget(
        padding: EdgeInsets.zero,
        child: Row(
          children: [
            CustomSkeleton(
              width: _iconSize,
              height: _iconSize,
              radius: _iconSize,
            ),
            Gaps.hGap8,
            Expanded(
              child: CustomSkeleton(),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: AppSizes.regular,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (iconUrl != null) ...[
              CustomNetworkImage(
                url: iconUrl,
                width: _iconSize,
                height: _iconSize,
              ),
              Gaps.hGap8,
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gaps.vGap2,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                          child: CustomText(
                        text: title ?? "",
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      )),
                      CustomText(
                        text: " (${AppLocalizations.text(LangKey.optional)})",
                        fontWeight: FontWeight.w500,
                        color: AppColors.hint,
                      )
                    ],
                  ),
                  if (value != null) ...[
                    Gaps.vGap2,
                    CustomText(
                      text: value?.text,
                      fontSize: AppSizes.semiRegular,
                      fontWeight: FontWeight.w500,
                      color: AppColors.grey,
                    )
                  ]
                ],
              ),
            ),
            if (onChanged != null) ...[
              Gaps.hGap8,
              Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.grey,
                size: 20.0,
              )
            ]
          ],
        ),
      ),
      onTap: onChanged == null ? null : () => _showOptions(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (menus == null) {
      return _buildSkeleton();
    }

    return _buildContent(context);
  }
}

class CustomDropdownModel {
  final dynamic id;
  final String? text;
  final dynamic data;
  final Color? color;

  CustomDropdownModel({this.id, this.text, this.data, this.color});
}

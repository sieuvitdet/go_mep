part of widget;

class CustomChip extends StatelessWidget {
  final String? icon;
  final String? text;
  final Color? backgroundColor;
  final Color? textColor;
  final double? textSize;
  final GestureTapCallback? onTap;

  const CustomChip(
      {super.key,
      this.icon,
      this.text,
      this.backgroundColor,
      this.textColor,
      this.onTap,
      this.textSize});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          radius: 100,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: backgroundColor ??
                    AppColors.primary.withValues(alpha: 0.2)),
            padding: EdgeInsets.symmetric(
                horizontal: AppSizes.semiRegular,
                vertical: AppSizes.semiRegular / 2),
            child: Row(
              children: [
                if (icon != null) ...[
                  CustomImageIcon(
                    icon: icon,
                    size: 16,
                    color: textColor ?? AppColors.white,
                  ),
                  SizedBox(
                    width: AppSizes.semiRegular / 2,
                  ),
                ],
                CustomText(
                  text: text,
                  color: textColor ?? AppColors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: textSize ?? AppTextSizes.subBody,
                )
              ],
            ),
          ),
          onTap: onTap,
        )
      ],
    );
  }
}

class CustomChipSelected extends StatelessWidget {
  final String? icon;
  final String? text;
  final double? textSize;
  final bool isSelected;
  final GestureTapCallback? onTap;

  const CustomChipSelected(
      {super.key,
      this.icon,
      this.text,
      this.isSelected = false,
      this.onTap,
      this.textSize});

  @override
  Widget build(BuildContext context) {
    Color? backgroundColor, textColor;

    if (!isSelected) {
      backgroundColor = AppColors.white;
      textColor = AppColors.primary;
    }

    return CustomChip(
      icon: icon,
      text: text,
      backgroundColor: backgroundColor,
      textColor: textColor,
      textSize: textSize,
      onTap: onTap,
    );
  }
}

class CustomStatus extends StatelessWidget {
  final String text;
  final Color? color;

  const CustomStatus({super.key, required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: (color ?? AppColors.blue).withValues(alpha: 0.3)),
      padding: EdgeInsets.symmetric(
          horizontal: AppSizes.semiRegular, vertical: AppSizes.semiRegular / 2),
      child: CustomText(
        text: text,
        color: color ?? AppColors.blue,
        fontWeight: FontWeight.bold,
        fontSize: AppTextSizes.subBody,
      ),
    );
  }
}

class ContainerChipSelected extends StatefulWidget {
  final List<SearchBoxModel> models;
  final Function(SearchBoxModel) onChanged;
  final WrapAlignment? alignment;
  final double? textSize;
  final double? spacing;

  const ContainerChipSelected(
      {super.key,
      required this.models,
      required this.onChanged,
      this.alignment,
      this.textSize,
      this.spacing});

  @override
  ContainerChipSelectedState createState() => ContainerChipSelectedState();
}

class ContainerChipSelectedState extends State<ContainerChipSelected> {
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

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: widget.spacing ?? 0.0,
      runSpacing: AppSizes.semiRegular,
      alignment: widget.alignment ?? WrapAlignment.start,
      children: widget.models
          .map((e) => CustomChipSelected(
                icon: e.icon,
                text: e.text,
                textSize: widget.textSize,
                isSelected: e.isSelected,
                onTap: e.isSelected
                    ? null
                    : () {
                        try {
                          widget.models
                              .firstWhere((element) => element.isSelected)
                              .isSelected = false;
                        } catch (_) {}
                        e.isSelected = true;
                        setState(() {});
                        widget.onChanged(e);
                      },
              ))
          .toList(),
    );
  }
}

class SearchBoxModel {
  String? icon;
  String text;
  bool isSelected;

  SearchBoxModel({this.icon, required this.text, this.isSelected = false});
}

part of widget;

class CustomAlertDialog extends StatelessWidget {
  final String? title;
  final String? content;
  final String? textSubmitted;
  final GestureTapCallback? onSubmitted;
  final String? textSubSubmitted;
  final GestureTapCallback? onSubSubmitted;
  final Color? colorSubmitted;
  final bool enableCancel;
  final TextStyle? styleSubmitted;
  final TextStyle? styleSubSubmitted;
  final CustomAlertDialogType type;

  const CustomAlertDialog(
      {super.key,
      this.title,
      this.content,
      this.onSubmitted,
      this.textSubmitted,
      this.onSubSubmitted,
      this.textSubSubmitted,
      this.colorSubmitted,
      this.enableCancel = true,
      this.styleSubSubmitted,
      this.styleSubmitted,
      this.type = CustomAlertDialogType.info});

  Widget _buildImage(String image) {
    return Center(
      child: CustomImage(
        image: image,
        width: 45,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
          color: Colors.white),
      child: CustomListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: [
          if (type == CustomAlertDialogType.success)
            _buildImage(Assets.iconNotificationSuccess)
          else if (type == CustomAlertDialogType.warning)
            _buildImage(Assets.iconNotificationWarning)
          else
            _buildImage(Assets.iconNotificationFail),
          CustomText(
            text: title,
            fontSize: AppTextSizes.title,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.center,
            color: AppColors.black,
          ),
          CustomText(
            text: content,
            textAlign: TextAlign.center,
            color: AppColors.black,
          ),
          if (enableCancel || onSubmitted != null)
            Row(
              children: [
                if (enableCancel)
                  Expanded(
                      child: CustomButton(
                    color: AppColors.white,
                    text: textSubSubmitted ?? "Đóng",
                    style: styleSubSubmitted,
                    textColor: AppColors.black,
                    borderColor: AppColors.border,
                    isMain: false,
                    onTap: onSubSubmitted ?? () => CustomNavigator.pop(context),
                  )),
                if (enableCancel && onSubmitted != null)
                  SizedBox(
                    width: AppSizes.small,
                  ),
                if (onSubmitted != null)
                  Expanded(
                      child: CustomButton(
                    style: styleSubmitted,
                    text: textSubmitted ?? "Xác nhận",
                    onTap: onSubmitted,
                    color: colorSubmitted,
                  )),
              ],
            )
        ],
      ),
    );
  }
}

enum CustomAlertDialogType { success, warning, error, info }

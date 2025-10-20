part of widget;

class CustomPopup extends StatelessWidget {
  final String title;
  final String content;
  final String? titleSubmit;
  final String? titleUnSubmit;
  final bool showCloseIcon;
  final bool showActionButtons;
  final GestureTapCallback? onConfirm;
  final GestureTapCallback? onClose;
  final TextAlign? textAlign;

  const CustomPopup(
      {Key? key,
      required this.title,
      required this.content,
      this.titleSubmit,
      this.titleUnSubmit,
      this.showCloseIcon = false,
      this.showActionButtons = true,
      this.onConfirm,
      this.onClose,
      this.textAlign = TextAlign.center})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.semiRegular),
      ),
      child: Container(
        padding: EdgeInsets.all(AppSizes.regular),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.all(Radius.circular(AppSizes.semiRegular)),
          boxShadow: [
            BoxShadow(
              color: AppColors.hint,
              spreadRadius: 0.5,
              blurRadius: 3,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    textAlign: textAlign,
                    title,
                    style: TextStyle(
                        fontSize: AppTextSizes.title,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.small),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Text(
                    content,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: AppColors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.regular),
            CustomLine(),
            SizedBox(height: AppSizes.semiRegular),
            if (showActionButtons)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: onClose ?? () => Navigator.of(context).pop(),
                      child: Text(
                        titleUnSubmit ?? 'Hủy',
                        style: TextStyle(
                          fontSize: AppTextSizes.subTitle,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue,
                          decoration: TextDecoration.none,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(width: AppSizes.semiRegular),
                  Expanded(
                    child: GestureDetector(
                      onTap: onConfirm ?? () => Navigator.of(context).pop(),
                      child: Text(
                        titleSubmit ?? 'Xác nhận',
                        style: TextStyle(
                          fontSize: AppTextSizes.subTitle,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue,
                          decoration: TextDecoration.none,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              )
            else
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: onConfirm ?? () => Navigator.of(context).pop(),
                  child: Text(
                    titleSubmit ?? 'Xác nhận',
                    style: TextStyle(
                      fontSize: AppTextSizes.subTitle,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blue,
                      decoration: TextDecoration.none,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class CustomPopupImage extends StatelessWidget {
  final String title;
  final String content;
  final String? titleSubmit;
  final String? titleUnSubmit;
  final String? urlImage;
  final bool showCloseIcon;
  final bool showActionButtons;
  final GestureTapCallback? onConfirm;
  final GestureTapCallback? onClose;

  const CustomPopupImage({
    Key? key,
    required this.title,
    required this.content,
    this.titleSubmit,
    this.titleUnSubmit,
    this.urlImage,
    this.showCloseIcon = true,
    this.showActionButtons = true,
    this.onConfirm,
    this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.semiRegular),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.all(Radius.circular(AppSizes.semiRegular)),
          boxShadow: [
            BoxShadow(
              color: AppColors.hint,
              spreadRadius: 0.5,
              blurRadius: 3,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CustomNetworkImage(
                    url: urlImage,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(AppSizes.semiRegular),
                        topRight: Radius.circular(AppSizes.semiRegular))),
                if (showCloseIcon)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        if (onClose != null) {
                          onClose!();
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
                      child: Icon(
                        Icons.close,
                        color: AppColors.primary,
                        size: AppSizes.semiMedium,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: AppSizes.semiRegular),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.semiRegular),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: AppTextSizes.title,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSizes.semiRegular),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.semiRegular),
              child: Text(
                content,
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: AppTextSizes.subTitle,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            if (showActionButtons)
              Padding(
                padding: EdgeInsets.all(AppSizes.semiRegular),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: titleUnSubmit ?? 'Hủy',
                        isButtonSecond: true,
                        style: TextStyle(
                          fontSize: AppTextSizes.subTitle,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                        ),
                        onTap: onClose ?? () => Navigator.of(context).pop(),
                      ),
                    ),
                    SizedBox(width: AppSizes.semiRegular),
                    Expanded(
                      child: CustomButton(
                        text: titleSubmit ?? 'Xác nhận',
                        style: TextStyle(
                          fontSize: AppTextSizes.subTitle,
                          fontWeight: FontWeight.w500,
                          color: AppColors.white,
                        ),
                        onTap: onConfirm ?? () => Navigator.of(context).pop(),
                      ),
                    ),
                  ],
                ),
              )
            else
              Padding(
                padding: EdgeInsets.all(AppSizes.semiRegular),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: CustomButton(
                    text: titleSubmit ?? 'Xác nhận',
                    style: TextStyle(
                      fontSize: AppTextSizes.subTitle,
                      fontWeight: FontWeight.w500,
                      color: AppColors.white,
                    ),
                    onTap: onConfirm ?? () => Navigator.of(context).pop(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class CustomPopupQR extends StatelessWidget {
  final String? urlImage;
  final bool showCloseIcon;
  final bool showActionButtons;

  const CustomPopupQR({
    Key? key,
    this.urlImage,
    this.showCloseIcon = true,
    this.showActionButtons = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.semiRegular),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.all(Radius.circular(AppSizes.semiRegular)),
          boxShadow: [
            BoxShadow(
              color: AppColors.hint,
              spreadRadius: 0.5,
              blurRadius: 3,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Padding(
                  padding: EdgeInsets.all(AppSizes.medium),
                  child: CustomNetworkImage(
                      url: urlImage,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(AppSizes.semiRegular),
                          topRight: Radius.circular(AppSizes.semiRegular))),
                ),
                if (showCloseIcon)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.close,
                        color: AppColors.primary,
                        size: AppSizes.medium,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CustomPopupWarning extends StatelessWidget {
  final String content;

  const CustomPopupWarning({
    Key? key,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.semiRegular),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.all(Radius.circular(AppSizes.semiRegular)),
          boxShadow: [
            BoxShadow(
              color: AppColors.hint,
              spreadRadius: 0.5,
              blurRadius: 3,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSizes.regular),
                      child: CustomImage(
                        image: Assets.iconArrowDown,
                        width: AppSizes.extraLarge,
                        height: AppSizes.extraLarge,
                      ),
                    ),
                  ],
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.semiRegular),
              child: Center(
                child: Text(
                  content,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: AppTextSizes.subTitle,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: AppSizes.regular),
              child: CustomLine(
                size: 1.5,
              ),
            ),
            GestureDetector(
              onTap: () => CustomNavigator.pop(context),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(AppSizes.semiRegular),
                      bottomRight: Radius.circular(AppSizes.semiRegular)),
                ),
                padding: EdgeInsets.symmetric(vertical: AppSizes.regular),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        AppLocalizations.text(LangKey.close),
                        style: TextStyle(
                          fontSize: AppTextSizes.title,
                          fontWeight: FontWeight.w600,
                          color: AppColors.blue,
                        ),
                      ),
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

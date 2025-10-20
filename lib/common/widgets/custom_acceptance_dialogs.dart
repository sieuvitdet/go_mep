part of widget;

/// Dialog widget for confirming acceptance of inspection
class CustomAcceptanceConfirmDialog extends StatelessWidget {
  final String? title;
  final String? content;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const CustomAcceptanceConfirmDialog({
    Key? key,
    this.title,
    this.content,
    this.confirmText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(AppSizes.regular)),
        color: Colors.white,
      ),
      child: CustomListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(AppSizes.semiRegular),
                decoration: BoxDecoration(
                  color: AppColors.green.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Container(
                  width: AppSizes.semiMedium,
                  height: AppSizes.semiMedium,
                  decoration: BoxDecoration(
                    color: AppColors.green.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    color: AppColors.white,
                    size: AppSizes.regular,
                  ),
                ),
              ),
            ],
          ),

          // Title
          CustomText(
            text: title ?? "Xác nhận nghiệm thu",
            fontSize: AppTextSizes.title,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.center,
            color: AppColors.black,
          ),
          // Content
          CustomText(
            text: content ?? "Bạn có muốn nghiệm thu cho báo ghi\n này không?",
            textAlign: TextAlign.center,
            color: AppColors.black,
          ),
          SizedBox(height: AppSizes.small),

          // Action buttons
          Row(
            children: [
              // Cancel button
              Expanded(
                child: CustomButton(
                  color: AppColors.white,
                  text: cancelText ?? "Huỷ",
                  textColor: AppColors.black,
                  borderColor: AppColors.border.withOpacity(0.2),
                  isMain: false,
                  onTap: onCancel ?? () => CustomNavigator.pop(context),
                ),
              ),
              SizedBox(width: AppSizes.small),
              // Confirm button
              Expanded(
                child: CustomButton(
                  text: confirmText ?? "Xác nhận",
                  color: AppColors.primary,
                  onTap: onConfirm ?? () => CustomNavigator.pop(context),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

/// Dialog widget for rejecting inspection with reason input
class CustomAcceptanceRejectDialog extends StatefulWidget {
  final String? title;
  final String? content;
  final String? confirmText;
  final String? cancelText;
  final String? hintText;
  final int? maxLength;
  final ValueChanged<String>? onConfirm;
  final VoidCallback? onCancel;
  final TextEditingController? controller;

  const CustomAcceptanceRejectDialog({
    Key? key,
    this.title,
    this.content,
    this.confirmText,
    this.cancelText,
    this.hintText,
    this.maxLength,
    this.onConfirm,
    this.onCancel,
    this.controller,
  }) : super(key: key);

  @override
  State<CustomAcceptanceRejectDialog> createState() =>
      _CustomAcceptanceRejectDialogState();
}

class _CustomAcceptanceRejectDialogState
    extends State<CustomAcceptanceRejectDialog> {
  late TextEditingController _controller;
  String _text = '';

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onTextChanged);
    _text = _controller.text;
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    } else {
      _controller.removeListener(_onTextChanged);
    }
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _text = _controller.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(AppSizes.regular)),
        color: Colors.white,
      ),
      child: CustomListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: [
          // Close button (top right)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(AppSizes.semiRegular),
                decoration: BoxDecoration(
                  color: AppColors.red.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Container(
                  width: AppSizes.semiMedium,
                  height: AppSizes.semiMedium,
                  decoration: BoxDecoration(
                    color: AppColors.red.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close,
                    color: AppColors.white,
                    size: AppSizes.regular,
                  ),
                ),
              ),
            ],
          ),
          // Title
          CustomText(
            text: widget.title ?? "Từ chối nghiệm thu",
            fontSize: AppTextSizes.title,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.center,
            color: AppColors.black,
          ),
          // Content
          CustomText(
            text: widget.content ?? "Vui lòng nhập lý do từ chối!",
            textAlign: TextAlign.center,
            color: AppColors.black,
          ),
          // Text input field
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.borderTextField),
                  borderRadius: BorderRadius.circular(AppSizes.small),
                ),
                child: TextField(
                  controller: _controller,
                  maxLines: 2,
                  maxLength: null,
                  decoration: InputDecoration(
                    hintText: widget.hintText ?? "Nhập lí do từ chối",
                    hintStyle: TextStyle(
                      color: AppColors.hint,
                      fontSize: AppTextSizes.body,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(AppSizes.regular),
                    counterText: '',
                  ),
                ),
              ),
              SizedBox(height: AppSizes.extraSmall),
              Align(
                alignment: Alignment.centerRight,
                child: CustomText(
                  text: '${_text.length}/${widget.maxLength ?? 150}',
                  fontSize: AppTextSizes.subBody,
                  color: AppColors.hint,
                ),
              ),
            ],
          ),
          // Action buttons
          Row(
            children: [
              // Cancel button
              Expanded(
                child: CustomButton(
                  color: AppColors.white,
                  text: widget.cancelText ?? "Huỷ",
                  textColor: AppColors.black,
                  borderColor: AppColors.border.withOpacity(0.2),
                  isMain: false,
                  onTap: widget.onCancel ?? () => CustomNavigator.pop(context),
                ),
              ),
              SizedBox(width: AppSizes.small),
              // Confirm button
              Expanded(
                child: CustomButton(
                  text: widget.confirmText ?? "Xác nhận",
                  color: AppColors.axleConnectionRed,
                  onTap: () {
                    if (widget.onConfirm != null) {
                      widget.onConfirm!(_controller.text);
                    } else {
                      CustomNavigator.pop(context);
                    }
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

/// Helper methods for showing the dialogs
class AcceptanceDialogs {
  /// Show acceptance confirmation dialog
  static void showAcceptanceConfirmDialog(
    BuildContext context, {
    String? title,
    String? content,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: CustomAcceptanceConfirmDialog(
          title: title,
          content: content,
          confirmText: confirmText,
          cancelText: cancelText,
          onConfirm: onConfirm,
          onCancel: onCancel,
        ),
      ),
    );
  }

  /// Show rejection dialog with text input
  static void showAcceptanceRejectDialog(
    BuildContext context, {
    String? title,
    String? content,
    String? confirmText,
    String? cancelText,
    String? hintText,
    int? maxLength,
    ValueChanged<String>? onConfirm,
    VoidCallback? onCancel,
    TextEditingController? controller,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: CustomAcceptanceRejectDialog(
          title: title,
          content: content,
          confirmText: confirmText,
          cancelText: cancelText,
          hintText: hintText,
          maxLength: maxLength,
          onConfirm: onConfirm,
          onCancel: onCancel,
          controller: controller,
        ),
      ),
    );
  }
}

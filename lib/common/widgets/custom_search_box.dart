part of widget;

class CustomSearch extends StatefulWidget {
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final String? hintText;
  final Function? onSearch;
  final EdgeInsets? contentPadding;
  final TextInputType inputType;
  final bool prefixIcon;
  final Color? prefixIconColor;
  final InputBorder? border;
  final bool? autoFocus;
  final Function(String)? onChanged;

  const CustomSearch(
      {super.key,
      this.focusNode,
      this.controller,
      this.hintText,
      this.onSearch,
      this.contentPadding,
      this.inputType = TextInputType.text,
      this.prefixIcon = true,
      this.prefixIconColor,
      this.border,
      this.autoFocus,
      this.onChanged});

  @override
  CustomSearchState createState() => CustomSearchState();
}

class CustomSearchState extends State<CustomSearch> {
  final _iconSize = 18.0;
  final _debounce = CustomDebounce();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.controller != null) {
      widget.controller!.addListener(() {
        widget.onChanged?.call(widget.controller!.text);
        _debounce.onChange(() => widget.onSearch?.call());
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    widget.controller?.dispose();
    _debounce.dispose();
    super.dispose();
  }

  _onClear() {
    widget.controller?.clear();
    widget.onSearch?.call();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: widget.focusNode,
      controller: widget.controller,
      keyboardType: widget.inputType,
      autofocus: widget.autoFocus ?? widget.controller != null,
      decoration: InputDecoration(
          border: widget.border ?? InputBorder.none,
          focusedBorder: widget.border ?? InputBorder.none,
          hintText:
              widget.hintText ?? AppLocalizations.text(LangKey.data_empty),
          hintStyle: TextStyle(
              fontSize: AppTextSizes.body,
              color: AppColors.hint,
              fontWeight: FontWeight.normal),
          isDense: true,
          contentPadding: widget.contentPadding ??
              EdgeInsets.symmetric(
                  horizontal: AppSizes.semiRegular, vertical: AppSizes.small),
          prefixIcon: widget.prefixIcon
              ? Padding(
                  padding: EdgeInsets.only(right: AppSizes.semiRegular),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomImageIcon(
                        icon: Assets.iconArrowDown,
                        color: widget.prefixIconColor ?? Colors.black,
                      )
                    ],
                  ),
                )
              : null,
          prefixIconConstraints: BoxConstraints(
              maxWidth: 2 * AppSizes.regular + _iconSize,
              maxHeight: _iconSize * 3),
          suffixIcon: widget.controller == null
              ? null
              : widget.controller!.text.isEmpty
                  ? null
                  : IconButton(
                      onPressed: _onClear,
                      icon: CustomImage(
                        image: Assets.iconArrowDown,
                        color: AppColors.hint,
                        height: AppSizes.regular,
                        fit: BoxFit.contain,
                      )),
          suffixIconConstraints: BoxConstraints(maxHeight: _iconSize * 2)),
      style: TextStyle(
          fontSize: AppTextSizes.body,
          color: AppColors.black,
          fontWeight: FontWeight.w500),
      enabled: widget.controller != null,
    );
  }
}

class CustomDebounce {
  dispose() {
    _timer?.cancel();
  }

  Timer? _timer;

  onChange(void Function() onFunction) {
    if (_timer?.isActive ?? false) _timer!.cancel();
    _timer = Timer(const Duration(milliseconds: 700), onFunction);
  }
}

part of widget;

class CustomBottomSheet extends StatelessWidget {
  final List<KeyboardActionsItem>? actions;
  final String? title;
  final Widget? body;
  final CustomRefreshCallback? onRefresh;
  final CustomRefreshCallback? onTapDismissible;
  final CustomRefreshCallback? onTapWillPop;
  final List<CustomOptionAppBar>? options;

  CustomBottomSheet(
      {this.actions,
      this.title,
      this.body,
      this.onRefresh,
      this.options,
      this.onTapDismissible,
      this.onTapWillPop});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: Colors.transparent,
      actions: actions,
      isBottomSheet: true,
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
                        BorderRadius.vertical(top: Radius.circular(10.0)),
                    color: Colors.white,
                  ),
                  padding:
                      EdgeInsets.only(bottom: AppSizes.screenPadding.bottom),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: AppSizes.semiRegular / 2),
                        alignment: Alignment.center,
                        child: Container(
                          width: AppSizes.onTap,
                          height: 4.0,
                          decoration: BoxDecoration(
                              color: AppColors.hint,
                              borderRadius: BorderRadius.circular(100.0)),
                        ),
                      ),
                      title == null
                          ? Container()
                          : Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: AppColors.greyLight))),
                              child: CustomAppBar(
                                title: title,
                                options: options,
                                icon: Icons.close,
                                isBottomSheet: true,
                                onWillPop: onTapWillPop ??
                                    () => CustomNavigator.pop(context),
                              ),
                            ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: onRefresh == null
                            ? (body ?? Container())
                            : ContainerScrollable(
                                child: body ?? Container(),
                                onRefresh: onRefresh),
                      )
                    ],
                  ),
                ),
                onTap: Utility.hideKeyboard,
              ),
            ),
          ],
        ),
        onTap: onTapDismissible ?? () => CustomNavigator.pop(context),
      ),
    );
  }
}

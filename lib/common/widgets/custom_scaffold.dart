part of widget;

class CustomScaffold extends StatelessWidget {
  final Widget? body;
  final Widget? bodyTablet;
  final Widget? bodyDesktop;
  final String? title;
  final Widget? customTitle;
  final List<CustomOptionAppBar>? options;
  final CustomRefreshCallback? onRefresh;
  final bool isBottom;
  final Color? backgroundColor;
  final Widget? floatingActionButton;
  final List<KeyboardActionsItem>? actions;
  final IconData? icon;
  final List<CustomModelTabBar>? tabs;
  final TabController? tabController;
  final GestureTapCallback? onWillPop;
  final bool isBottomSheet;
  final bool isExpanded;
  final String? backgroundImage;
  final Widget? header;
  final Widget? endDrawer;
  final bool safeAreaButton;

  CustomScaffold(
      {super.key,
      this.body,
      this.bodyTablet,
      this.bodyDesktop,
      this.title,
      this.customTitle,
      this.options,
      this.onRefresh,
      this.isBottom = false,
      this.backgroundColor,
      this.floatingActionButton,
      this.actions,
      this.icon,
      this.tabs,
      this.tabController,
      this.onWillPop,
      this.isBottomSheet = false,
      this.isExpanded = true,
      this.backgroundImage,
      this.header,
      this.endDrawer,
      this.safeAreaButton = false});

  Widget _buildChild(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= AppSizes.sizeDesktop) {
          return bodyDesktop ?? bodyTablet ?? body ?? const SizedBox();
        } else if (constraints.maxWidth >= AppSizes.sizeTablet) {
          return bodyTablet ?? body ?? const SizedBox();
        }
        return body ?? const SizedBox();
      },
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      children: [
        (title == null && customTitle == null)
            ? Container()
            : CustomAppBar(
                title: title,
                customTitle: customTitle,
                options: options,
                icon: icon,
                onWillPop: onWillPop,
                child: header,
              ),
        tabs == null || tabController == null
            ? Container()
            : CustomTabBar(
                tabs: tabs!,
                group: AutoSizeGroup(),
                controller: tabController!,
                isExpanded: isExpanded,
              ),
        Expanded(
            child: tabs == null
                ? ContainerScrollable(
                    onRefresh: onRefresh, child: _buildChild(context))
                : CustomTabBarView(
                    controller: tabController,
                    tabs: tabs,
                  )),
        // if (isBottomSheet)
        //   SizedBox(
        //     height: bottom,
        //   )
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.white,
      appBar: (body != null && body is CupertinoPageScaffold)
          ? null
          : const PreferredSize(
              preferredSize: Size.zero,
              child: SizedBox(),
            ),
      body: SafeArea(
        top: false,
        left: false,
        right: false,
        bottom: !safeAreaButton,
        child: Container(
            width: double.infinity,
            height: double.infinity,
            child: backgroundImage == null
                ? _buildContent(context)
                : Stack(
                    fit: StackFit.expand,
                    children: [
                      SingleChildScrollView(
                        child: SizedBox(
                          width: AppSizes.screenSize(context).width,
                          height: AppSizes.screenSize(context).height,
                          child: CustomImage(
                            image: backgroundImage!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      _buildContent(context)
                    ],
                  )),
      ),
      floatingActionButton: floatingActionButton,
      resizeToAvoidBottomInset: !isBottomSheet,
      endDrawer: endDrawer,
    );
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardActions(
      config: Utility.configKeyboardActions(actions ?? []),
      disableScroll: true,
      enable: Platform.isIOS || Platform.isMacOS,
      child: onWillPop == null
          ? _buildBody(context)
          : PopScope(
              canPop: false,
              onPopInvoked: (event) {
                if (!event) {
                  onWillPop!();
                }
              },
              child: _buildBody(context),
            ),
    );
  }
}

part of widget;

class CustomTabBar extends StatelessWidget {
  final bool isExpanded;
  final List<CustomModelTabBar> tabs;
  final AutoSizeGroup? group;
  final TabController controller;
  final ValueChanged<int>? onTap;

  const CustomTabBar(
      {super.key,
      required this.tabs,
      this.group,
      required this.controller,
      this.isExpanded = true,
      this.onTap});

  Widget _buildTitle(CustomModelTabBar model) {
    if (model.titleWidget != null) {
      return model.titleWidget!;
    }
    Widget child = AutoSizeText(
      model.title ?? model.name!,
      maxLines: 1,
      group: group ?? AutoSizeGroup(),
      minFontSize: 6.0,
      textAlign: TextAlign.center,
    );
    return model.stream == null
        ? child
        : StreamBuilder(
            stream: model.stream,
            initialData: null,
            builder: (_, snapshot) {
              return CustomBadge(
                badge: snapshot.data,
                child: child,
              );
            });
  }

  Widget _buildTab(BuildContext context, CustomModelTabBar model) {
    return SizedBox(
        width: isExpanded
            ? (AppSizes.screenSize(context).width) / tabs.length
            : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            model.icon == null
                ? Container()
                : Container(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: ImageIcon(
                      AssetImage(model.icon!),
                      size: 20,
                    )),
            isExpanded
                ? Flexible(fit: FlexFit.loose, child: _buildTitle(model))
                : _buildTitle(model)
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TabBar(
        tabAlignment: TabAlignment.start,
        labelColor: AppColors.black,
        labelStyle: TextStyle(
            fontSize: AppTextSizes.body,
            fontWeight: FontWeight.w500,
            fontFamily: AppFonts.font),
        unselectedLabelColor: AppColors.labelSecondary.withOpacity(0.6),
        unselectedLabelStyle:
            TextStyle(fontSize: AppTextSizes.body, fontFamily: AppFonts.font),
        indicatorWeight: 1.0,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorColor: AppColors.black,
        labelPadding: EdgeInsets.symmetric(
            horizontal: isExpanded ? 0.0 : AppSizes.regular),
        isScrollable: true,
        onTap: onTap,
        dividerHeight: 0.0,
        tabs: tabs.map((model) {
          return Tab(child: _buildTab(context, model));
        }).toList(),
        controller: controller,
      ),
    );
  }
}

class CustomTabBarView extends StatelessWidget {
  final List<CustomModelTabBar>? tabs;
  final TabController? controller;
  final ScrollPhysics? physics;

  const CustomTabBarView({super.key, this.tabs, this.controller, this.physics});

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: controller,
      physics: physics,
      children: tabs!.map((model) => model.child).toList(),
    );
  }
}

class CustomModelTabBar {
  final String? name;
  String? title;
  final Widget? titleWidget;
  final String? icon;
  final ValueStream<int?>? stream;
  final Widget child;

  CustomModelTabBar(
      {this.name,
      this.title,
      this.titleWidget,
      this.icon,
      required this.child,
      this.stream});
}

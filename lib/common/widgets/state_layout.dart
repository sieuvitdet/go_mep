part of widget;

class StateLayout extends StatelessWidget {
  StateLayout({
    Key? key,
    required this.type,
    this.hintText,
    this.itemListHeight = 60,
  }) : super(key: key);

  final StateType type;
  final String? hintText;
  final double itemListHeight;

  final giftList = WrapContentHozListView(
    list: List.filled(6, null, growable: false),
    itemBuilder: (_, __) => ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      child: Container(
        width: 164,
        height: 240,
        color: AppColors.white,
      ),
    ),
    separatorBuilder: (_, index) => index == 0 ? Gaps.empty : Gaps.hGap16,
  );

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case StateType.LOADING_NOTI:
        return _buildListLoading();
      case StateType.DETAIL_DEPLOYMENT:
        return _buildLoadingDetailDeployment();
      case StateType.HOME:
        return _buildLoadingHome(context);
      default:
        return _buildDefaultState(context);
    }
  }

  _buildDefaultState(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (type == StateType.LOADING)
          const CupertinoActivityIndicator(radius: 16.0)
        else if (type != StateType.EMPTY)
          Opacity(
            opacity: 1,
            child: Container(
              height: 120.0,
              width: 120.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Assets.appImage),
                ),
              ),
            ),
          ),
        const SizedBox(
          width: double.infinity,
          height: AppSizes.regular,
        ),
        Gaps.vGap50,
      ],
    );
  }

  _buildListLoading() {
    return LoadingWidget(
      child: ListView.builder(
        padding: EdgeInsets.only(top: 0),
        physics: NeverScrollableScrollPhysics(),
        itemCount: 20,
        itemBuilder: (context, index) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: AppColors.white,
          ),
          margin: EdgeInsets.only(top: 4),
          height: itemListHeight,
        ),
      ),
    );
  }

  _buildLoadingHome(BuildContext context) {
    return LoadingWidget(
      child: Padding(
        padding: EdgeInsets.only(top: 40),
        child: ListView.builder(
          padding: EdgeInsets.only(top: 0),
          physics: NeverScrollableScrollPhysics(),
          itemCount: 20,
          itemBuilder: (context, index) => (index == 0)
              ? Container(
                  height: itemListHeight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: AppColors.white,
                        ),
                        width: context.screenWidth / 2,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: AppColors.white, shape: BoxShape.circle),
                        width: 40,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: AppColors.white, shape: BoxShape.circle),
                        width: 40,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: AppColors.white, shape: BoxShape.circle),
                        width: 40,
                      ),
                    ],
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: AppColors.white,
                  ),
                  margin: EdgeInsets.only(top: 4),
                  height: itemListHeight,
                ),
        ),
      ),
    );
  }

  _buildLoadingDetailDeployment() {
    return LoadingWidget(
      child: Padding(
        padding: EdgeInsets.only(top: 40),
        child: ListView.builder(
          padding: EdgeInsets.only(top: 0),
          physics: NeverScrollableScrollPhysics(),
          itemCount: 20,
          itemBuilder: (context, index) => (index == 0)
              ? Container(
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: (context.screenWidth - 100) / 4,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: AppColors.white),
                      ),
                      Container(
                        width: (context.screenWidth - 100) / 4,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: AppColors.white),
                      ),
                      Container(
                        width: (context.screenWidth - 100) / 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: AppColors.white,
                        ),
                      ),
                      Container(
                        width: (context.screenWidth - 100) / 4,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: AppColors.white),
                      ),
                    ],
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: AppColors.white,
                  ),
                  margin: EdgeInsets.only(top: 4),
                  height: itemListHeight,
                ),
        ),
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;

  const LoadingWidget({
    Key? key,
    required this.child,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.only(left: 16, right: 16, top: 16),
      child: Shimmer.fromColors(
        baseColor: Color(0xffE9E9E9),
        highlightColor: Colors.white,
        enabled: true,
        child: child,
      ),
    );
  }
}

enum StateType {
  NETWORK,
  EMPTY,
  LOADING_NOTI,
  DETAIL_DEPLOYMENT,
  HOME,
  LOADING,
}

extension StateTypeExtension on StateType {
  String get hintText => [
        'Lỗi mạng',
        'Không có dữ liệu',
        'Không có thông báo',
        'Không có dữ liệu',
        'loading',
        '',
        '',
        ''
      ][index];
}

class WrapContentHozListView<T> extends StatefulWidget {
  final List<T> list;
  final IndexedWidgetBuilder itemBuilder;
  final IndexedWidgetBuilder? separatorBuilder;

  WrapContentHozListView({
    required this.list,
    required this.itemBuilder,
    this.separatorBuilder,
  });

  @override
  _WrapContentHozListViewState createState() => _WrapContentHozListViewState();
}

class _WrapContentHozListViewState extends State<WrapContentHozListView> {
  List<Widget> _generateItemWidgets() {
    List<Widget> items = [];
    for (int i = 0; i < widget.list.length; i++) {
      if (widget.separatorBuilder != null) {
        items.add(widget.separatorBuilder!(context, i));
      }
      items.add(widget.itemBuilder(context, i));
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: BouncingScrollPhysics(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _generateItemWidgets(),
      ),
    );
  }
}

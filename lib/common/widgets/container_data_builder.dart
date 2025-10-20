part of widget;

class ContainerDataBuilder extends StatelessWidget {
  final dynamic data;
  final Widget? emptyBuilder;
  final Widget? skeletonBuilder;
  final CustomBodyBuilder bodyBuilder;
  final CustomRefreshCallback? onRefresh;

  ContainerDataBuilder({
    this.data,
    this.emptyBuilder,
    this.skeletonBuilder,
    required this.bodyBuilder,
    this.onRefresh,
  });

  Widget? _buildBody() {
    if (data == null) {
      return skeletonBuilder ??
          Padding(
            padding: EdgeInsets.all(AppSizes.small),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
    }

    if (data is List) {
      Widget body;
      if (data.isEmpty) {
        body = emptyBuilder ?? CustomEmpty();
      } else {
        body = bodyBuilder();
      }

      return ContainerScrollable(
        child: body,
        onRefresh: onRefresh,
      );
    }

    return ContainerScrollable(
      child: bodyBuilder(),
      onRefresh: onRefresh,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: AppAnimation.duration,
      child: _buildBody(),
    );
  }
}

part of widget;

class ContainerScrollable extends StatelessWidget {
  final Widget? child;
  final CustomRefreshCallback? onRefresh;

  ContainerScrollable({this.child, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return onRefresh == null
        ? child!
        : RefreshIndicator(child: child!, onRefresh: onRefresh!);
  }
}

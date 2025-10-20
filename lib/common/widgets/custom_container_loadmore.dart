part of widget;

class CustomContainerLoadMore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.onTap,
      child: Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }
}

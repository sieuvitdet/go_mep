part of widget;

class CustomPopupMenu extends StatelessWidget {
  final MenuAnchorChildBuilder? builder;
  final EdgeInsetsGeometry? padding;
  final Widget child;
  final MenuController? controller;

  const CustomPopupMenu(
      {super.key,
      this.builder,
      this.padding,
      required this.child,
      this.controller});

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      controller: controller,
      style: MenuStyle(
        minimumSize: WidgetStateProperty.resolveWith<Size?>(
          (Set<WidgetState> states) {
            return null;
          },
        ),
        maximumSize: WidgetStateProperty.resolveWith<Size?>(
          (Set<WidgetState> states) {
            return null;
          },
        ),
        padding: WidgetStateProperty.resolveWith<EdgeInsetsGeometry?>(
          (Set<WidgetState> states) {
            return EdgeInsets.zero;
          },
        ),
        backgroundColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            return Colors.transparent;
          },
        ),
        shadowColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            return Colors.transparent;
          },
        ),
        elevation: WidgetStateProperty.resolveWith<double?>(
          (Set<WidgetState> states) {
            return 0.0;
          },
        ),
      ),
      menuChildren: [
        Container(
          margin: padding ?? EdgeInsets.zero,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: AppColors.grey.withValues(alpha: 0.5))),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: child,
          ),
        )
      ],
      builder: builder,
    );
  }
}

class CustomPopupMenuItem extends StatelessWidget {
  final List<CustomPopupMenuItemModel> children;
  final double separate;

  const CustomPopupMenuItem(
      {super.key, required this.children, this.separate = 1});

  Widget _buildItem(int index) {
    return InkWell(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: AppColors.white,
            border: index != children.length - 1
                ? Border(
                    bottom:
                        BorderSide(width: separate, color: Color(0xFFDFDFDF)))
                : null),
        padding: EdgeInsets.symmetric(
            horizontal: AppSizes.regular, vertical: AppSizes.small),
        child: children[index].child,
      ),
      onTap: children[index].onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(children.length, _buildItem).toList(),
    );
  }
}

class CustomPopupMenuItemModel {
  final Widget child;
  final GestureTapCallback? onTap;

  CustomPopupMenuItemModel({required this.child, this.onTap});
}

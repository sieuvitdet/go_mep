part of widget;

class CustomImage extends StatelessWidget {
  final String? image;
  final double? scale;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit? fit;
  final Function()? onTap;

  const CustomImage(
      {super.key,
      this.image,
      this.scale,
      this.width,
      this.height,
      this.color,
      this.fit,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        image ?? '',
        scale: scale,
        width: width,
        height: height,
        color: color,
        fit: fit,
      ),
    );
  }
}

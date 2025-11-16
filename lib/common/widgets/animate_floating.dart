part of widget;

class AnimatedFloatingSearchButton extends StatefulWidget {
  final VoidCallback onTap;

  const AnimatedFloatingSearchButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  State<AnimatedFloatingSearchButton> createState() =>
      _AnimatedFloatingSearchButtonState();
}

class _AnimatedFloatingSearchButtonState
    extends State<AnimatedFloatingSearchButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              spreadRadius: 0,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.gradientStart,
                    AppColors.gradientEnd,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Icon(Icons.chat, color: Colors.white, size: 20),
            ),
          ),
        ),
      ),
    );
  }
}

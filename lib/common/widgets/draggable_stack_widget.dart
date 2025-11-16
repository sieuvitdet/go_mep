part of widget;

class DraggableStackWidget extends StatefulWidget {
  const DraggableStackWidget({
    this.initialDraggableOffset,
  });

  final Offset? initialDraggableOffset;

  @override
  State<DraggableStackWidget> createState() => _DraggableStackWidgetState();
}

class _DraggableStackWidgetState extends State<DraggableStackWidget>
    with SingleTickerProviderStateMixin {
  final GlobalKey _key = GlobalKey();
  late Offset _offset;
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _offset =
        widget.initialDraggableOffset ?? Offset(20, AppSizes.maxHeight * 0.8);
    // _lastPosition = _offset;

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _animationController.addListener(() {
      setState(() {
        _offset = _animation.value;
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _updatePosition(Offset newOffset) {
    if (!_isExpanded && !_animationController.isAnimating) {
      setState(() {
        _offset = newOffset;
        // _lastPosition = newOffset;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      key: _key,
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          CustomDraggableWidget(
            parentKey: _key,
            initialOffset: _offset,
            maxChildWidth: 150.0,
            onPositionChanged: _updatePosition,
            preventDragging: _isExpanded || _animationController.isAnimating,
          ),
        ],
      ),
    );
  }

  //  Widget _buildFloatingSearchButton() {
  //   return AnimatedFloatingSearchButton(
  //     onTap: () {
  //       widget.mainBloc?.streamIsSearchExpanded.set(true);
  //       showDialog(
  //         barrierDismissible: false,
  //         context: widget.mainBloc!.context, builder: (context) => GradientSearchToolWidget(
  //                 mainBloc: widget.mainBloc!,
  //                 streamIsSearchExpanded: widget.mainBloc!.streamIsSearchExpanded
  //               ));
  //     },
  //   );
  // }
}

class CustomDraggableWidget extends StatefulWidget {
  final GlobalKey parentKey;
  final Widget? child;
  final Offset initialOffset;
  final Function(Offset) onPositionChanged;
  final bool preventDragging;
  final double maxChildWidth;

  const CustomDraggableWidget({
    Key? key,
    this.child,
    required this.initialOffset,
    required this.parentKey,
    required this.onPositionChanged,
    this.preventDragging = false,
    this.maxChildWidth = 150.0,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CustomDraggableWidgetState();
}

class _CustomDraggableWidgetState extends State<CustomDraggableWidget>
    with TickerProviderStateMixin {
  final GlobalKey _key = GlobalKey();
  bool _isDragging = false;
  late Offset _position;
  Offset _minPosition = Offset.zero;
  Offset _maxPosition = Offset(double.infinity, double.infinity);
  late AnimationController _animationController;
  late Animation<Offset> _animation;

  // Thêm biến để track current child width
  double _currentChildWidth = 40.0;
  bool _isNearLeftEdge = false;
  bool _isNearRightEdge = false;

  static const double _edgeThreshold = 20.0; // Khoảng cách tối thiểu từ mép

  @override
  void initState() {
    super.initState();
    _position = widget.initialOffset;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setBoundary();
      _checkEdgeProximity();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _setBoundary() {
    try {
      final RenderBox? parentRenderBox =
          widget.parentKey.currentContext?.findRenderObject() as RenderBox?;
      final RenderBox? renderBox =
          _key.currentContext?.findRenderObject() as RenderBox?;

      if (parentRenderBox != null && renderBox != null) {
        final Size parentSize = parentRenderBox.size;
        final Size size = renderBox.size;
        _currentChildWidth = size.width;

        setState(() {
          _minPosition = const Offset(0, 0);
          _maxPosition = Offset(
              parentSize.width - widget.maxChildWidth, // Sử dụng max width
              parentSize.height -
                  size.height -
                  MediaQuery.of(context).padding.top);

          // Adjust initial position if needed
          _position = Offset(
            _position.dx.clamp(_minPosition.dx, _maxPosition.dx),
            _position.dy.clamp(_minPosition.dy, _maxPosition.dy),
          );
        });
      }
    } catch (e) {
      debugPrint('Error setting boundary: $e');
    }
  }

  void _checkEdgeProximity() {
    final RenderBox? parentRenderBox =
        widget.parentKey.currentContext?.findRenderObject() as RenderBox?;

    if (parentRenderBox == null) return;

    final Size parentSize = parentRenderBox.size;

    setState(() {
      _isNearLeftEdge = _position.dx < _edgeThreshold;
      _isNearRightEdge = (_position.dx + widget.maxChildWidth) >
          (parentSize.width - _edgeThreshold);
    });
  }

  void _updatePosition(PointerMoveEvent pointerMoveEvent) {
    if (widget.preventDragging) return;

    setState(() {
      _isDragging = true;
    });

    double newX = _position.dx + pointerMoveEvent.delta.dx;
    double newY = _position.dy + pointerMoveEvent.delta.dy;

    // Giới hạn trong boundaries với dynamic width consideration
    if (_maxPosition.dx != double.infinity &&
        _maxPosition.dy != double.infinity) {
      final RenderBox? parentRenderBox =
          widget.parentKey.currentContext?.findRenderObject() as RenderBox?;

      if (parentRenderBox != null) {
        final Size parentSize = parentRenderBox.size;

        // Dynamic max X based on current expansion state
        double dynamicMaxX = parentSize.width -
            (_isNearLeftEdge ? widget.maxChildWidth : _currentChildWidth);

        newX = newX.clamp(_minPosition.dx, dynamicMaxX);
        newY = newY.clamp(_minPosition.dy + 50, _maxPosition.dy);
      }
    }

    setState(() {
      _position = Offset(newX, newY);
    });

    _checkEdgeProximity();
    widget.onPositionChanged(_position);
  }

  void _snapToSide() {
    if (widget.preventDragging) return;

    final RenderBox? parentRenderBox =
        widget.parentKey.currentContext?.findRenderObject() as RenderBox?;

    if (parentRenderBox == null) return;

    final Size parentSize = parentRenderBox.size;
    final double centerX = parentSize.width / 2;

    double targetX;
    if (_position.dx + (_currentChildWidth / 2) > centerX) {
      // Snap to right với consideration cho expanded width
      targetX = parentSize.width -
          (_isNearRightEdge ? _currentChildWidth : widget.maxChildWidth);
    } else {
      // Snap to left
      targetX = _minPosition.dx;
    }

    // Ensure target is within bounds
    targetX =
        targetX.clamp(_minPosition.dx, parentSize.width - _currentChildWidth);

    final Offset targetPosition = Offset(targetX, _position.dy);

    _animation = Tween<Offset>(
      begin: _position,
      end: targetPosition,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _animation.addListener(() {
      setState(() {
        _position = _animation.value;
      });

      _checkEdgeProximity();
      widget.onPositionChanged(_position);
    });

    _animationController.reset();
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _position.dx,
      top: _position.dy,
      child: Listener(
        onPointerDown: (event) {
          setState(() {
            _isDragging = true;
          });
        },
        onPointerMove: _updatePosition,
        onPointerUp: (PointerUpEvent pointerUpEvent) {
          if (_isDragging) {
            setState(() {
              _isDragging = false;
            });
            _snapToSide();
          }
        },
        child: Container(
          key: _key,
          child: (widget.child == null)
              ? AnimatedFloatingSearchButton(
                onTap: () async {
                  final navContext =
                      CustomNavigator.navigatorKey.currentContext;
                  if (navContext != null && mounted) {
                    DraggableStackService().updateIsShowDraggableStack(false);
                    showDialog(
                      context: navContext,
                      barrierDismissible: false,
                      barrierColor: Colors.transparent,
                      builder: (context) => const ChatOverlayScreen(),
                    );
                  }
                },
              )
              : widget.child,
        ),
      ),
    );
  }
}

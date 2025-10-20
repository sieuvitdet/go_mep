import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:go_mep_application/common/theme/app_colors.dart';
import 'package:go_mep_application/common/theme/app_dimens.dart';
import 'package:go_mep_application/common/utils/utility.dart';
import 'package:flutter/material.dart';

import '../widgets/widget.dart';
import 'custom_navigator.dart';

class PhotoViewScreen extends StatefulWidget {
  final List<CustomImageListModel> models;
  final int? initialIndex;

  const PhotoViewScreen({super.key, required this.models, this.initialIndex});

  @override
  PhotoViewScreenState createState() => PhotoViewScreenState();
}

class PhotoViewScreenState extends State<PhotoViewScreen>
    with SingleTickerProviderStateMixin {
  final TransformationController _controller = TransformationController();

  late TapDownDetails _details;

  late AnimationController _animationController;
  late Animation<Matrix4> _animation;

  bool _isZoom = false;

  late int _index;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300))
          ..addListener(() {
            _controller.value = _animation.value;
          });

    _index = widget.initialIndex ?? 0;

    _controller.addListener(() {
      bool isInteractive = _controller.value.storage[10] > 1;
      if (!_isZoom) {
        if (isInteractive) {
          setState(() {
            _isZoom = true;
          });
        }
      } else {
        if (!isInteractive) {
          setState(() {
            _isZoom = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  _doubleTap() {
    final position = _details.localPosition;

    final double scale = 3;
    final x = -position.dx * (scale - 1);
    final y = -position.dy * (scale - 1);
    final zoomed = Matrix4.identity()
      ..translate(x, y)
      ..scale(scale);
    final value = _controller.value.isIdentity() ? zoomed : Matrix4.identity();

    _animation = Matrix4Tween(begin: _controller.value, end: value).animate(
        CurveTween(curve: Curves.easeOut).animate(_animationController));

    _animationController.forward(from: 0);
  }

  Widget _buildButton(IconData icon, GestureTapCallback onTap) {
    return InkWell(
      child: Container(
          width: AppSizes.onTap,
          height: AppSizes.onTap,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSizes.onTap),
              color: AppColors.hint.withValues(alpha: 0.7)),
          alignment: Alignment.center,
          child: Icon(
            icon,
            color: AppColors.white,
          )),
      onTap: onTap,
    );
  }

  Widget _buildContainer(CustomImageListModel model) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        Positioned.fill(
            child: Center(
          child: Container(
              height: MediaQuery.of(context).size.height * 0.8,
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              child: GestureDetector(
                onDoubleTapDown: (details) => _details = details,
                onDoubleTap: _doubleTap,
                child: InteractiveViewer(
                  transformationController: _controller,
                  clipBehavior: Clip.none,
                  scaleEnabled: true,
                  panEnabled: true,
                  minScale: 1,
                  maxScale: 3,
                  child: model.file == null
                      ? CachedNetworkImage(
                          imageUrl: model.url ?? '',
                          placeholder: (context, url) => CustomPlaceholder(),
                          errorWidget: (context, url, error) =>
                              CustomPlaceholder(),
                          fit: BoxFit.contain,
                        )
                      : Image.memory(
                          model.file!,
                          fit: BoxFit.contain,
                        ),
                ),
              )),
        )),
        if (model.note != null || model.createdAt != null)
          Container(
            width: MediaQuery.of(context).size.width,
            decoration:
                BoxDecoration(color: AppColors.black.withValues(alpha: 0.5)),
            child: CustomListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(
                  top: AppSizes.regular,
                  left: AppSizes.regular,
                  right: AppSizes.regular,
                  bottom: 60.0),
              children: [
                if ((model.note ?? "").isNotEmpty)
                  CustomText(
                    text: model.note,
                    color: AppColors.white,
                  ),
                if (model.createdAt != null)
                  CustomText(
                    text: Utility.formatDate(model.createdAt),
                    color: AppColors.white,
                  )
              ],
            ),
          )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Swiper(
            index: _index,
            itemBuilder: (BuildContext context, int index) {
              return _buildContainer(widget.models[index]);
            },
            itemCount: widget.models.length,
            pagination: new SwiperPagination(
              builder: SwiperPagination.fraction,
            ),
            control: new SwiperControl(size: 0.0),
            loop: false,
            onIndexChanged: (index) {
              setState(() {
                _index = index;
              });
            },
          ),
          if (_isZoom) _buildContainer(widget.models[_index]),
          Container(
            alignment: Alignment.topRight,
            padding: EdgeInsets.only(top: 40.0, right: 20.0),
            child: _buildButton(
              Icons.close,
              () {
                CustomNavigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}

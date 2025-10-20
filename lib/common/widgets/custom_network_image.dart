part of widget;

class CustomNetworkImage extends StatelessWidget {
  final double? width;
  final double? height;
  final String? url;
  final BoxFit? fit;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final double? radius;
  final Color? borderColor;
  final Widget? placeholder;
  final bool isThumb;

  CustomNetworkImage(
      {this.width,
      this.height,
      this.url,
      this.fit,
      this.backgroundColor,
      this.radius,
      this.borderColor,
      this.placeholder,
      this.borderRadius,
      this.isThumb = true});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(radius ?? 0.0),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.white,
          border: borderColor == null ? null : Border.all(color: borderColor!),
          borderRadius: BorderRadius.circular(radius ?? 0.0),
        ),
        child: url == null
            ? (placeholder ?? CustomPlaceholder())
            : CustomCachedNetworkImage(
                imageUrl: url!,
                width: width,
                height: height,
                fit: fit ?? BoxFit.cover,
                loadingWidget: Transform(
                    alignment: FractionalOffset.center,
                    transform: Matrix4.identity()..scale(0.5, 0.5),
                    child: CupertinoActivityIndicator(
                      color: backgroundColor == null
                          ? (isThumb ? AppColors.black : AppColors.white)
                          : AppColors.black,
                    )),
                placeholder: placeholder ?? CustomPlaceholder(),
                isThumb: isThumb,
              ),
      ),
    );
  }
}

class CustomAvatar extends StatelessWidget {
  final String? url;
  final String? name;
  final double? size;
  final Color? borderColor;
  final GestureTapCallback? onTap;
  final TextStyle? styleName;
  final Color? backgroundColor;

  CustomAvatar(
      {this.url,
      this.name,
      this.size,
      this.borderColor,
      this.onTap,
      this.styleName,
      this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    List<String> names = (name ?? "").split(" ");
    names.remove("");
    String? placeholder;
    if (names.length == 1 && names[0].isNotEmpty) {
      placeholder = names[0][0];
    } else if (names.length > 1) {
      placeholder =
          "${names[names.length - 2][0]}${names[names.length - 1][0]}";
    }
    return InkWell(
      child: CustomNetworkImage(
        width: size,
        height: size,
        radius: size,
        borderColor: borderColor,
        url: url,
        fit: BoxFit.cover,
        placeholder: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  backgroundColor ?? AppColors.primary.withValues(alpha: 0.5)),
          padding: EdgeInsets.all(size! / 5),
          alignment: Alignment.center,
          child: AutoSizeText(
            (placeholder ?? "").trim().toUpperCase(),
            style: styleName ??
                TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: size! * 0.8),
            minFontSize: 1.0,
          ),
        ),
      ),
      onTap: onTap,
    );
  }
}

class CustomCachedNetworkImage extends StatefulWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget placeholder;
  final Widget loadingWidget;
  final bool isThumb;
  final int maxCacheSize;
  final int minCacheSize;

  const CustomCachedNetworkImage({
    super.key,
    required this.imageUrl,
    required this.placeholder,
    required this.loadingWidget,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.isThumb = true,
    this.maxCacheSize = 800,
    this.minCacheSize = 200,
  });

  @override
  _CustomCachedNetworkImageState createState() =>
      _CustomCachedNetworkImageState();
}

class _CustomCachedNetworkImageState extends State<CustomCachedNetworkImage> {
  bool _isLoading = true;
  Uint8List? _image;
  late String _url;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _url = widget.imageUrl;
    _loadImage();
  }

  @override
  void didUpdateWidget(covariant CustomCachedNetworkImage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      _url = widget.imageUrl;
      _loadImage();
    } else {
      if (!_isLoading && _image == null) {
        _loadImage();
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  _loadImageFailed() {
    _isLoading = false;
    _image = null;
    setState(() {});
  }

  _loadImageSuccess(Uint8List image) {
    _isLoading = false;
    _image = image;
    setState(() {});
  }

  _loadImage() async {
    if (kIsWeb) {
      setState(() {});
      return;
    }
    setState(() {
      _isLoading = true;
      _image = null;
    });
    try {
      final paths = await _getPath(_url);
      if (paths.$1 == null || paths.$2 == null) {
        _loadImageFailed();
        return;
      }

      final originalPath = paths.$1!;
      final thumbnailPath = paths.$2!;

      String cachePath;
      int size;

      if (widget.isThumb) {
        cachePath = thumbnailPath;
        size = widget.minCacheSize;
      } else {
        cachePath = originalPath;
        size = widget.maxCacheSize;
      }

      final file = File(cachePath);
      if (await file.exists()) {
        _loadImageSuccess(await file.readAsBytes());
        return;
      }

      final bytes = await _downloadImage();
      if (bytes == null) {
        _loadImageFailed();
        return;
      }

      final compressedBytes = await _compressImage(bytes, size, cachePath);
      await file.create(recursive: true);
      await file.writeAsBytes(compressedBytes);
      _loadImageSuccess(compressedBytes);
    } catch (e) {
      _loadImageFailed();
    }
  }

  Future<(String?, String?)> _getPath(String url) async {
    final String _folderName = 'custom_cached_network_image';
    final String _thumbnailSuffix = '_thumbnail';
    String fileName = url.split('/').last;
    if (fileName.trim().isEmpty) {
      return (null, null);
    }
    String extension = fileName.split('.').last;
    fileName = fileName.replaceAll('.$extension', '');

    if (extension.isEmpty || fileName.isEmpty) {
      return (null, null);
    }

    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/$_folderName';
    final originalPath = '$path/$fileName.$extension';
    final thumbnailPath = '$path/$fileName$_thumbnailSuffix.$extension';

    return (originalPath, thumbnailPath);
  }

  Future<Uint8List?> _downloadImage() async {
    final response = await http.get(Uri.parse(_url));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    }
    return null;
  }

  Future<Uint8List> _compressImage(Uint8List bytes, int size, String path) {
    String extension = path.split(".").last;
    return FlutterImageCompress.compressWithList(bytes,
        minWidth: size,
        minHeight: size,
        quality: 50,
        format: extension == "png" ? CompressFormat.png : CompressFormat.jpeg);
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Image.network(
        _url,
        fit: widget.fit,
        width: widget.width,
        height: widget.height,
        loadingBuilder: (_, __, ___) => widget.loadingWidget,
        errorBuilder: (_, __, ___) => widget.placeholder,
      );
    }

    Widget child;
    if (_isLoading) {
      child = widget.loadingWidget;
    } else if (_image == null) {
      child = widget.placeholder;
    } else {
      child = Image.memory(
        _image!,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
      );
    }

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Center(
        child: child,
      ),
    );
  }
}

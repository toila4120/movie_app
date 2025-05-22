part of '../widget.dart';

class ProgressiveImage extends StatefulWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;
  final Duration fadeInDuration;
  final Duration fadeOutDuration;
  final int? memCacheWidth;
  final int? memCacheHeight;
  final int? maxWidthDiskCache;
  final int? maxHeightDiskCache;
  final double lowQualityRatio;
  final Duration? minimumLoadingTime;
  final bool forceHighQuality;
  final bool useHighQualityCache;
  final FilterQuality filterQuality;
  final bool useMemoryCache;

  const ProgressiveImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
    this.fadeInDuration = const Duration(milliseconds: 300),
    this.fadeOutDuration = const Duration(milliseconds: 200),
    this.memCacheWidth,
    this.memCacheHeight,
    this.maxWidthDiskCache,
    this.maxHeightDiskCache,
    this.lowQualityRatio = 0.5,
    this.minimumLoadingTime,
    this.forceHighQuality = false,
    this.useHighQualityCache = true,
    this.filterQuality = FilterQuality.high,
    this.useMemoryCache = true,
  });

  @override
  State<ProgressiveImage> createState() => _ProgressiveImageState();
}

class _ProgressiveImageState extends State<ProgressiveImage> {
  final bool _isLoading = true;
  bool _hasError = false;
  bool _highQualityLoaded = false;
  ImageProvider? _highQualityImage;
  DateTime? _startLoadingTime;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _startLoadingTime = DateTime.now();
    _preloadHighQualityImage();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void _preloadHighQualityImage() {
    if (widget.forceHighQuality) {
      _loadHighQualityImage();
    } else {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!_isDisposed && mounted) {
          _loadHighQualityImage();
        }
      });
    }
  }

  void _loadHighQualityImage() {
    if (_isDisposed) return;

    final imageProvider = CachedNetworkImageProvider(
      widget.imageUrl,
      maxWidth: widget.memCacheWidth,
      maxHeight: widget.memCacheHeight,
      cacheKey: widget.useHighQualityCache
          ? '${widget.imageUrl}_high'
          : widget.imageUrl,
    );

    imageProvider.resolve(const ImageConfiguration()).addListener(
          ImageStreamListener(
            (ImageInfo info, bool _) {
              if (!_isDisposed && mounted) {
                final now = DateTime.now();
                final elapsed = now.difference(_startLoadingTime!);

                if (widget.minimumLoadingTime != null &&
                    elapsed < widget.minimumLoadingTime!) {
                  Future.delayed(
                    widget.minimumLoadingTime! - elapsed,
                    () {
                      if (!_isDisposed && mounted) {
                        setState(() {
                          _highQualityImage = imageProvider;
                          _highQualityLoaded = true;
                        });
                      }
                    },
                  );
                } else {
                  setState(() {
                    _highQualityImage = imageProvider;
                    _highQualityLoaded = true;
                  });
                }
              }
            },
            onError: (dynamic exception, StackTrace? stackTrace) {
              if (!_isDisposed && mounted) {
                setState(() {
                  _hasError = true;
                });
              }
            },
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: widget.borderRadius ?? BorderRadius.zero,
      child: Stack(
        children: [
          // Low quality image
          if (_isLoading && !_highQualityLoaded)
            CachedNetworkImage(
              imageUrl: widget.imageUrl,
              width: widget.width,
              height: widget.height,
              fit: widget.fit,
              memCacheWidth:
                  ((widget.memCacheWidth ?? 0) * widget.lowQualityRatio)
                      .toInt(),
              memCacheHeight:
                  ((widget.memCacheHeight ?? 0) * widget.lowQualityRatio)
                      .toInt(),
              maxWidthDiskCache:
                  ((widget.maxWidthDiskCache ?? 0) * widget.lowQualityRatio)
                      .toInt(),
              maxHeightDiskCache:
                  ((widget.maxHeightDiskCache ?? 0) * widget.lowQualityRatio)
                      .toInt(),
              fadeInDuration: widget.fadeInDuration,
              fadeOutDuration: widget.fadeOutDuration,
              cacheKey: '${widget.imageUrl}_low',
              placeholder: (context, url) =>
                  widget.placeholder ??
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      width: widget.width,
                      height: widget.height,
                      color: Colors.grey.shade300,
                    ),
                  ),
              errorWidget: (context, url, error) {
                if (!_isDisposed && mounted) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    setState(() {
                      _hasError = true;
                    });
                  });
                }
                return widget.errorWidget ??
                    Container(
                      width: widget.width,
                      height: widget.height,
                      color: Colors.grey.shade300,
                      child: const Center(
                        child: Icon(
                          Icons.broken_image,
                          color: Colors.grey,
                          size: 40,
                        ),
                      ),
                    );
              },
            ),

          // High quality image
          if (!_hasError && _highQualityImage != null)
            AnimatedSwitcher(
              duration: widget.fadeInDuration,
              child: CachedNetworkImage(
                imageUrl: widget.imageUrl,
                width: widget.width,
                height: widget.height,
                fit: widget.fit,
                fadeInDuration: widget.fadeInDuration,
                fadeOutDuration: widget.fadeOutDuration,
                cacheKey: widget.useHighQualityCache
                    ? '${widget.imageUrl}_high'
                    : widget.imageUrl,
                filterQuality: widget.filterQuality,
              ),
            ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:movie_app/config/theme/theme.dart';

class ScrollToTopButton extends StatefulWidget {
  final ScrollController scrollController;
  final double showOffsetThreshold;
  final Color? backgroundColor;
  final Duration animationDuration;
  final Curve animationCurve;

  const ScrollToTopButton({
    super.key,
    required this.scrollController,
    this.showOffsetThreshold = 100,
    this.backgroundColor,
    this.animationDuration = const Duration(milliseconds: 500),
    this.animationCurve = Curves.easeInOut,
  });

  @override
  State<ScrollToTopButton> createState() => _ScrollToTopButtonState();
}

class _ScrollToTopButtonState extends State<ScrollToTopButton> {
  bool _showButton = false;

  @override
  void initState() {
    super.initState();
    _setupScrollListener();
  }

  void _setupScrollListener() {
    widget.scrollController.addListener(() {
      if (widget.scrollController.offset >= widget.showOffsetThreshold) {
        if (!_showButton) {
          setState(() => _showButton = true);
        }
      } else {
        if (_showButton) {
          setState(() => _showButton = false);
        }
      }
    });
  }

  void _scrollToTop() {
    widget.scrollController.animateTo(
      0,
      duration: widget.animationDuration,
      curve: widget.animationCurve,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_showButton) {
      return const SizedBox.shrink();
    }

    return Positioned(
      bottom: 20,
      right: 20,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
        ),
        height: 40,
        width: 40,
        child: FloatingActionButton(
          mini: true,
          onPressed: _scrollToTop,
          backgroundColor: AppColor.primary500,
          shape: const CircleBorder(),
          child: const Icon(
            Icons.arrow_upward,
            color: AppColor.white,
            size: 20,
          ),
        ),
      ),
    );
  }
}

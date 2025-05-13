import 'package:flutter/material.dart';
import 'package:movie_app/core/widget/src/scroll_to_top_button.dart';

class BaseScrollView extends StatefulWidget {
  final Widget child;
  final bool showScrollToTopButton;
  final double scrollToTopThreshold;
  final Color? scrollToTopButtonColor;
  final RefreshCallback? onRefresh;
  final ScrollPhysics? physics;

  const BaseScrollView({
    super.key,
    required this.child,
    this.showScrollToTopButton = true,
    this.scrollToTopThreshold = 100,
    this.scrollToTopButtonColor,
    this.onRefresh,
    this.physics,
  });

  @override
  State<BaseScrollView> createState() => _BaseScrollViewState();
}

class _BaseScrollViewState extends State<BaseScrollView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget scrollView = SingleChildScrollView(
      controller: _scrollController,
      physics: widget.physics ?? const AlwaysScrollableScrollPhysics(),
      child: widget.child,
    );

    if (widget.onRefresh != null) {
      scrollView = RefreshIndicator(
        onRefresh: widget.onRefresh!,
        child: scrollView,
      );
    }

    return Stack(
      children: [
        scrollView,
        if (widget.showScrollToTopButton)
          ScrollToTopButton(
            scrollController: _scrollController,
            showOffsetThreshold: widget.scrollToTopThreshold,
          ),
      ],
    );
  }
}

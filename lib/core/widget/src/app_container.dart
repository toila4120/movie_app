part of '../widget.dart';

class AppContainer extends StatelessWidget {
  const AppContainer({
    super.key,
    this.appBar,
    this.drawer,
    this.bottomNavigationBar,
    this.child,
    this.backgroundColor,
    this.coverScreenWidget,
    this.resizeToAvoidBottomInset = false,
    this.floatingActionButton,
    this.alignmentStack,
  });

  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? child;
  final Color? backgroundColor;
  final Widget? coverScreenWidget;
  final bool? resizeToAvoidBottomInset;
  final Widget? floatingActionButton;
  final Widget? drawer;
  final AlignmentGeometry? alignmentStack;

  @override
  Widget build(BuildContext context) {
    // Ẩn thanh trạng thái
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    return Stack(
      alignment: alignmentStack ?? AlignmentDirectional.topStart,
      children: [
        GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Scaffold(
            appBar: appBar,
            drawer: drawer,
            resizeToAvoidBottomInset: resizeToAvoidBottomInset,
            extendBodyBehindAppBar: true,
            body: SafeArea(
              top: false,
              child: Container(
                decoration: BoxDecoration(
                  color: backgroundColor ??
                      Theme.of(context).scaffoldBackgroundColor,
                  shape: BoxShape.rectangle,
                ),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom,
                  ),
                  child: child ?? const SizedBox.shrink(),
                ),
              ),
            ),
            floatingActionButton: floatingActionButton,
            bottomNavigationBar: bottomNavigationBar,
          ),
        ),
        coverScreenWidget == null
            ? const SizedBox.shrink()
            : coverScreenWidget!,
      ],
    );
  }
}

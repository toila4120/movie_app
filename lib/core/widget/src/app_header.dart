part of '../widget.dart';

class AppHeader extends StatelessWidget {
  final String? title;
  final String? hintContent;
  final String? hintTitle;
  final Widget? leftWidget;
  final Widget? rightWidget;
  final Widget? middleWidget;
  final Widget? extendWidget;
  final CrossAxisAlignment? crossAxisAlignmentMainRow;
  final TextStyle? titleStyle;
  final Color? backgroundColor;
  final Color? colorTitle;
  final Function()? onBackPress;

  const AppHeader({
    super.key,
    this.title,
    this.leftWidget,
    this.rightWidget,
    this.middleWidget,
    this.extendWidget,
    this.crossAxisAlignmentMainRow,
    this.hintContent,
    this.hintTitle,
    this.titleStyle,
    this.backgroundColor,
    this.colorTitle,
    this.onBackPress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Theme.of(context).primaryColor,
      decoration: BoxDecoration(
          color: backgroundColor ?? Theme.of(context).primaryColor,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColorDark.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 0),
            ),
          ]),
      child: Column(
        children: [
          Padding(
            padding: headerPadding(context),
            child: Row(
              crossAxisAlignment:
                  crossAxisAlignmentMainRow ?? CrossAxisAlignment.center,
              children: [
                leftWidget ?? const BackWidget(),
                Expanded(
                  child: middleWidget ??
                      Text(
                        title ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ).merge(
                          titleStyle,
                        ),
                      ),
                ),
                rightWidget ?? SizedBox(width: 24.0.w),
              ],
            ),
          ),
          extendWidget ?? const SizedBox.shrink(),
        ],
      ),
    );
  }
}

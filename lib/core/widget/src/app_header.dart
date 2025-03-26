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
  final Color backgroundColor;
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
    this.backgroundColor = Colors.white,
    this.colorTitle,
    this.onBackPress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
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
                          fontSize: SizeConfig.getResponsive(16),
                          fontWeight: FontWeight.w500,
                          color: colorTitle ?? AppColor.secondLight,
                        ).merge(
                          titleStyle,
                        ),
                      ),
                ),
                rightWidget ??
                    SizedBox(
                      width: SizeConfig.getResponsive(24.0),
                    ),
              ],
            ),
          ),
          extendWidget ?? const SizedBox.shrink(),
        ],
      ),
    );
  }
}

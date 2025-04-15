part of '../widget.dart';

class BackWidget extends StatelessWidget {
  final Widget? iconBack;
  final Color? color;

  const BackWidget({
    super.key,
    this.iconBack,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CustomAppButton(
      width: 32.w,
      height: 32.w,
      onPressed: () {
        finish(context);
      },
      padding: const EdgeInsets.all(8),
      child: Image.asset(
        AppImage.icBack,
        color: Theme.of(context).primaryColorDark,
      ),
    );
  }
}

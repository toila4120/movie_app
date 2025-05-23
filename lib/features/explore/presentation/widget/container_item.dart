part of '../../explore.dart';

class ContainerItem extends StatelessWidget {
  final String title;
  final String genreSlug;
  final bool isSelected;
  final Function(String) onTap;
  const ContainerItem({
    super.key,
    required this.title,
    required this.genreSlug,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(genreSlug),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppPadding.medium,
          vertical: AppPadding.superTiny,
        ),
        decoration: BoxDecoration(
          color:
              isSelected ? AppColor.primary500 : Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(AppBorderRadius.r16.w),
          border: Border.all(
            color: AppColor.primary500,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: isSelected
                  ? AppColor.white
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

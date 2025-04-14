part of '../widget.dart';

class ContainerGenre extends StatelessWidget {
  final String title;
  final String genreSlug;
  final bool isSelected;
  final Function(String) onTap;

  const ContainerGenre({
    super.key,
    required this.title,
    required this.isSelected,
    required this.genreSlug,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(genreSlug),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppPadding.medium,
          vertical: AppPadding.small,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.primary500 : AppColor.white,
          borderRadius: BorderRadius.circular(AppPadding.medium),
          border: Border.all(
            color: AppColor.primary500,
            width: 2,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: isSelected ? AppColor.white : AppColor.primary500,
          ),
        ),
      ),
    );
  }
}

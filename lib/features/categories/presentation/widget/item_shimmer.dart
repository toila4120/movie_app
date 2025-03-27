part of '../../categories.dart';

class ItemShimmer extends StatelessWidget {
  const ItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: AppColor.white,
          border: Border.all(
            color: AppColor.greyScale200,
          ),
          borderRadius: BorderRadius.circular(AppBorderRadius.r8),
        ),
        padding: EdgeInsets.symmetric(
          vertical: AppPadding.small,
          horizontal: AppPadding.small,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Title',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            Image.asset(
              AppImage.icRight,
              width: 16.w,
              height: 16.w,
            ),
          ],
        ),
      ),
    );
  }
}

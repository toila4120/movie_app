part of '../../explore.dart';

class ItemListMovieShimmer extends StatelessWidget {
  const ItemListMovieShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildShimmerItem(),
        ),
        SizedBox(width: AppPadding.small),
        Expanded(
          child: _buildShimmerItem(),
        ),
        SizedBox(width: AppPadding.small),
        Expanded(
          child: _buildShimmerItem(),
        ),
      ],
    );
  }

  Widget _buildShimmerItem() {
    return Container(
      padding: EdgeInsets.all(AppPadding.small),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppBorderRadius.r16),
        color: AppColor.white,
        border: Border.all(
          color: AppColor.greyScale200,
        ),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          height: 148.w,
          color: Colors.grey.shade300,
        ),
      ),
    );
  }
}

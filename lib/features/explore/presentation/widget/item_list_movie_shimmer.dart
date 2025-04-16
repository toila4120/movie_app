part of '../../explore.dart';

class ItemListMovieShimmer extends StatelessWidget {
  const ItemListMovieShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: AppPadding.small,
        mainAxisSpacing: AppPadding.small,
        childAspectRatio: 0.7,
      ),
      itemCount: 18,
      itemBuilder: (context, index) {
        return _buildShimmerItem(context);
      },
    );
  }

  Widget _buildShimmerItem(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppPadding.small),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppBorderRadius.r16),
        color: Theme.of(context).primaryColorLight,
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

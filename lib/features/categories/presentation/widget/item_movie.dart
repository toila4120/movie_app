part of '../../categories.dart';

class ItemMovie extends StatelessWidget {
  final MovieModel movieModel;
  const ItemMovie({
    super.key,
    required this.movieModel,
  });

  @override
  Widget build(BuildContext context) {
    return CustomAppButton(
      onPressed: () {
        context.push(AppRouter.movieDetailPath, extra: {
          'movie': movieModel,
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppPadding.tiny,
          vertical: AppPadding.tiny,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppBorderRadius.r16),
          color: AppColor.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppBorderRadius.r16),
                    child: CachedNetworkImage(
                      imageUrl: 'https://phimimg.com/${movieModel.posterUrl}',
                      width: 120.w,
                      height: 144.w,
                      fit: BoxFit.fill,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          width: 120.w,
                          height: 88.w,
                          color: Colors.grey.shade300,
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 120.w,
                        height: 88.w,
                        color: Colors.grey.shade300,
                        child: const Center(
                          child: Icon(
                            Icons.broken_image,
                            color: Colors.grey,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: AppPadding.medium),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movieModel.name,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColor.greyScale900,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: AppPadding.superTiny),
                        Text(
                          movieModel.episodeCurrent,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColor.greyScale500,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: AppPadding.superTiny),
                        Text(
                          movieModel.lang,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColor.greyScale500,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: AppPadding.tiny),
            Image.asset(
              AppImage.icRight,
              width: 16.w,
              height: 16.w,
              color: AppColor.greyScale900,
            ),
          ],
        ),
      ),
    );
  }
}

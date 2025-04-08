part of '../../home.dart';

class Popular extends StatelessWidget {
  const Popular({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    'Phim nổi bật',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppColor.greyScale900,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                CustomAppButton(
                  text: "Xem tất cả",
                  textStyle: TextStyle(
                    fontSize: 12.sp,
                    color: AppColor.primary500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppPadding.tiny),
            SizedBox(
              height: 164.w,
              child: ListView.builder(
                itemCount: state.bannerMovies.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Container(
                    padding: index == 0
                        ? EdgeInsets.only(
                            right: AppPadding.superTiny,
                          )
                        : EdgeInsets.symmetric(
                            horizontal: AppPadding.superTiny,
                          ),
                    child: _ItemFilmPopular(
                      movieForBannerEntity: state.bannerMovies[index],
                    ),
                  );
                },
              ),
            )
          ],
        );
      },
    );
  }
}

class _ItemFilmPopular extends StatelessWidget {
  final MovieForBannerEntity movieForBannerEntity;
  const _ItemFilmPopular({
    required this.movieForBannerEntity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppBorderRadius.r8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppBorderRadius.r8),
        child: CachedNetworkImage(
          imageUrl: movieForBannerEntity.posterUrl,
          height: 164.w,
          width: 120.w,
          fit: BoxFit.fill,
          placeholder: (context, url) => Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 164.w,
              width: 120.w,
              color: Colors.grey.shade300,
            ),
          ),
          errorWidget: (context, url, error) => Container(
            height: 164.w,
            width: 120.w,
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
    );
  }
}

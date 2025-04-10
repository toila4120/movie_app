part of '../../home.dart';

class BannerHome extends StatefulWidget {
  const BannerHome({super.key});

  @override
  State<BannerHome> createState() => _BannerHomeState();
}

class _BannerHomeState extends State<BannerHome> {
  int _currentIndex = 0;
  final int _itemCount = 5;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: CarouselSlider.builder(
                    itemCount: _itemCount,
                    itemBuilder: (
                      BuildContext context,
                      int itemIndex,
                      int pageViewIndex,
                    ) {
                      final banner = state.bannerMovies[itemIndex];
                      return Stack(
                        children: [
                          state.loadingState.isPure
                              ? Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.grey.shade100,
                                  child: Container(
                                    height: double.infinity,
                                    width: double.infinity,
                                    color: Colors.grey.shade300,
                                  ),
                                )
                              : CachedNetworkImage(
                                  imageUrl: banner.thumbUrl,
                                  height: double.infinity,
                                  width: double.infinity,
                                  fit: BoxFit.fill,
                                  placeholder: (context, url) =>
                                      Shimmer.fromColors(
                                    baseColor: Colors.grey.shade300,
                                    highlightColor: Colors.grey.shade100,
                                    child: Container(
                                      height: double.infinity,
                                      width: double.infinity,
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                    height: double.infinity,
                                    width: double.infinity,
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
                          Positioned(
                            bottom: 0,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.symmetric(
                                horizontal: AppPadding.large,
                                vertical: AppPadding.small,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.7),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          banner.name,
                                          style: TextStyle(
                                            color: AppColor.white,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              banner.year.toString(),
                                              style: TextStyle(
                                                color: AppColor.white,
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.symmetric(
                                                horizontal:
                                                    AppPadding.superTiny,
                                              ),
                                              height: 4.w,
                                              width: 4.w,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        AppPadding.superTiny),
                                                color: AppColor.white,
                                              ),
                                            ),
                                            Text(
                                              banner.category
                                                  .take(3)
                                                  .map((countries) =>
                                                      countries.name)
                                                  .join(", "),
                                              style: TextStyle(
                                                color: AppColor.white,
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.symmetric(
                                                horizontal:
                                                    AppPadding.superTiny,
                                              ),
                                              height: 4.sp,
                                              width: 4.sp,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        AppPadding.superTiny),
                                                color: AppColor.white,
                                              ),
                                            ),
                                            Flexible(
                                              child: Text(
                                                banner.episodeCurrent,
                                                style: TextStyle(
                                                  color: AppColor.white,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: AppPadding.small),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: AppPadding.small),
                                  CustomAppButton(
                                    onPressed: () {
                                      context.read<MovieBloc>().add(
                                            FetchMovieDetailEvent(
                                              slug: banner.slug,
                                            ),
                                          );
                                      context.push(
                                        AppRouter.movieDetailPath,
                                      );
                                    },
                                    child: CircleAvatar(
                                      radius: 18.w,
                                      backgroundImage:
                                          const AssetImage(AppImage.icPlay),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    options: CarouselOptions(
                      height: MediaQuery.of(context).size.height * 0.3,
                      viewportFraction: 1,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 5),
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      enlargeFactor: 0,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                ),
                Positioned(
                  bottom: AppPadding.tiny,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _itemCount,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: _currentIndex == index ? 24.w : 8.w,
                        height: 8.w,
                        decoration: BoxDecoration(
                          color: _currentIndex == index
                              ? null
                              : AppColor.greyScale700,
                          gradient: _currentIndex == index
                              ? const LinearGradient(
                                  colors: [
                                    AppColor.primary500,
                                    AppColor.primary500,
                                  ],
                                  begin: AlignmentDirectional.centerStart,
                                  end: AlignmentDirectional.centerEnd,
                                )
                              : null,
                          borderRadius:
                              BorderRadius.circular(AppBorderRadius.r12),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

part of '../../home.dart';

class BannerHome extends StatefulWidget {
  const BannerHome({super.key});

  @override
  State<BannerHome> createState() => _BannerHomeState();
}

class _BannerHomeState extends State<BannerHome> {
  int _currentIndex = 0;

  // Danh sách dữ liệu động cho banner
  final List<Map<String, dynamic>> _banners = [
    {
      'image': AppImage.bannerDefault,
      'title': 'Cruella',
      'year': '2021',
      'genres': 'Fantasy, Drama',
      'episodes': '12 Episode',
    },
    {
      'image': AppImage.bannerDefault,
      'title': 'The Witcher',
      'year': '2019',
      'genres': 'Action, Fantasy',
      'episodes': '8 Episode',
    },
    {
      'image': AppImage.bannerDefault,
      'title': 'Stranger Things',
      'year': '2016',
      'genres': 'Horror, Sci-Fi',
      'episodes': '9 Episode',
    },
    {
      'image': AppImage.bannerDefault,
      'title': 'Loki',
      'year': '2021',
      'genres': 'Action, Sci-Fi',
      'episodes': '6 Episode',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;
        final orientation = MediaQuery.of(context).orientation;

        double carouselHeight = screenWidth > 800
            ? screenHeight * 0.5
            : orientation == Orientation.portrait
                ? screenHeight * 0.3
                : screenHeight * 0.4;

        double titleFontSize = screenWidth > 800 ? 28 : 20;
        double infoFontSize = screenWidth > 800 ? 16 : 12;

        double horizontalPadding =
            screenWidth > 800 ? AppPadding.superLarge : AppPadding.large;
        double verticalPadding =
            screenWidth > 800 ? AppPadding.small : AppPadding.tiny;

        double dotWidthActive = screenWidth > 800 ? 32 : 24;
        double dotWidthInactive = screenWidth > 800 ? 12 : 8;
        double dotHeight = screenWidth > 800 ? 12 : 8;

        return Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: carouselHeight,
              child: CarouselSlider.builder(
                itemCount: _banners.length,
                itemBuilder: (
                  BuildContext context,
                  int itemIndex,
                  int pageViewIndex,
                ) {
                  final banner = _banners[itemIndex];
                  return Stack(
                    children: [
                      Image.asset(
                        banner['image'],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          width: screenWidth,
                          padding: EdgeInsets.symmetric(
                            horizontal: horizontalPadding,
                            vertical: verticalPadding,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.7),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    banner['title'],
                                    style: TextStyle(
                                      color: AppColor.white,
                                      fontSize: titleFontSize,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        banner['year'],
                                        style: TextStyle(
                                          color: AppColor.white,
                                          fontSize: infoFontSize,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                          horizontal: AppPadding.superTiny,
                                        ),
                                        height: SizeConfig.getResponsive(4),
                                        width: SizeConfig.getResponsive(4),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            AppPadding.superTiny,
                                          ),
                                          color: AppColor.white,
                                        ),
                                      ),
                                      Text(
                                        banner['genres'],
                                        style: TextStyle(
                                          color: AppColor.white,
                                          fontSize: infoFontSize,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                          horizontal: AppPadding.superTiny,
                                        ),
                                        height: SizeConfig.getResponsive(4),
                                        width: SizeConfig.getResponsive(4),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              AppPadding.superTiny),
                                          color: AppColor.white,
                                        ),
                                      ),
                                      Text(
                                        banner['episodes'],
                                        style: TextStyle(
                                          color: AppColor.white,
                                          fontSize: infoFontSize,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: AppPadding.small),
                                ],
                              ),
                              CustomAppButton(
                                onPressed: () {
                                  context.push(AppRouter.movieDetailPath);
                                },
                                child: CircleAvatar(
                                  radius: screenWidth > 800 ? 30 : 20,
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
                  height: carouselHeight,
                  viewportFraction: 1,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 5),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
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
                  _banners.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: _currentIndex == index
                        ? dotWidthActive
                        : dotWidthInactive,
                    height: dotHeight,
                    decoration: BoxDecoration(
                      color:
                          _currentIndex == index ? null : AppColor.greyScale700,
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
                      borderRadius: BorderRadius.circular(AppBorderRadius.r12),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

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
        return Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.4,
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
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(
                            horizontal: AppPadding.large,
                            vertical: AppPadding.large,
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
                                      fontSize: SizeConfig.getResponsive(14),
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
                                          fontSize:
                                              SizeConfig.getResponsive(12),
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
                                          fontSize:
                                              SizeConfig.getResponsive(12),
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
                                          fontSize:
                                              SizeConfig.getResponsive(12),
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
                                  radius: SizeConfig.getResponsive(20),
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
                  height: MediaQuery.of(context).size.height * 0.4,
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
                        ? SizeConfig.getResponsive(24)
                        : SizeConfig.getResponsive(8),
                    height: SizeConfig.getResponsive(8),
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

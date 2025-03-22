part of '../../home.dart';

class BannerHome extends StatefulWidget {
  const BannerHome({super.key});

  @override
  State<BannerHome> createState() => _BannerHomeState();
}

class _BannerHomeState extends State<BannerHome> {
  int _currentIndex = 0;

  final List<String> _images = [
    AppImage.bannerDefault,
    AppImage.bannerDefault,
    AppImage.bannerDefault,
    AppImage.bannerDefault,
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CarouselSlider.builder(
          itemCount: _images.length,
          itemBuilder: (
            BuildContext context,
            int itemIndex,
            int pageViewIndex,
          ) {
            return Stack(
              children: [
                Image.asset(
                  _images[itemIndex],
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppPadding.large,
                      vertical: AppPadding.tiny,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Cruella",
                              style: TextStyle(
                                color: AppColor.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text(
                                  "2021",
                                  style: TextStyle(
                                    color: AppColor.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: AppPadding.superTiny,
                                  ),
                                  height: 4,
                                  width: 4,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        AppPadding.superTiny),
                                    color: AppColor.white,
                                  ),
                                ),
                                const Text(
                                  "Fantasy, Drama",
                                  style: TextStyle(
                                    color: AppColor.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: AppPadding.superTiny,
                                  ),
                                  height: 4,
                                  width: 4,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        AppPadding.superTiny),
                                    color: AppColor.white,
                                  ),
                                ),
                                const Text(
                                  "12 Episode",
                                  style: TextStyle(
                                    color: AppColor.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppPadding.small)
                          ],
                        ),
                        CustomAppButton(
                          onPressed: () {
                            context.push(AppRouter.movieDetailPath);
                          },
                          child: const CircleAvatar(
                            radius: 20,
                            backgroundImage: AssetImage(AppImage.icPlay),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            );
          },
          options: CarouselOptions(
            aspectRatio: 16 / 9,
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
        Positioned(
          bottom: AppPadding.tiny,
          left: AppPadding.large,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _images.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: _currentIndex == index ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentIndex == index ? null : AppColor.greyScale700,
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
        )
      ],
    );
  }
}

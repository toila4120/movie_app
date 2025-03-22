part of '../../movie.dart';

class HeaderMovieDetail extends StatelessWidget {
  const HeaderMovieDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          AppImage.posterMovie,
          fit: BoxFit.cover,
          height: MediaQuery.of(context).size.height * 0.6,
          width: double.infinity,
        ),
        Positioned(
          top: AppPadding.tiny + MediaQuery.of(context).padding.top,
          left: AppPadding.large,
          right: AppPadding.large,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomAppButton(
                onPressed: () {
                  context.pop();
                },
                child: Image.asset(
                  AppImage.icBack1,
                  width: 40,
                  height: 40,
                ),
              ),
              CustomAppButton(
                onPressed: () {
                  context.pop();
                },
                child: Image.asset(
                  AppImage.icHeart,
                  width: 40,
                  height: 40,
                ),
              ),
            ],
          ),
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
              gradient: LinearGradient(
                colors: [
                  AppColor.white,
                  AppColor.white.withOpacity(0.0),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CustomAppButton(
                  child: CircleAvatar(
                    radius: 24,
                    backgroundImage: AssetImage(AppImage.icPlay),
                  ),
                ),
                const SizedBox(height: AppPadding.medium),
                const Text(
                  "Cruella",
                  style: TextStyle(
                    color: AppColor.greyScale900,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppPadding.superTiny),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "2021",
                      style: TextStyle(
                        color: AppColor.greyScale500,
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
                        borderRadius:
                            BorderRadius.circular(AppPadding.superTiny),
                        color: AppColor.greyScale500,
                      ),
                    ),
                    const Text(
                      "Fantasy, Drama",
                      style: TextStyle(
                        color: AppColor.greyScale500,
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
                        borderRadius:
                            BorderRadius.circular(AppPadding.superTiny),
                        color: AppColor.greyScale500,
                      ),
                    ),
                    const Text(
                      "12 Episode",
                      style: TextStyle(
                        color: AppColor.greyScale500,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppPadding.superTiny),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      AppImage.icStar,
                      width: 12,
                      height: 12,
                    ),
                    const Text(
                      " 4.5",
                      style: TextStyle(
                        color: AppColor.greyScale900,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Text(
                      " (128 review)",
                      style: TextStyle(
                        color: AppColor.greyScale500,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

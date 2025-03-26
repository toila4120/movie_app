part of '../../movie.dart';

class HeaderMovieDetail extends StatelessWidget {
  const HeaderMovieDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          AppImage.posterMovie,
          fit: BoxFit.fill,
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
                  width: SizeConfig.getResponsive(40),
                  height: SizeConfig.getResponsive(40),
                ),
              ),
              CustomAppButton(
                onPressed: () {
                  context.pop();
                },
                child: Image.asset(
                  AppImage.icHeart,
                  width: SizeConfig.getResponsive(40),
                  height: SizeConfig.getResponsive(40),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(
              horizontal: AppPadding.large,
              vertical: AppPadding.tiny,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColor.white,
                  AppColor.white.withValues(alpha: 0.0),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomAppButton(
                  child: CircleAvatar(
                    radius: SizeConfig.getResponsive(24),
                    backgroundImage: const AssetImage(AppImage.icPlay),
                  ),
                ),
                SizedBox(height: AppPadding.tiny),
                Text(
                  "Cruella",
                  style: TextStyle(
                    color: AppColor.greyScale900,
                    fontSize: SizeConfig.getResponsive(24),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: AppPadding.superTiny),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "2021",
                      style: TextStyle(
                        color: AppColor.greyScale500,
                        fontSize: SizeConfig.getResponsive(12),
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
                        borderRadius:
                            BorderRadius.circular(AppPadding.superTiny),
                        color: AppColor.greyScale500,
                      ),
                    ),
                    Text(
                      "Fantasy, Drama",
                      style: TextStyle(
                        color: AppColor.greyScale500,
                        fontSize: SizeConfig.getResponsive(12),
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
                        borderRadius:
                            BorderRadius.circular(AppPadding.superTiny),
                        color: AppColor.greyScale500,
                      ),
                    ),
                    Text(
                      "12 Episode",
                      style: TextStyle(
                        color: AppColor.greyScale500,
                        fontSize: SizeConfig.getResponsive(12),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppPadding.superTiny),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      AppImage.icStar,
                      width: SizeConfig.getResponsive(12),
                      height: SizeConfig.getResponsive(12),
                    ),
                    Text(
                      " 4.5",
                      style: TextStyle(
                        color: AppColor.greyScale900,
                        fontSize: SizeConfig.getResponsive(12),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      " (128 review)",
                      style: TextStyle(
                        color: AppColor.greyScale500,
                        fontSize: SizeConfig.getResponsive(12),
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

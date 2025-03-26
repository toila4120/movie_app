part of '../../home.dart';

class ContinueWatching extends StatelessWidget {
  const ContinueWatching({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                'Continue Watching',
                style: TextStyle(
                  fontSize: SizeConfig.getResponsive(16),
                  color: AppColor.greyScale900,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            CustomAppButton(
              text: "See all list",
              textStyle: TextStyle(
                fontSize: SizeConfig.getResponsive(12),
                color: AppColor.primary500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: AppPadding.tiny),
        SizedBox(
          height: SizeConfig.getResponsive(120),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const ClampingScrollPhysics(),
            itemCount: 50,
            itemBuilder: (context, index) {
              return Padding(
                padding: index == 0
                    ? EdgeInsets.only(right: AppPadding.superTiny)
                    : EdgeInsets.symmetric(
                        horizontal: AppPadding.superTiny,
                      ),
                child: const _ItemFilmContinue(),
              );
            },
          ),
        )
      ],
    );
  }
}

class _ItemFilmContinue extends StatelessWidget {
  const _ItemFilmContinue();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppBorderRadius.r8),
          child: Image.asset(
            AppImage.bannerDefault,
            height: SizeConfig.getResponsive(120),
            width: SizeConfig.getResponsive(172),
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(AppBorderRadius.r8),
            ),
            padding: EdgeInsets.symmetric(
              vertical: AppPadding.superTiny,
              horizontal: AppPadding.tiny,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Nevertheless",
                          style: TextStyle(
                            fontSize: SizeConfig.getResponsive(14),
                            color: AppColor.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          "Episode 5 of 10",
                          style: TextStyle(
                            fontSize: SizeConfig.getResponsive(10),
                            color: AppColor.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    CustomAppButton(
                      child: Image.asset(
                        AppImage.icPlay1,
                        height: SizeConfig.getResponsive(18),
                        width: SizeConfig.getResponsive(18),
                      ),
                    )
                  ],
                ),
                SizedBox(height: AppPadding.tiny),
                LinearProgressIndicator(
                  minHeight: AppPadding.superTiny,
                  borderRadius: BorderRadius.circular(AppBorderRadius.r4),
                  value: 4 / 10,
                  backgroundColor: AppColor.white.withValues(alpha: 0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColor.primary500,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

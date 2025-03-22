part of '../../home.dart';

class ContinueWatching extends StatelessWidget {
  const ContinueWatching({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                'Continue Watching',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColor.greyScale900,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            CustomAppButton(
              text: "See all list",
              textStyle: TextStyle(
                fontSize: 12,
                color: AppColor.primary500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppPadding.tiny),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const ClampingScrollPhysics(),
            itemCount: 50,
            itemBuilder: (context, index) {
              return Padding(
                padding: index == 0
                    ? const EdgeInsets.only(right: AppPadding.superTiny)
                    : const EdgeInsets.symmetric(
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
            height: 120,
            width: 172,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(AppBorderRadius.r8),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: AppPadding.superTiny,
              horizontal: AppPadding.tiny,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Nevertheless",
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColor.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          "Episode 5 of 10",
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColor.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    CustomAppButton(
                      child: Image.asset(
                        AppImage.icPlay1,
                        height: 18,
                        width: 18,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: AppPadding.tiny),
                LinearProgressIndicator(
                  minHeight: AppPadding.superTiny,
                  borderRadius: BorderRadius.circular(AppBorderRadius.r4),
                  value: 4 / 10,
                  backgroundColor: AppColor.white.withOpacity(0.2),
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

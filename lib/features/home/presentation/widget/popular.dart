part of '../../home.dart';

class Popular extends StatelessWidget {
  const Popular({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                'Popular',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColor.greyScale900,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            CustomAppButton(
              text: "See all list",
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
            itemCount: 30,
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
                child: const _ItemFilmPopular(),
              );
            },
          ),
        )
      ],
    );
  }
}

class _ItemFilmPopular extends StatelessWidget {
  const _ItemFilmPopular();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppBorderRadius.r8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppBorderRadius.r8),
        child: Image.asset(
          AppImage.posterMovie,
          height: 164.w,
          width: 120.w,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

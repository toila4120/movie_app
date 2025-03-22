part of '../../home.dart';

class Popular extends StatelessWidget {
  const Popular({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                'Popular',
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
          height: 164,
          child: ListView.builder(
            itemCount: 5,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Container(
                padding: index == 0
                    ? const EdgeInsets.only(
                        right: AppPadding.superTiny,
                      )
                    : const EdgeInsets.symmetric(
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
          height: 164,
          width: 120,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

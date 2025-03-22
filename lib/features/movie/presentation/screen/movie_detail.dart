part of '../../movie.dart';

class MovieDetail extends StatefulWidget {
  const MovieDetail({super.key});

  @override
  State<MovieDetail> createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  @override
  Widget build(BuildContext context) {
    return AppContainer(
      resizeToAvoidBottomInset: true,
      child: ScrollConfiguration(
        behavior: const DisableGlowBehavior(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeaderMovieDetail(),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppPadding.large,
                  vertical: AppPadding.small,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "The Plot",
                      style: TextStyle(
                        color: AppColor.greyScale900,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Text(
                      "Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam.",
                      style: TextStyle(
                        color: AppColor.greyScale500,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: AppPadding.medium),
                    const Text(
                      "Casts",
                      style: TextStyle(
                        color: AppColor.greyScale900,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppPadding.small),
                    SizedBox(
                      height: 76,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(
                              left: index == 0 ? 0 : AppPadding.tiny,
                              right: AppPadding.tiny,
                            ),
                            child: const Column(
                              children: [
                                CircleAvatar(
                                  radius: 28,
                                  backgroundImage: AssetImage(
                                    AppImage.avatarDefault,
                                  ),
                                ),
                                SizedBox(width: AppPadding.superTiny),
                                Text(
                                  "Emma Wats",
                                  style: TextStyle(
                                    color: AppColor.greyScale900,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: AppPadding.medium),
                    const Text(
                      "Episodes",
                      style: TextStyle(
                        color: AppColor.greyScale900,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 60,
                                        width: 60,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            AppPadding.superTiny,
                                          ),
                                          color: AppColor.greyScale100,
                                        ),
                                      ),
                                      const SizedBox(width: AppPadding.small),
                                      const Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Episode 1",
                                              style: TextStyle(
                                                color: AppColor.greyScale900,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            Text(
                                              "56:00",
                                              style: TextStyle(
                                                color: AppColor.greyScale500,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 3,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const CustomAppButton(
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundImage:
                                        AssetImage(AppImage.icPlay),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppPadding.small),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeaderMovieDetail(),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppPadding.large,
                  vertical: AppPadding.small,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "The Plot",
                      style: TextStyle(
                        color: AppColor.greyScale900,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      "Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam.",
                      style: TextStyle(
                        color: AppColor.greyScale500,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: AppPadding.medium),
                    Text(
                      "Casts",
                      style: TextStyle(
                        color: AppColor.greyScale900,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: AppPadding.tiny),
                    SizedBox(
                      height: 76.w,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(
                              left: index == 0 ? 0 : AppPadding.tiny,
                              right: AppPadding.tiny,
                            ),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 28.w,
                                  backgroundImage: const AssetImage(
                                    AppImage.avatarDefault,
                                  ),
                                ),
                                SizedBox(width: AppPadding.superTiny),
                                Text(
                                  "Emma Wats",
                                  style: TextStyle(
                                    color: AppColor.greyScale900,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: AppPadding.medium),
                    Text(
                      "Episodes",
                      style: TextStyle(
                        color: AppColor.greyScale900,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: AppPadding.superTiny),
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
                                        height: 60.w,
                                        width: 60.w,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            AppPadding.superTiny,
                                          ),
                                          color: AppColor.greyScale100,
                                        ),
                                      ),
                                      SizedBox(width: AppPadding.small),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Episode 1",
                                              style: TextStyle(
                                                color: AppColor.greyScale900,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            Text(
                                              "56:00",
                                              style: TextStyle(
                                                color: AppColor.greyScale500,
                                                fontSize: 12.sp,
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
                                CustomAppButton(
                                  child: CircleAvatar(
                                    radius: 20.w,
                                    backgroundImage:
                                        const AssetImage(AppImage.icPlay),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: AppPadding.small),
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

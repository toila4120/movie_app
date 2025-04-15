part of '../../profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return AppContainer(
          resizeToAvoidBottomInset: true,
          child: Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + AppPadding.tiny,
              bottom: AppPadding.large,
              left: AppPadding.large,
              right: AppPadding.large,
            ),
            child: ScrollConfiguration(
              behavior: const DisableGlowBehavior(),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Profile",
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            // color: AppColor.greyScale900,
                          ),
                        ),
                        CustomAppButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            context.push(AppRouter.chooseAvatarScreenPath);
                          },
                          child: Image.asset(
                            AppImage.icEdit,
                            width: 24.w,
                            height: 24.w,
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: AppPadding.large),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 36.w,
                          backgroundImage: AssetImage(
                            AppAssets.getAvatarPath(state.userModel!.avatar),
                          ),
                          backgroundColor: AppColor.blue1,
                        ),
                        SizedBox(width: AppPadding.small),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              state.userModel!.name,
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w600,
                                // color: AppColor.greyScale900,
                              ),
                            ),
                            Text(
                              state.userModel!.email,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColor.greyScale500,
                              ),
                            ),
                            SizedBox(height: AppPadding.superTiny),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppPadding.tiny.w,
                                vertical: AppPadding.superTiny.w,
                              ),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(AppBorderRadius.r8.w),
                                color: state.userModel!.subscriptionPlan!.color,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    state.userModel!.subscriptionPlan!.icon,
                                    color: state
                                            .userModel!.subscriptionPlan!.isGold
                                        ? AppColor.yellow
                                        : state.userModel!.subscriptionPlan!
                                                .isSilver
                                            ? AppColor.greyScale500
                                            : AppColor.white,
                                    size: 16.w,
                                  ),
                                  SizedBox(width: AppPadding.tiny),
                                  Text(
                                    state.userModel!.subscriptionPlan!
                                        .displayName,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: AppColor.greyScale900,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: AppPadding.large),
                    Text(
                      "Cài đặt cá nhân",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColor.greyScale500,
                      ),
                    ),
                    SizedBox(height: AppPadding.medium),
                    CustomAppButton(
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                AppImage.icPlay2,
                                width: 20.w,
                                height: 20.w,
                              ),
                              SizedBox(width: AppPadding.small),
                              Text(
                                "Lịch sử xem",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  // color: AppColor.greyScale900,
                                ),
                              ),
                            ],
                          ),
                          Image.asset(
                            AppImage.icRight,
                            width: 20.w,
                            height: 20.w,
                            color: Theme.of(context).primaryColorDark,
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: AppPadding.large),
                    CustomAppButton(
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                AppImage.icHeart1,
                                width: 20.w,
                                height: 20.w,
                              ),
                              SizedBox(width: AppPadding.small),
                              Text(
                                "Phim đã thích",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  // color: AppColor.greyScale900,
                                ),
                              ),
                            ],
                          ),
                          Image.asset(
                            AppImage.icRight,
                            width: 20.w,
                            height: 20.w,
                            color: Theme.of(context).primaryColorDark,
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: AppPadding.large),
                    CustomAppButton(
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                AppImage.icDownload,
                                width: 20.w,
                                height: 20.w,
                              ),
                              SizedBox(width: AppPadding.small),
                              Text(
                                "Phim đã tải",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  // color: AppColor.greyScale900,
                                ),
                              ),
                            ],
                          ),
                          Image.asset(
                            AppImage.icRight,
                            width: 20.w,
                            height: 20.w,
                            color: Theme.of(context).primaryColorDark,
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: AppPadding.large),
                    CustomAppButton(
                      onPressed: () {
                        signOut();
                        context.go(AppRouter.loginScreenPath);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                AppImage.icLogout,
                                width: 20.w,
                                height: 20.w,
                              ),
                              SizedBox(width: AppPadding.small),
                              Text(
                                "Đăng xuất",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.primary500,
                                ),
                              ),
                            ],
                          ),
                          Image.asset(
                            AppImage.icRight,
                            width: 20.w,
                            height: 20.w,
                            color: Theme.of(context).primaryColorDark,
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: AppPadding.large),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

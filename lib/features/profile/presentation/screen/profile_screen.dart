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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Profile",
                          style: TextStyle(
                            fontSize: SizeConfig.getResponsive(20),
                            fontWeight: FontWeight.w600,
                            color: AppColor.greyScale900,
                          ),
                        ),
                        CustomAppButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            context.push(AppRouter.chooseAvatarScreenPath);
                          },
                          child: Image.asset(
                            AppImage.icEdit,
                            width: SizeConfig.getResponsive(24),
                            height: SizeConfig.getResponsive(24),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: AppPadding.large),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: SizeConfig.getResponsive(36),
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
                                fontSize: SizeConfig.getResponsive(20),
                                fontWeight: FontWeight.w600,
                                color: AppColor.greyScale900,
                              ),
                            ),
                            Text(
                              state.userModel!.email,
                              style: TextStyle(
                                fontSize: SizeConfig.getResponsive(12),
                                fontWeight: FontWeight.w500,
                                color: AppColor.greyScale500,
                              ),
                            ),
                            SizedBox(height: AppPadding.superTiny),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppPadding.tiny,
                                vertical: AppPadding.superTiny,
                              ),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(AppBorderRadius.r8),
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
                                    size: SizeConfig.getResponsive(16),
                                  ),
                                  SizedBox(width: AppPadding.tiny),
                                  Text(
                                    state.userModel!.subscriptionPlan!
                                        .displayName,
                                    style: TextStyle(
                                      fontSize: SizeConfig.getResponsive(16),
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
                      "Profile Settings",
                      style: TextStyle(
                        fontSize: SizeConfig.getResponsive(14),
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
                                width: SizeConfig.getResponsive(20),
                                height: SizeConfig.getResponsive(20),
                              ),
                              SizedBox(width: AppPadding.small),
                              Text(
                                "Watch History",
                                style: TextStyle(
                                  fontSize: SizeConfig.getResponsive(16),
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.greyScale900,
                                ),
                              ),
                            ],
                          ),
                          Image.asset(
                            AppImage.icRight,
                            width: SizeConfig.getResponsive(20),
                            height: SizeConfig.getResponsive(20),
                            color: AppColor.greyScale900,
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
                                width: SizeConfig.getResponsive(20),
                                height: SizeConfig.getResponsive(20),
                              ),
                              SizedBox(width: AppPadding.small),
                              Text(
                                "Liked Movies",
                                style: TextStyle(
                                  fontSize: SizeConfig.getResponsive(16),
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.greyScale900,
                                ),
                              ),
                            ],
                          ),
                          Image.asset(
                            AppImage.icRight,
                            width: SizeConfig.getResponsive(20),
                            height: SizeConfig.getResponsive(20),
                            color: AppColor.greyScale900,
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
                                width: SizeConfig.getResponsive(20),
                                height: SizeConfig.getResponsive(20),
                              ),
                              SizedBox(width: AppPadding.small),
                              Text(
                                "Downloaded Movies",
                                style: TextStyle(
                                  fontSize: SizeConfig.getResponsive(16),
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.greyScale900,
                                ),
                              ),
                            ],
                          ),
                          Image.asset(
                            AppImage.icRight,
                            width: SizeConfig.getResponsive(20),
                            height: SizeConfig.getResponsive(20),
                            color: AppColor.greyScale900,
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
                                width: SizeConfig.getResponsive(20),
                                height: SizeConfig.getResponsive(20),
                              ),
                              SizedBox(width: AppPadding.small),
                              Text(
                                "Sign Out",
                                style: TextStyle(
                                  fontSize: SizeConfig.getResponsive(16),
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.primary500,
                                ),
                              ),
                            ],
                          ),
                          Image.asset(
                            AppImage.icRight,
                            width: SizeConfig.getResponsive(20),
                            height: SizeConfig.getResponsive(20),
                            color: AppColor.greyScale900,
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

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
                        const Text(
                          "Profile",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: AppColor.greyScale900,
                          ),
                        ),
                        CustomAppButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {},
                          child: Image.asset(
                            AppImage.icEdit,
                            width: 24,
                            height: 24,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: AppPadding.large),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 36,
                          backgroundImage: AssetImage(
                            AppAssets.getAvatarPath(state.userModel!.avatar),
                          ),
                          backgroundColor: AppColor.blue1,
                        ),
                        const SizedBox(width: AppPadding.small),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              state.userModel!.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: AppColor.greyScale900,
                              ),
                            ),
                            Text(
                              state.userModel!.email,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColor.greyScale500,
                              ),
                            ),
                            const SizedBox(height: AppPadding.superTiny),
                            Container(
                              padding: const EdgeInsets.symmetric(
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
                                    size: 16,
                                  ),
                                  const SizedBox(width: AppPadding.tiny),
                                  Text(
                                    state.userModel!.subscriptionPlan!
                                        .displayName,
                                    style: const TextStyle(
                                      fontSize: 16,
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
                    const SizedBox(height: AppPadding.large),
                    const Text(
                      "Profile Settings",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColor.greyScale500,
                      ),
                    ),
                    const SizedBox(height: AppPadding.medium),
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
                                width: 20,
                                height: 20,
                              ),
                              const SizedBox(width: AppPadding.small),
                              const Text(
                                "Watch History",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.greyScale900,
                                ),
                              ),
                            ],
                          ),
                          Image.asset(
                            AppImage.icRight,
                            width: 20,
                            height: 20,
                            color: AppColor.greyScale900,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: AppPadding.large),
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
                                width: 20,
                                height: 20,
                              ),
                              const SizedBox(width: AppPadding.small),
                              const Text(
                                "Liked Movies",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.greyScale900,
                                ),
                              ),
                            ],
                          ),
                          Image.asset(
                            AppImage.icRight,
                            width: 20,
                            height: 20,
                            color: AppColor.greyScale900,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: AppPadding.large),
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
                                width: 20,
                                height: 20,
                              ),
                              const SizedBox(width: AppPadding.small),
                              const Text(
                                "Downloaded Movies",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.greyScale900,
                                ),
                              ),
                            ],
                          ),
                          Image.asset(
                            AppImage.icRight,
                            width: 20,
                            height: 20,
                            color: AppColor.greyScale900,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: AppPadding.large),
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
                                width: 20,
                                height: 20,
                              ),
                              const SizedBox(width: AppPadding.small),
                              const Text(
                                "Sign Out",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.primary500,
                                ),
                              ),
                            ],
                          ),
                          Image.asset(
                            AppImage.icRight,
                            width: 20,
                            height: 20,
                            color: AppColor.greyScale900,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: AppPadding.large),
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

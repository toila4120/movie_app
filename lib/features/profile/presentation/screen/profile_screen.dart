part of '../../profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void signOut() async {
    print("\n==== BẮT ĐẦU ĐĂNG XUẤT ====");
    try {
      // Đăng xuất khỏi Firebase
      await FirebaseAuth.instance.signOut();
      print("✅ Đã đăng xuất khỏi Firebase");

      // Đăng xuất khỏi Google
      try {
        final GoogleSignIn googleSignIn = GoogleSignIn();
        bool isSignedIn = await googleSignIn.isSignedIn();
        if (isSignedIn) {
          await googleSignIn.signOut();
          print("✅ Đã đăng xuất khỏi Google");
        } else {
          print("ℹ️ Không cần đăng xuất Google (chưa đăng nhập)");
        }
      } catch (e) {
        print("⚠️ Lỗi khi đăng xuất Google: $e");
      }

      // Xóa thông tin "Remember me" và thông tin đăng nhập đã lưu
      context.read<AuthenticationBloc>().add(const LogoutEvent());
      print("✅ Đã gửi yêu cầu xóa thông tin đăng nhập đã lưu");
    } catch (e) {
      print("❌ Lỗi khi đăng xuất: $e");
    }
    print("==== KẾT THÚC ĐĂNG XUẤT ====\n");
  }

  @override
  void initState() {
    super.initState();

    // Tải dữ liệu người dùng nếu chưa được tải
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });
  }

  void _loadUserData() {
    final appState = context.read<AppBloc>().state;
    // Nếu userModel đã được tải, không cần làm gì thêm
    if (appState.userModel != null) return;

    // Nếu userModel chưa được tải, lấy uid từ AuthenticationBloc
    final authState = context.read<AuthenticationBloc>().state;
    if (authState.user != null) {
      print(
          "ProfileScreen: Tải dữ liệu người dùng với uid ${authState.user!.uid}");
      context.read<AppBloc>().add(FetchUserEvent(uid: authState.user!.uid));
    } else {
      print("ProfileScreen: Người dùng chưa đăng nhập, không thể tải dữ liệu");
      // Nếu không có user, chuyển về màn hình đăng nhập
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          context.go(AppRouter.loginScreenPath);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppBloc, AppState>(
      listener: (context, state) {
        if (state.isLoading.isError && state.error != null) {
          // Hiển thị thông báo lỗi nếu có
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lỗi: ${state.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocBuilder<AppBloc, AppState>(
        builder: (context, state) {
          // Kiểm tra nếu userModel là null, hiển thị màn hình loading hoặc placeholder
          if (state.userModel == null) {
            return AppContainer(
              resizeToAvoidBottomInset: true,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    SizedBox(height: AppPadding.medium),
                    Text(
                      "Đang tải thông tin người dùng...",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // Nếu userModel có giá trị, hiển thị profile bình thường
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
                            "Trang cá nhân",
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
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
                              color: Theme.of(context).primaryColorDark,
                              cacheWidth: 48,
                              cacheHeight: 48,
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
                            backgroundColor: AppColor.blue1,
                            child: ClipOval(
                              child: Image.asset(
                                AppAssets.getAvatarPath(
                                    state.userModel!.avatar),
                                width: 72.w,
                                height: 72.w,
                                cacheWidth: 200,
                                cacheHeight: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
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
                                  borderRadius: BorderRadius.circular(
                                      AppBorderRadius.r8.w),
                                  color:
                                      state.userModel!.subscriptionPlan!.color,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      state.userModel!.subscriptionPlan!.icon,
                                      color: state.userModel!.subscriptionPlan!
                                              .isGold
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
                          // color: AppColor.greyScale400,
                        ),
                      ),
                      SizedBox(height: AppPadding.medium),
                      CustomAppButton(
                        onPressed: () {
                          context.push(AppRouter.watchedMovieScreenPath);
                        },
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
                                  cacheWidth: 40,
                                  cacheHeight: 40,
                                ),
                                SizedBox(width: AppPadding.small),
                                Text(
                                  "Lịch sử xem",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Image.asset(
                              AppImage.icRight,
                              width: 20.w,
                              height: 20.w,
                              color: Theme.of(context).primaryColorDark,
                              cacheWidth: 40,
                              cacheHeight: 40,
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: AppPadding.large),
                      CustomAppButton(
                        onPressed: () {
                          context.read<ProfileBloc>().add(
                              GetFavoriteMoviesEvent(user: state.userModel!));
                          context.push(
                            AppRouter.likeMovieScreenPath,
                          );
                        },
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
                                  cacheWidth: 40,
                                  cacheHeight: 40,
                                ),
                                SizedBox(width: AppPadding.small),
                                Text(
                                  "Phim đã thích",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Image.asset(
                              AppImage.icRight,
                              width: 20.w,
                              height: 20.w,
                              color: Theme.of(context).primaryColorDark,
                              cacheWidth: 40,
                              cacheHeight: 40,
                            )
                          ],
                        ),
                      ),
                      // SizedBox(height: AppPadding.large),
                      // CustomAppButton(
                      //   onPressed: () {},
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.start,
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //           Image.asset(
                      //             AppImage.icDownload,
                      //             width: 20.w,
                      //             height: 20.w,
                      //             cacheWidth: 40,
                      //             cacheHeight: 40,
                      //           ),
                      //           SizedBox(width: AppPadding.small),
                      //           Text(
                      //             "Phim đã tải",
                      //             style: TextStyle(
                      //               fontSize: 16.sp,
                      //               fontWeight: FontWeight.w500,
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //       Image.asset(
                      //         AppImage.icRight,
                      //         width: 20.w,
                      //         height: 20.w,
                      //         color: Theme.of(context).primaryColorDark,
                      //         cacheWidth: 40,
                      //         cacheHeight: 40,
                      //       )
                      //     ],
                      //   ),
                      // ),
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
                                  cacheWidth: 40,
                                  cacheHeight: 40,
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
                              cacheWidth: 40,
                              cacheHeight: 40,
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
      ),
    );
  }
}

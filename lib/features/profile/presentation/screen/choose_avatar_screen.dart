part of '../../profile.dart';

class ChooseAvatarScreen extends StatefulWidget {
  const ChooseAvatarScreen({super.key});

  @override
  State<ChooseAvatarScreen> createState() => _ChooseAvatarScreenState();
}

class _ChooseAvatarScreenState extends State<ChooseAvatarScreen> {
  int _selectedAvatarIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedAvatarIndex = context.read<AppBloc>().state.userModel!.avatar;
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = screenWidth > 600 ? 4 : 3;
    final int numberOfRows = (AppAssets.avatars.length / crossAxisCount).ceil();
    final double totalGridHeight = ((screenWidth -
                    AppPadding.large * 2 -
                    (crossAxisCount - 1) * AppPadding.small) /
                crossAxisCount) *
            numberOfRows +
        AppPadding.small * (numberOfRows - 1);

    return BlocConsumer<AppBloc, AppState>(
      listener: (context, state) {
        if (state.isLoading == LoadingState.finished) {
          Navigator.of(context).pop();
        } else if (state.isLoading == LoadingState.error) {
          showToast(context, message: 'Error: ${state.error}');
        }
      },
      builder: (context, state) {
        return AppContainer(
          resizeToAvoidBottomInset: true,
          child: Column(
            children: [
              const AppHeader(
                title: 'Chọn Avatar',
              ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: const DisableGlowBehavior(),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(
                      top: AppPadding.superTiny,
                      left: AppPadding.large,
                      right: AppPadding.large,
                      bottom: AppPadding.large,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(AppPadding.small),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  AppBorderRadius.r16,
                                ),
                                border: Border.all(
                                  color: AppColor.greyScale300,
                                ),
                              ),
                              child: Image.asset(
                                AppAssets.getAvatarPath(
                                  _selectedAvatarIndex,
                                ),
                                width: 200.w,
                                height: 200.w,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppPadding.large),
                        Text(
                          "Chọn avatar mà bạn thích",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColor.greyScale900,
                          ),
                        ),
                        SizedBox(height: AppPadding.medium),
                        SizedBox(
                          height: totalGridHeight,
                          child: GridView.builder(
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: AppPadding.small,
                              mainAxisSpacing: AppPadding.small,
                              childAspectRatio: 1,
                            ),
                            itemCount: AppAssets.avatars.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedAvatarIndex = index;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: _selectedAvatarIndex == index
                                        ? Colors.blue.withValues(alpha: 0.3)
                                        : AppColor.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Image.asset(
                                    AppAssets.avatars[index],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: AppPadding.medium),
                        ElevatedButton(
                          onPressed: () {
                            context.read<AppBloc>().add(UpdateAvatarEvent(
                                  newAvatar: _selectedAvatarIndex,
                                ));
                            showToast(context, message: 'Cập nhật thành công!');
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Xác nhận'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

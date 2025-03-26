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

    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return AppContainer(
          resizeToAvoidBottomInset: true,
          child: Column(
            children: [
              const AppHeader(
                title: 'Choose Avatar',
              ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: const DisableGlowBehavior(),
                  child: SingleChildScrollView(
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
                                width: SizeConfig.getResponsive(200),
                                height: SizeConfig.getResponsive(200),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppPadding.large),
                        Text(
                          "Select your avatar",
                          style: TextStyle(
                            fontSize: SizeConfig.getResponsive(16),
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
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Done'),
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

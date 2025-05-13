part of '../../categories.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return AppContainer(
      resizeToAvoidBottomInset: true,
      // backgroundColor: AppColor.backGroundScreen,
      child: Column(
        children: [
          const AppHeader(
            title: 'Thể loại',
          ),
          Expanded(
            child: BaseScrollView(
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
                  child: const Column(
                    children: [
                      CategoriesList(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

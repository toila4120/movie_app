part of '../../categories.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return const AppContainer(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColor.backGroundScreen,
      child: Column(
        children: [
          AppHeader(
            title: 'Categories',
          ),
          Expanded(
            child: ScrollConfiguration(
              behavior: DisableGlowBehavior(),
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  top: AppPadding.superTiny,
                  left: AppPadding.large,
                  right: AppPadding.large,
                  bottom: AppPadding.large,
                ),
                child: Column(
                  children: [
                    CategoriesList(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

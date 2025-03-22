part of '../../home.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const AppContainer(
      resizeToAvoidBottomInset: true,
      child: ScrollConfiguration(
        behavior: DisableGlowBehavior(),
        child: Column(
          children: [
            Expanded(
              child: ScrollConfiguration(
                behavior: DisableGlowBehavior(),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      BannerHome(),
                      SizedBox(height: AppPadding.small),
                      Padding(
                        padding: EdgeInsets.only(
                          left: AppPadding.large,
                          right: AppPadding.large,
                          bottom: AppPadding.small,
                        ),
                        child: Column(
                          children: [
                            CategoryWidget(),
                            SizedBox(height: AppPadding.small),
                            ContinueWatching(),
                            SizedBox(height: AppPadding.small),
                            Popular(),
                            SizedBox(height: AppPadding.small),
                            Popular(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

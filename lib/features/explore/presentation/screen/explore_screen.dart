part of '../../explore.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  Widget build(BuildContext context) {
    return AppContainer(
      resizeToAvoidBottomInset: true,
      child: Column(
        children: [
          const AppHeaderForExplore(),
          Expanded(
            child: ScrollConfiguration(
              behavior: const DisableGlowBehavior(),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: AppPadding.small,
                    left: AppPadding.large,
                    right: AppPadding.large,
                    bottom: AppPadding.small,
                  ),
                  child: const Column(
                    children: [
                      ListMovieWidget(),
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

part of '../../home.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    context.read<CategoriesBloc>().add(FetchCategories());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      resizeToAvoidBottomInset: true,
      child: RefreshIndicator(
        onRefresh: () async {
          context.read<HomeBloc>().add(
                FectchMovieForBannerMovies(),
              );
        },
        child: ScrollConfiguration(
          behavior: const DisableGlowBehavior(),
          child: Column(
            children: [
              Expanded(
                child: ScrollConfiguration(
                  behavior: const DisableGlowBehavior(),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        const BannerHome(),
                        SizedBox(height: AppPadding.small),
                        Padding(
                          padding: EdgeInsets.only(
                            left: AppPadding.large,
                            right: AppPadding.large,
                            bottom: AppPadding.small,
                          ),
                          child: Column(
                            children: [
                              const CategoryWidget(),
                              SizedBox(height: AppPadding.small),
                              const ContinueWatching(),
                              SizedBox(height: AppPadding.small),
                              const Popular(),
                              SizedBox(height: AppPadding.small),
                              const Popular(),
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
      ),
    );
  }
}

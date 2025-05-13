part of '../../profile.dart';

class LikeMovieScreen extends StatefulWidget {
  const LikeMovieScreen({super.key});

  @override
  State<LikeMovieScreen> createState() => _LikeMovieScreenState();
}

class _LikeMovieScreenState extends State<LikeMovieScreen> {
  @override
  Widget build(BuildContext context) {
    return AppContainer(
      resizeToAvoidBottomInset: true,
      child: BaseScrollView(
        onRefresh: () async {
          final appState = context.read<AuthenticationBloc>().state;
          if (appState.user != null) {
            context.read<ProfileBloc>().add(
                  GetFavoriteMoviesEvent(user: appState.user!),
                );
          }
        },
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, profileState) {
            return Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + AppPadding.tiny,
                bottom: AppPadding.large,
                left: AppPadding.large,
                right: AppPadding.large,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const BackButton(),
                      Text(
                        'Phim đã thích',
                        style: TextStyle(
                          fontSize: 18.w,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppPadding.small),
                  if (profileState.isLoading == LoadingState.loading)
                    const Center(child: MovieShimmerList())
                  else if (profileState.isLoading == LoadingState.error)
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            AppImage.imageNotFound,
                            width: 100.w,
                            height: 100.w,
                          ),
                          SizedBox(height: AppPadding.tiny),
                          Text("Đã có lỗi xảy ra: ${profileState.error}"),
                        ],
                      ),
                    )
                  else if (profileState.movies?.isEmpty ?? true)
                    const Center(child: Text('Không có phim nào'))
                  else
                    ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: profileState.movies!.length,
                      itemBuilder: (context, index) {
                        final movie = profileState.movies![index];
                        return Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: AppPadding.tiny),
                          child: ItemMovie(movieModel: movie),
                        );
                      },
                    ),
                  if (profileState.isLoading == LoadingState.loading &&
                      profileState.movies?.isNotEmpty == true)
                    Padding(
                      padding: EdgeInsets.all(AppPadding.medium),
                      child: const ItemMovieShimer(),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

part of '../../movie.dart';

class HeaderMovieDetail extends StatelessWidget {
  final MovieEntity movie;
  const HeaderMovieDetail({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Hero(
          tag: movie.slug,
          transitionOnUserGestures: true,
          flightShuttleBuilder: (
            BuildContext flightContext,
            Animation<double> animation,
            HeroFlightDirection flightDirection,
            BuildContext fromHeroContext,
            BuildContext toHeroContext,
          ) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            );

            return ScaleTransition(
              scale:
                  Tween<double>(begin: 1.0, end: 1.0).animate(curvedAnimation),
              child: FadeTransition(
                opacity: curvedAnimation,
                child: flightDirection == HeroFlightDirection.push
                    ? fromHeroContext.widget
                    : toHeroContext.widget,
              ),
            );
          },
          child: CachedNetworkImage(
            key: ValueKey(movie.thumbUrl),
            imageUrl: movie.thumbUrl,
            height: MediaQuery.of(context).size.height * 0.3,
            width: double.infinity,
            fit: BoxFit.fill,
            fadeInDuration: const Duration(milliseconds: 300),
            fadeOutDuration: const Duration(milliseconds: 200),
            placeholder: (context, url) => Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                width: 120.w,
                height: 88.w,
                color: Colors.grey.shade300,
              ),
            ),
            errorWidget: (context, url, error) => Container(
              width: 120.w,
              height: 88.w,
              color: Colors.grey.shade300,
              child: const Center(
                child: Icon(
                  Icons.broken_image,
                  color: Colors.grey,
                  size: 40,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: AppPadding.tiny + MediaQuery.of(context).padding.top,
          left: AppPadding.large,
          right: AppPadding.large,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomAppButton(
                onPressed: () {
                  context.pop();
                },
                child: Image.asset(
                  AppImage.icBack,
                  width: 20.w,
                  height: 28.w,
                  color: AppColor.white,
                ),
              ),
              BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, state) {
                  return CustomAppButton(
                    onPressed: () {
                      context
                          .read<AuthenticationBloc>()
                          .add(LikeMovieEvent(movieId: movie.slug));
                      context
                          .read<ProfileBloc>()
                          .add(RemoveFavoriteMovieEvent(slug: movie.slug));
                    },
                    child: Image.asset(
                      AppImage.icBookMark,
                      width: 28.w,
                      height: 28.w,
                      color: state.user!.likedMovies.contains(movie.slug)
                          ? AppColor.yellow
                          : AppColor.white,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

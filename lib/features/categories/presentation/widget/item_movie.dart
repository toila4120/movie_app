part of '../../categories.dart';

class ItemMovie extends StatelessWidget {
  final MovieEntity movieModel;
  const ItemMovie({
    super.key,
    required this.movieModel,
  });

  @override
  Widget build(BuildContext context) {
    return CustomAppButton(
      onPressed: () {
        context.read<MovieBloc>().add(
              FetchMovieDetailEvent(
                slug: movieModel.slug,
              ),
            );
        context.push(
          AppRouter.movieDetailPath,
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppPadding.tiny,
          vertical: AppPadding.tiny,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppBorderRadius.r16),
            border: Border.all(
              color: Theme.of(context).primaryColorDark.withValues(alpha: 0.1),
            )),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Hero(
                    tag: movieModel.slug,
                    flightShuttleBuilder: (
                      BuildContext flightContext,
                      Animation<double> animation,
                      HeroFlightDirection flightDirection,
                      BuildContext fromHeroContext,
                      BuildContext toHeroContext,
                    ) {
                      return FadeTransition(
                        opacity: animation,
                        child: flightDirection == HeroFlightDirection.push
                            ? fromHeroContext.widget
                            : toHeroContext.widget,
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppBorderRadius.r16),
                      child: ProgressiveImage(
                        key: ValueKey(normalizeImageUrl(movieModel.posterUrl)),
                        imageUrl: normalizeImageUrl(movieModel.posterUrl),
                        width: 120.w,
                        height: 144.w,
                        fit: BoxFit.fill,
                        memCacheWidth: 120,
                        memCacheHeight: 144,
                      ),
                    ),
                  ),
                  SizedBox(width: AppPadding.medium),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movieModel.name,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: AppPadding.superTiny),
                        Text(
                          movieModel.episodeCurrent,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColor.greyScale500,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: AppPadding.superTiny),
                        Text(
                          movieModel.lang,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColor.greyScale500,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: AppPadding.tiny),
            Image.asset(
              AppImage.icRight,
              width: 16.w,
              height: 16.w,
              color: Theme.of(context).primaryColorDark,
            ),
          ],
        ),
      ),
    );
  }
}

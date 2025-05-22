part of '../../explore.dart';

class ListMovieWidget extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final movies;
  const ListMovieWidget({
    super.key,
    this.movies = const [],
  });

  @override
  State<ListMovieWidget> createState() => _ListMovieWidgetState();
}

class _ListMovieWidgetState extends State<ListMovieWidget> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8.w,
        crossAxisSpacing: 8.w,
        childAspectRatio: 186.w / 455.w,
      ),
      itemCount: widget.movies.length,
      itemBuilder: (context, index) {
        final movie = widget.movies[index];
        return MovieItemWidget(
          movie: movie,
          onTap: () {
            context
                .read<MovieBloc>()
                .add(FetchMovieDetailEvent(slug: movie.slug));
            context.push(AppRouter.movieDetailPath);
          },
        );
      },
    );
  }
}

class MovieItemWidget extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final movie;
  final VoidCallback onTap;

  const MovieItemWidget({
    super.key,
    required this.movie,
    required this.onTap,
  });

  static final _placeholder = Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Container(color: Colors.grey.shade300),
  );

  static final _errorWidget = Container(
    color: Colors.grey.shade300,
    child: const Center(
      child: Icon(Icons.broken_image, color: Colors.grey, size: 40),
    ),
  );

  @override
  Widget build(BuildContext context) {
    

    return CustomAppButton(
      onPressed: onTap,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppBorderRadius.r8),
            child: CachedNetworkImage(
              key: ValueKey(normalizeImageUrl(movie.posterUrl)),
              imageUrl: normalizeImageUrl(movie.posterUrl),
              height: 248.0.w,
              width: 186.0.w,
              fit: BoxFit.fill,
              placeholder: (context, url) => SizedBox(
                height: 248.0.w,
                width: 186.0.w,
                child: _placeholder,
              ),
              errorWidget: (context, url, error) => SizedBox(
                height: 248.0.w,
                width: 186.0.w,
                child: _errorWidget,
              ),
            ),
          ),
          SizedBox(height: AppPadding.superTiny),
          Text(
            movie.name,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12.0.w,
              fontWeight: FontWeight.w500,
              color: AppColor.greyScale500,
            ),
          ),
        ],
      ),
    );
  }
}

part of '../../explore.dart';

class ContainerTheLoai extends StatelessWidget {
  const ContainerTheLoai({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesBloc, CategoriesState>(
      builder: (context, categoriesState) {
        return BlocBuilder<ExploreBloc, ExploreState>(
          builder: (context, exploreState) {
            return SizedBox(
              height: 38,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categoriesState.categories.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    final isSelected = exploreState.genres.contains('all');
                    return ContainerItem(
                      title: 'Tất cả',
                      isSelected: isSelected,
                      genreSlug: 'all',
                      onTap: (slug) {
                        context
                            .read<ExploreBloc>()
                            .add(UpdategGenreEvent(slug));
                      },
                    );
                  }
                  final category = categoriesState.categories[index - 1];
                  final isSelected =
                      exploreState.genres.contains(category.slug);
                  return Padding(
                    padding: EdgeInsets.only(left: AppPadding.tiny),
                    child: ContainerItem(
                      title: category.name,
                      isSelected: isSelected,
                      genreSlug: category.slug,
                      onTap: (slug) {
                        context
                            .read<ExploreBloc>()
                            .add(UpdategGenreEvent(slug));
                      },
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

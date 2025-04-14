part of '../../explore.dart';

class ContainerLoaiPhim extends StatelessWidget {
  const ContainerLoaiPhim({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExploreBloc, ExploreState>(
      builder: (context, state) {
        return SizedBox(
          height: 38,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: CategoriesEnum.toCount(),
            itemBuilder: (context, index) {
              final category = CategoriesEnum.toList()[index];
              final isSelected = state.categories.contains(category['slug']);
              return Padding(
                padding: EdgeInsets.only(right: AppPadding.tiny),
                child: ContainerItem(
                  title: category['name']!,
                  isSelected: isSelected,
                  genreSlug: category['slug']!,
                  onTap: (slug) {
                    context
                        .read<ExploreBloc>()
                        .add(UpdateCategoriesEvent(slug));
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}

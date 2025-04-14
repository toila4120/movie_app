part of '../../explore.dart';

class ContainerSort extends StatelessWidget {
  const ContainerSort({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExploreBloc, ExploreState>(
      builder: (context, state) {
        return SizedBox(
          height: 38,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: SortType.toCount(),
            itemBuilder: (context, index) {
              final sortItem = SortType.toList()[index];
              final isSelected = state.sort == sortItem['slug'];
              return Padding(
                padding: EdgeInsets.only(right: AppPadding.tiny),
                child: ContainerItem(
                  title: sortItem['name']!,
                  isSelected: isSelected,
                  genreSlug: sortItem['slug']!,
                  onTap: (slug) {
                    context.read<ExploreBloc>().add(UpdateSortEvent(slug));
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

part of '../../explore.dart';

class ContainerYear extends StatelessWidget {
  const ContainerYear({super.key});

  List<Map<String, String>> getYearList() {
    final currentYear = DateTime.now().year;
    List<Map<String, String>> years = [
      {'slug': 'all', 'name': 'Tất cả'},
    ];
    for (int i = 0; i <= 15; i++) {
      final year = currentYear - i;
      years.add({
        'slug': year.toString(),
        'name': year.toString(),
      });
    }
    return years;
  }

  @override
  Widget build(BuildContext context) {
    final yearList = getYearList();
    return BlocBuilder<ExploreBloc, ExploreState>(
      builder: (context, state) {
        return SizedBox(
          height: 38,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: yearList.length,
            itemBuilder: (context, index) {
              final yearItem = yearList[index];
              final isSelected = state.years.contains(yearItem['slug']);
              return Padding(
                padding: EdgeInsets.only(right: AppPadding.tiny),
                child: ContainerItem(
                  title: yearItem['name']!,
                  isSelected: isSelected,
                  genreSlug: yearItem['slug']!,
                  onTap: (slug) {
                    context.read<ExploreBloc>().add(UpdateYearEvent(slug));
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

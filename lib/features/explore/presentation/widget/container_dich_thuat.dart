part of '../../explore.dart';

class ContainerDichThuat extends StatelessWidget {
  const ContainerDichThuat({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExploreBloc, ExploreState>(
      builder: (context, state) {
        return SizedBox(
          height: 38,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: TranslationType.toCount(),
            itemBuilder: (context, index) {
              final translationItem = TranslationType.toList()[index];
              final isSelected =
                  state.translations.contains(translationItem['slug']);
              return Padding(
                padding: EdgeInsets.only(right: AppPadding.tiny),
                child: ContainerItem(
                  title: translationItem['name']!,
                  isSelected: isSelected,
                  genreSlug: translationItem['slug']!,
                  onTap: (slug) {
                    context
                        .read<ExploreBloc>()
                        .add(UpdateTranslationEvent(slug));
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

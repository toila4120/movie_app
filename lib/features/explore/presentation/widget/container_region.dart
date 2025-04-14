import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/core/enum/loading_state.dart';
import 'package:movie_app/features/explore/explore.dart';
import 'package:movie_app/features/explore/presentation/bloc/explore_bloc.dart';

class ContainerRegion extends StatelessWidget {
  const ContainerRegion({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExploreBloc, ExploreState>(
      builder: (context, state) {
        if (state.loadingState == LoadingState.loading &&
            state.availableRegions.isEmpty) {
          return const SizedBox(
            height: 38,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (state.loadingState == LoadingState.error) {
          return const SizedBox(
            height: 38,
            child: Center(child: Text('Lỗi khi tải danh sách quốc gia')),
          );
        }
        final regionList = [
          {'slug': 'all', 'name': 'Tất cả'},
          ...state.availableRegions.map((region) => {
                'slug': region.slug,
                'name': region.name,
              }),
        ];
        return SizedBox(
          height: 38,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: regionList.length - 2,
            itemBuilder: (context, index) {
              final region = regionList[index];
              final isSelected = state.regions.contains(region['slug']);
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ContainerItem(
                  title: region['name']!,
                  isSelected: isSelected,
                  genreSlug: region['slug']!,
                  onTap: (slug) {
                    context.read<ExploreBloc>().add(UpdateRegionEvent(slug));
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

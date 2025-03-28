part of '../../categories.dart';

class MovieShimmerList extends StatelessWidget {
  const MovieShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: AppPadding.tiny),
          child: const ItemMovieShimer(),
        );
      },
    );
  }
}

part of '../../categories.dart';

class CategoriesList extends StatefulWidget {
  const CategoriesList({super.key});

  @override
  State<CategoriesList> createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesBloc, CategoriesState>(
      builder: (context, state) {
        if (state.loadingState == LoadingState.loading) {
          return const SizedBox(
            child: Center(
              child: ItemShimmer(),
            ),
          );
        } else if (state.loadingState == LoadingState.error) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AppImage.imageNotFound,
                  width: 100.w,
                  height: 100.w,
                ),
                SizedBox(height: AppPadding.tiny),
                const Text("Đã có lỗi xảy ra, vui lòng thử lại sau"),
              ],
            ),
          );
        } else if (state.loadingState == LoadingState.finished &&
            state.categories.isNotEmpty) {
          return ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.categories.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(bottom: AppPadding.tiny),
                child: _Itemcategories(
                  title: state.categories[index].name,
                  slug: state.categories[index].slug,
                ),
              );
            },
          );
        }
        return Center(
          child: Text(
            'Không có thể loại nào',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      },
    );
  }
}

class _Itemcategories extends StatelessWidget {
  final String title;
  final String slug;
  const _Itemcategories({
    required this.title,
    required this.slug,
  });

  @override
  Widget build(BuildContext context) {
    return CustomAppButton(
      onPressed: () {
        context.read<MovieBloc>().add(
              FetchMoviesByCategory(categorySlug: slug),
            );
        context.push(
          AppRouter.listMoviePath,
          extra: {
            "input": title,
            "input2": slug,
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          // color: AppColor.white,
          border: Border.all(
            color: AppColor.greyScale200,
          ),
          borderRadius: BorderRadius.circular(AppBorderRadius.r8),
        ),
        padding: EdgeInsets.symmetric(
          vertical: AppPadding.small,
          horizontal: AppPadding.small,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            Image.asset(
              AppImage.icRight,
              width: 16.w,
              height: 16.w,
            ),
          ],
        ),
      ),
    );
  }
}

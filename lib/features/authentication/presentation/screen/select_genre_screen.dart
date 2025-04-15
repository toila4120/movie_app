part of '../../authentication.dart';

class SelectGenreScreen extends StatefulWidget {
  const SelectGenreScreen({super.key});

  @override
  State<SelectGenreScreen> createState() => _SelectGenreScreenState();
}

class _SelectGenreScreenState extends State<SelectGenreScreen> {
  List<String> selectedGenres = [];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      resizeToAvoidBottomInset: true,
      child: ScrollConfiguration(
        behavior: const DisableGlowBehavior(),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
              left: AppPadding.large,
              right: AppPadding.large,
              bottom: AppPadding.large,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Chọn thể loại mà bạn quan tâm',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w500,
                        // color: AppColor.greyScale900,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppPadding.large),
                Text(
                  'Chọn thể loại mà bạn quan tâm để chúng tôi có thể gợi ý cho bạn những bộ phim hay nhất.',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    // color: AppColor.greyScale600,
                  ),
                ),
                SizedBox(height: AppPadding.large),
                BlocBuilder<CategoriesBloc, CategoriesState>(
                  builder: (context, state) {
                    if (state.loadingState.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state.loadingState.isError) {
                      return const Center(
                        child: Text(
                          'Không thể tải danh mục',
                        ),
                      );
                    } else if (state.categories.isEmpty) {
                      return const Center(
                        child: Text(
                          'Không có thể loại nào',
                        ),
                      );
                    }
                    return Wrap(
                      spacing: AppPadding.small,
                      runSpacing: AppPadding.medium,
                      children: state.categories.map((genre) {
                        final isSelected = selectedGenres.contains(genre.slug);
                        return ContainerGenre(
                          title: genre.name,
                          genreSlug: genre.slug,
                          isSelected: isSelected,
                          onTap: (slug) {
                            setState(() {
                              if (isSelected) {
                                selectedGenres.remove(slug);
                              } else {
                                selectedGenres.add(slug);
                              }
                            });
                          },
                        );
                      }).toList(),
                    );
                  },
                ),
                SizedBox(height: AppPadding.large),
                CustomAppButton(
                  decoration: BoxDecoration(
                    color: AppColor.primary500,
                    borderRadius: BorderRadius.circular(AppPadding.medium),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: AppPadding.medium,
                    horizontal: AppPadding.large,
                  ),
                  onPressed: () {
                    if (selectedGenres.isEmpty) {
                      showToast(context,
                          message: "Vui lòng chọn ít nhất 1 thể loại");
                    } else {
                      context
                          .read<AuthenticationBloc>()
                          .add(UpdateGenresEvent(genres: selectedGenres));
                      context.go(AppRouter.splashLoginScreenPath);
                    }
                  },
                  child: Text(
                    'Xác nhận',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColor.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

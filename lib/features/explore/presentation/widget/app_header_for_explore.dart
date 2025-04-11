part of '../../explore.dart';

class AppHeaderForExplore extends StatefulWidget {
  const AppHeaderForExplore({super.key});

  @override
  State<AppHeaderForExplore> createState() => _AppHeaderForExploreState();
}

class _AppHeaderForExploreState extends State<AppHeaderForExplore> {
  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    context.read<ExploreBloc>().add(ExploreEventSearch(query, 1));
  }

  void _clearSearch() {
    _controller.clear();
    context.read<ExploreBloc>().add(
          const ExploreEventSearch('', 1),
        );
  }

  void clearTextField() {
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: headerPadding(context),
      child: Row(
        children: [
          Expanded(
            child: AppTextField(
              controller: _controller,
              hintText: 'Tìm kiếm',
              onSubmitted: _onSearchChanged,
              prefixIcon: Padding(
                padding: EdgeInsets.all(AppPadding.small.w),
                child: SizedBox(
                  height: AppPadding.small,
                  width: AppPadding.small,
                  child: const ImageIcon(
                    AssetImage(AppImage.icSearchTab),
                    color: AppColor.greyScale300,
                  ),
                ),
              ),
              suffixIcon: _controller.text.trim().isNotEmpty
                  ? IconButton(
                      icon:
                          const Icon(Icons.clear, color: AppColor.greyScale300),
                      onPressed: _clearSearch,
                    )
                  : null,
            ),
          ),
          SizedBox(width: AppPadding.small),
          CustomAppButton(
            onPressed: () {},
            child: Container(
              padding: EdgeInsets.all(AppPadding.small.w),
              decoration: BoxDecoration(
                color: AppColor.primary100,
                borderRadius: BorderRadius.circular(AppBorderRadius.r8.w),
              ),
              child: Icon(
                Icons.filter_list,
                color: AppColor.primary500,
                size: AppPadding.large + AppPadding.superTiny,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

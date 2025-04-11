part of '../../explore.dart';

class AppHeaderForExplore extends StatelessWidget {
  const AppHeaderForExplore({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: headerPadding(context),
      child: Row(
        children: [
          Expanded(
            child: AppTextField(
              hintText: 'Search',
              onSubmitted: (p0) {
                context.read<ExploreBloc>().add(
                      ExploreEventSearch(
                        p0,
                        1,
                      ),
                    );
              },
              prefixIcon: Padding(
                padding: EdgeInsets.all(AppPadding.small.w),
                child: SizedBox(
                  height: 16.w,
                  width: 16.w,
                  child: const ImageIcon(
                    AssetImage(AppImage.icSearchTab),
                    color: AppColor.greyScale300,
                  ),
                ),
              ),
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
                size: 16.w,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

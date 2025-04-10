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
                borderRadius: BorderRadius.circular(8),
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

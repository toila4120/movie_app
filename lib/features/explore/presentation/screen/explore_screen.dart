part of '../../explore.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
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
              top: MediaQuery.of(context).padding.top + AppPadding.small,
              left: AppPadding.large,
              right: AppPadding.large,
              bottom: AppPadding.small,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: AppTextField(
                        hintText: 'Search',
                        prefixIcon: Icon(
                          Icons.search,
                          color: AppColor.greyScale300,
                        ),
                      ),
                    ),
                    SizedBox(width: AppPadding.small),
                    CustomAppButton(
                      onPressed: () {},
                      child: Container(
                        padding: EdgeInsets.all(AppPadding.small),
                        decoration: BoxDecoration(
                          color: AppColor.primary100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.filter_list,
                          color: AppColor.primary500,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

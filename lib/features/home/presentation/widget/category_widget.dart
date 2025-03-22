part of '../../home.dart';

class CategoryWidget extends StatefulWidget {
  const CategoryWidget({super.key});

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  @override
  Widget build(BuildContext context) {
    List<String> category = [
      AppImage.imageAnime,
      AppImage.imageTinhCam,
      AppImage.imageHanhDong,
      AppImage.imageCoTrang,
    ];

    List<String> categoryTitle = [
      "Anime",
      "Tình cảm",
      "Hành động",
      "Cổ trang",
    ];

    double screenWidth = MediaQuery.of(context).size.width;
    double crossAxisSpacing = AppPadding.tiny;
    double paddingTotal = crossAxisSpacing + AppPadding.large;

    double itemWidth = (screenWidth - paddingTotal) / 2;
    if (itemWidth <= 0 || itemWidth.isNaN) {
      itemWidth = 100;
    }
    double desiredHeight = 60;
    double childAspectRatio = itemWidth / desiredHeight;
    if (childAspectRatio.isNaN || childAspectRatio.isInfinite) {
      childAspectRatio = 2.0;
    }

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Expanded(
              child: Text(
                'Category',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColor.greyScale900,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            CustomAppButton(
              onPressed: () {
                context.push(AppRouter.categoriesTabPath);
              },
              text: "See all list",
              textStyle: const TextStyle(
                fontSize: 12,
                color: AppColor.primary500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppPadding.tiny),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: (2 * 60) + AppPadding.tiny,
                child: GridView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: AppPadding.tiny,
                    mainAxisSpacing: AppPadding.tiny,
                    childAspectRatio: childAspectRatio,
                  ),
                  itemCount: category.length,
                  itemBuilder: (context, index) {
                    return _ItemCategory(
                      image: category[index],
                      title: categoryTitle[index],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ItemCategory extends StatelessWidget {
  final String image;
  final String title;
  const _ItemCategory({required this.image, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppBorderRadius.r8),
        border: Border.all(
          color: AppColor.greyScale200,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppBorderRadius.r8),
                bottomLeft: Radius.circular(AppBorderRadius.r8),
              ),
              child: Image.asset(
                height: double.infinity,
                image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            width: 80,
            height: 60,
            decoration: BoxDecoration(
              color: AppColor.black.withOpacity(0.9),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(AppBorderRadius.r8),
                bottomRight: Radius.circular(AppBorderRadius.r8),
              ),
            ),
            padding: const EdgeInsets.all(AppPadding.small),
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                  color: AppColor.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

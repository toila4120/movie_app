part of '../../movie.dart';

class HeaderMovieDetail extends StatelessWidget {
  final MovieEntity movie;
  const HeaderMovieDetail({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: movie.thumbUrl,
          height: MediaQuery.of(context).size.height * 0.3,
          width: double.infinity,
          fit: BoxFit.fill,
          placeholder: (context, url) => Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: 120.w,
              height: 88.w,
              color: Colors.grey.shade300,
            ),
          ),
          errorWidget: (context, url, error) => Container(
            width: 120.w,
            height: 88.w,
            color: Colors.grey.shade300,
            child: const Center(
              child: Icon(
                Icons.broken_image,
                color: Colors.grey,
                size: 40,
              ),
            ),
          ),
        ),
        Positioned(
          top: AppPadding.tiny + MediaQuery.of(context).padding.top,
          left: AppPadding.large,
          right: AppPadding.large,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomAppButton(
                onPressed: () {
                  context.pop();
                },
                child: Image.asset(
                  AppImage.icBack,
                  width: 20.w,
                  height: 28.w,
                  color: AppColor.white,
                ),
              ),
              CustomAppButton(
                onPressed: () {
                  context.pop();
                },
                child: Image.asset(
                  AppImage.icBookMark,
                  width: 28.w,
                  height: 28.w,
                  color: AppColor.white,
                ),
              ),
            ],
          ),
        ),
        // Positioned(
        //   bottom: 0,
        //   child: Container(
        //     width: MediaQuery.of(context).size.width,
        //     padding: EdgeInsets.symmetric(
        //       horizontal: AppPadding.large,
        //       vertical: AppPadding.tiny,
        //     ),
        //     decoration: BoxDecoration(
        //       gradient: LinearGradient(
        //         colors: [
        //           AppColor.white,
        //           AppColor.white.withValues(alpha: 0.0),
        //         ],
        //         begin: Alignment.bottomCenter,
        //         end: Alignment.topCenter,
        //       ),
        //     ),
        //     child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.center,
        //       children: [
        //         CustomAppButton(
        //           child: CircleAvatar(
        //             radius: 24.w,
        //             backgroundImage: const AssetImage(AppImage.icPlay),
        //           ),
        //         ),
        //         SizedBox(height: AppPadding.tiny),
        //         Text(
        //           movie.name,
        //           style: TextStyle(
        //             color: AppColor.greyScale900,
        //             fontSize: 24.sp,
        //             fontWeight: FontWeight.w700,
        //           ),
        //           textAlign: TextAlign.center,
        //           maxLines: 2,
        //           overflow: TextOverflow.ellipsis,
        //         ),
        //         SizedBox(height: AppPadding.superTiny),
        //         Row(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: [
        //             Text(
        //               "${movie.year}",
        //               style: TextStyle(
        //                 color: AppColor.greyScale500,
        //                 fontSize: 12.sp,
        //                 fontWeight: FontWeight.w500,
        //               ),
        //             ),
        //             Container(
        //               margin: EdgeInsets.symmetric(
        //                 horizontal: AppPadding.superTiny,
        //               ),
        //               width: 4.w,
        //               height: 4.w,
        //               decoration: BoxDecoration(
        //                 borderRadius:
        //                     BorderRadius.circular(AppPadding.superTiny),
        //                 color: AppColor.greyScale500,
        //               ),
        //             ),
        //             Text(
        //               movie.categories
        //                   .take(2)
        //                   .map((category) => category.name)
        //                   .join(", "),
        //               style: TextStyle(
        //                 color: AppColor.greyScale500,
        //                 fontSize: 12.sp,
        //                 fontWeight: FontWeight.w500,
        //               ),
        //               textAlign: TextAlign.center,
        //               maxLines: 2,
        //               overflow: TextOverflow.ellipsis,
        //             ),
        //             Container(
        //               margin: EdgeInsets.symmetric(
        //                 horizontal: AppPadding.superTiny,
        //               ),
        //               width: 4.w,
        //               height: 4.w,
        //               decoration: BoxDecoration(
        //                 borderRadius:
        //                     BorderRadius.circular(AppPadding.superTiny),
        //                 color: AppColor.greyScale500,
        //               ),
        //             ),
        //             Text(
        //               movie.episodeCurrent,
        //               style: TextStyle(
        //                 color: AppColor.greyScale500,
        //                 fontSize: 12.sp,
        //                 fontWeight: FontWeight.w500,
        //               ),
        //             ),
        //           ],
        //         ),
        //         SizedBox(height: AppPadding.superTiny),
        //         Row(
        //           crossAxisAlignment: CrossAxisAlignment.center,
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: [
        //             Image.asset(
        //               AppImage.icStar,
        //               width: 12.w,
        //               height: 12.w,
        //             ),
        //             Text(
        //               " 4.5",
        //               style: TextStyle(
        //                 color: AppColor.greyScale900,
        //                 fontSize: 12.sp,
        //                 fontWeight: FontWeight.w700,
        //               ),
        //             ),
        //             Text(
        //               " (128 review)",
        //               style: TextStyle(
        //                 color: AppColor.greyScale500,
        //                 fontSize: 12.sp,
        //                 fontWeight: FontWeight.w500,
        //               ),
        //             ),
        //           ],
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }
}

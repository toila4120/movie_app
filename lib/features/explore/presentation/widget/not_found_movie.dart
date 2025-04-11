part of '../../explore.dart';

class NotFoundMovie extends StatelessWidget {
  const NotFoundMovie({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Image.asset(
            AppImage.notFoundMovie,
            width: 200.w,
            height: 200.w,
          ),
          SizedBox(height: AppPadding.tiny),
          Text("Không tìm thấy phim nào",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: AppColor.greyScale500,
              )),
          SizedBox(height: AppPadding.tiny),
          Text("Vui lòng thử lại với từ khóa khác",
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColor.greyScale500,
              )),
        ],
      ),
    );
  }
}

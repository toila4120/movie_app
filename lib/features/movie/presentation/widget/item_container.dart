import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/config/theme/theme.dart';

class ItemContainer extends StatelessWidget {
  final String title;
  const ItemContainer({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24.w,
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.tiny,
        vertical: AppPadding.superTiny,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppBorderRadius.r8.w),
        border: Border.all(
          color: AppColor.primary500,
          width: 1.w,
        ),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.w500,
            color: AppColor.primary500,
          ),
        ),
      ),
    );
  }
}

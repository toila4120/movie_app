import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/config/theme/theme.dart';
import 'package:shimmer/shimmer.dart';

class ItemMovieShimer extends StatelessWidget {
  const ItemMovieShimer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.tiny,
        vertical: AppPadding.tiny,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppBorderRadius.r16),
        color: AppColor.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: SizedBox(
                  height: 88.w,
                  width: 120.w,
                ),
              ),
              Column(
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: SizedBox(
                      height: 20.w,
                      width: 120.w,
                    ),
                  ),
                  SizedBox(height: AppPadding.superTiny),
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: SizedBox(
                      height: 20.w,
                      width: 50.w,
                    ),
                  ),
                  SizedBox(height: AppPadding.superTiny),
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: SizedBox(
                      height: 20.w,
                      width: 100.w,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: SizedBox(
              height: 20.w,
              width: 20.w,
            ),
          ),
        ],
      ),
    );
  }
}

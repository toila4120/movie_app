import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/config/theme/theme.dart';
import 'package:movie_app/core/utils/size_config.dart';

class BottomNavigatorBarItem extends StatelessWidget {
  final String iconPath;
  final String label;
  final VoidCallback onTap;
  final bool isActive;

  const BottomNavigatorBarItem({
    super.key,
    required this.iconPath,
    required this.label,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: AppColor.subsidiaryLight.withValues(alpha: 0.2),
        highlightColor: AppColor.subsidiaryLight.withValues(alpha: 0.1),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 12,
            ),
            Image.asset(
              iconPath,
              width: 20.w,
              height: 20.w,
              color:
                  isActive ? AppColor.primaryLight : AppColor.subsidiaryLight,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                color:
                    isActive ? AppColor.primaryLight : AppColor.subsidiaryLight,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 4,
            ),
          ],
        ),
      ),
    );
  }
}

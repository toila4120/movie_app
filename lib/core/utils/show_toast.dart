import 'package:flutter/material.dart';
import 'package:movie_app/config/theme/theme.dart';
import 'package:movie_app/core/utils/size_config.dart';

void showToast(
  BuildContext context, {
  required String message,
}) {
  if (message.isEmpty) {
    return;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Align(
        alignment: Alignment.center,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: AppPadding.tiny,
            horizontal: AppPadding.small,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppBorderRadius.r60),
            color: AppColor.backgroundShowToast,
          ),
          child: Text(
            message,
            style: TextStyle(
              fontSize: SizeConfig.getResponsive(12),
              color: AppColor.white,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      duration: const Duration(seconds: 3),
    ),
  );
}

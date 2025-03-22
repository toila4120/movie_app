import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_app/config/theme/theme.dart';

/// Go back to previous screen.
void finish(BuildContext context, [Object? result]) {
  if (Navigator.canPop(context)) {
    Navigator.pop(context, result);
  }
}

/// Dark Status Bar
void setDarkStatusBar() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
}

/// Light Status Bar
void setLightStatusBar() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
    ),
  );
}

EdgeInsets headerPadding(BuildContext context) => EdgeInsets.only(
      top: MediaQuery.of(context).padding.top + AppPadding.small,
      bottom: AppPadding.tiny,
      left: AppPadding.medium,
      right: AppPadding.medium,
    );

bool validPhoneNumber(String phoneNumber) {
  return RegExp(r'^(0)?\d{9,11}$').hasMatch(phoneNumber);
}

bool validateEmail(String email) {
  final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{3}$',
  );
  return emailRegex.hasMatch(email);
}

bool validatePassword(String email) {
  final RegExp emailRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
  );
  return emailRegex.hasMatch(email);
}

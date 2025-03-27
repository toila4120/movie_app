import 'package:flutter/widgets.dart';

class SizeConfig {
  static late double screenWidth;
  static late double screenHeight;
  static late double scaleFactor;

  static void init(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    scaleFactor = screenWidth > 600 ? screenWidth / 600 + 0.2 : 1.0;
  }

  static double getResponsive(double base) {
    return base * scaleFactor;
  }
}

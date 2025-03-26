part of "../theme.dart";

abstract class AppPadding {
  const AppPadding._();

  static double superTiny = SizeConfig.getResponsive(4);

  static double tiny = SizeConfig.getResponsive(8.0);

  static double small = SizeConfig.getResponsive(12.0);

  static double medium = SizeConfig.getResponsive(16.0);

  static double large = SizeConfig.getResponsive(20.0);

  static double superLarge = SizeConfig.getResponsive(32.0);
}

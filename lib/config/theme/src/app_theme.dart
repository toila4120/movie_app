part of "../theme.dart";

abstract final class AppTheme {
  const AppTheme();

  static const String fontFamily = "SFProDisplay";

  static const TextTheme _appTextTheme = TextTheme(
    displayLarge: TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeight.w700, // Bold
      fontSize: 32.0,
    ),
    displayMedium: TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeight.w700, // Bold
      fontSize: 24.0,
    ),
    displaySmall: TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeight.w700, // Bold
      fontSize: 20.0,
    ),
    bodyLarge: TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeight.w700, // Bold
      fontSize: 16.0, // Body Large (Bold)
    ),
    bodyMedium: TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeight.w500, // Medium
      fontSize: 16.0, // Body Large (Medium)
    ),
    titleMedium: TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeight.w700, // Bold
      fontSize: 14.0, // Body Medium (Bold)
    ),
    titleSmall: TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeight.w500, // Medium
      fontSize: 14.0, // Body Medium (Medium)
    ),
    bodySmall: TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeight.w700, // Bold
      fontSize: 12.0, // Body Small (Bold)
    ),
    labelSmall: TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeight.w500, // Medium
      fontSize: 12.0, // Body Small (Medium)
    ),
    headlineMedium: TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeight.w600, // Semibold
      fontSize: 10.0, // Body Small (Semibold)
    ),
    headlineSmall: TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeight.w500, // Medium
      fontSize: 10.0, // Body Small (Medium)
    ),
  );

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        primaryColor: AppColor.primaryLight,
        primaryColorDark: AppColor.primaryDark,
        primaryColorLight: AppColor.primaryLight,
        scaffoldBackgroundColor: AppColor.scaffoldLight,
        brightness: Brightness.light,
        fontFamily: fontFamily,
        textTheme: _appTextTheme.apply(
          bodyColor: Colors.black87, // Màu văn bản chính cho theme sáng
          displayColor: Colors.black87,
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: AppColor.primaryLight,
          refreshBackgroundColor: AppColor.primaryLight,
        ),
        textSelectionTheme: const TextSelectionThemeData(
          selectionHandleColor: AppColor.primaryLight,
          selectionColor: AppColor.linearColor,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: TextStyle(
            color: AppColor.primaryLight,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
          unselectedLabelStyle: TextStyle(
            color: AppColor.subsidiaryLight,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
          enableFeedback: false,
          selectedItemColor: AppColor.primaryLight,
          unselectedItemColor: AppColor.subsidiaryLight,
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.pressed)
                  ? AppColor.primaryDark
                  : AppColor.primaryLight,
            ),
            foregroundColor: WidgetStateProperty.all(Colors.white),
            padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(
                horizontal: AppPadding.large,
                vertical: AppPadding.small,
              ),
            ),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            elevation: WidgetStateProperty.all(0),
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColor.divider,
          thickness: 0.5,
        ),
      );

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        primaryColor: AppColor.primaryDark,
        primaryColorDark: AppColor.primaryDark,
        primaryColorLight: AppColor.primaryLight,
        scaffoldBackgroundColor: AppColor.scaffoldDark,
        brightness: Brightness.dark,
        fontFamily: fontFamily,
        textTheme: _appTextTheme.apply(
          bodyColor: Colors.white70, // Màu văn bản chính cho theme tối
          displayColor: Colors.white70,
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: AppColor.primaryLight,
          refreshBackgroundColor: AppColor.primaryLight,
        ),
        textSelectionTheme: const TextSelectionThemeData(
          selectionHandleColor: AppColor.primaryLight,
          selectionColor: AppColor.linearColor,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: TextStyle(
            color: AppColor.primaryLight,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
          unselectedLabelStyle: TextStyle(
            color: AppColor.subsidiaryLight,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
          enableFeedback: false,
          selectedItemColor: AppColor.primaryLight,
          unselectedItemColor: AppColor.subsidiaryLight,
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.pressed)
                  ? AppColor.primaryDark
                  : AppColor.primaryLight,
            ),
            foregroundColor: WidgetStateProperty.all(Colors.white),
            padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(
                horizontal: AppPadding.large,
                vertical: AppPadding.small,
              ),
            ),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            elevation: WidgetStateProperty.all(0),
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColor.divider,
          thickness: 0.5,
        ),
      );
}

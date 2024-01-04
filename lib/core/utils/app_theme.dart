part of 'design_utils.dart';

class AppTheme {
  AppTheme._();

  static const double defaultIconSize = 22;

  static const double defaultElevation = 2;

  static const double appBarHeight = 42;

  static final lightTheme = ThemeData.light().copyWith(
    useMaterial3: true,
    primaryColor: primaryColor,
    primaryColorLight: primaryColor,
    splashColor: transparent,
    scaffoldBackgroundColor: mobileBackgroundColor,
    hintColor: primaryColor.withOpacity(.4),
    iconTheme: const IconThemeData(size: defaultIconSize),
    appBarTheme: AppBarTheme(
      elevation: defaultElevation,
      toolbarHeight: appBarHeight,
      titleTextStyle: AppTextTheme.text16
          .copyWith(color: white, fontWeight: FontWeight.w600),
      backgroundColor: transparent,
    ),
    textSelectionTheme: const TextSelectionThemeData(cursorColor: primaryColor),
    cupertinoOverrideTheme: NoDefaultCupertinoThemeData(
      primaryColor: primaryColor,
      barBackgroundColor: primaryShadowColor,
      scaffoldBackgroundColor: primaryShadowColor,
      textTheme: CupertinoTextThemeData(
        textStyle: AppTextTheme.text14,
        primaryColor: primaryColor,
      ),
    ),
    colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
  );
}

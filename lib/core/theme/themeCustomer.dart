import 'package:flutter/material.dart';
import 'package:music_player/core/constants/appSize.dart';
import 'package:music_player/core/constants/colors.dart';
import 'package:music_player/core/theme/app_theme_extension.dart';

class ThemeCustomer {
  final themelightMode = ThemeData(
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorBtn.backgroundColorBtnWelcommlightMode,
        foregroundColor: ColorBtn.colorTextLightModeBtn,
      ),
    ),
    textTheme: TextTheme(
      displayMedium: TextStyle(
        color: ColorText.colorTextDisplaySmallLightMode,
        fontSize: AppSize.lg,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: TextStyle(
        color: ColorText.colorTextDisplayMediumLightMode,
        fontSize: AppSize.md,
        fontWeight: FontWeight.bold,
      ),
      labelMedium: TextStyle(
        fontSize: AppSize.iconSmall,
        fontWeight: FontWeight.bold,
        color: ColorBtn.colorTextLightModeBtn,
      ),
      labelSmall: TextStyle(
        fontSize: AppSize.sm,
        fontWeight: FontWeight.w100,
        color: Colors.black,
      ),
      titleSmall: TextStyle(
        color: ColorText.colorTextButtonLight,
        fontSize: 18,
        fontWeight: FontWeight.w400,
      ),
      titleMedium: TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    ),
    iconTheme: IconThemeData(color: Colors.black),

    inputDecorationTheme: InputDecorationThemeData(
      filled: true,
      fillColor: Color.fromARGB(78, 15, 15, 15),
      hintStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 16),
      labelStyle: TextStyle(
        color: Color.fromARGB(255, 2, 2, 2),
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Color(0xFF9717D3), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.red, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.red, width: 2),
      ),
      errorStyle: TextStyle(
        color: Colors.redAccent,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
    ),
    extensions: const [
      AppThemeExtension(
        backgroundGradient: GradientColor.backgroundHomeAndWelcomPageLightMode,
      ),
    ],
    appBarTheme: AppBarTheme(
      // backgroundColor: const Color.fromARGB(255, 255, 254, 254),
      actionsPadding: EdgeInsets.all(20),
      iconTheme: IconThemeData(color: const Color.fromARGB(255, 0, 0, 0)),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        iconColor: WidgetStatePropertyAll(Colors.black),
        iconSize: WidgetStatePropertyAll(25),
        backgroundColor: WidgetStatePropertyAll(
          const Color.fromARGB(255, 97, 97, 97),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,

      selectedItemColor: ColorSlaider.backgroundColorSlaiderWelcommPageSelected,

      unselectedItemColor: ColorText.colorTextDisplayMediumLightMode,

      selectedIconTheme: const IconThemeData(size: 24),

      unselectedIconTheme: const IconThemeData(size: 24),

      selectedLabelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),

      unselectedLabelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),

      type: BottomNavigationBarType.fixed,
    ),
  );

  final themedartMode = ThemeData(
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorBtn.backgroundColorBtnWelcommDarkmode,
        foregroundColor: ColorBtn.colorTextDarkModeBtn,
      ),
    ),
    textTheme: TextTheme(
      displayMedium: TextStyle(
        color: ColorText.colorTextDisplaySmallDarMode,
        fontSize: AppSize.lg,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: TextStyle(
        color: ColorText.colorTextDisplayMediumDarkMode,
        fontSize: AppSize.md,
        fontWeight: FontWeight.bold,
      ),
      labelMedium: TextStyle(
        fontSize: AppSize.iconSmall,
        fontWeight: FontWeight.bold,
        color: ColorBtn.colorTextDarkModeBtn,
      ),
      labelSmall: TextStyle(
        fontSize: AppSize.sm,
        fontWeight: FontWeight.w100,
        color: Colors.white,
      ),
      titleSmall: TextStyle(
        color: ColorText.colorTextButtonDark,
        fontSize: 18,
        fontWeight: FontWeight.w400,
      ),
      titleMedium: TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    ),
    iconTheme: IconThemeData(color: Colors.white),
    inputDecorationTheme: InputDecorationThemeData(
      filled: true,
      fillColor: Color.fromARGB(78, 255, 255, 255),
      hintStyle: TextStyle(color: Colors.white, fontSize: 16),
      labelStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Color(0xFF9717D3), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.red, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.red, width: 2),
      ),
      errorStyle: TextStyle(
        color: Colors.redAccent,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
    ),
    extensions: const [
      AppThemeExtension(
        backgroundGradient: GradientColor.backgroundHomeAndWelcomPageDarMode,
      ),
    ],
    appBarTheme: AppBarTheme(
      actionsPadding: EdgeInsets.all(20),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        iconColor: WidgetStatePropertyAll(Colors.white),
        iconSize: WidgetStatePropertyAll(25),
        backgroundColor: WidgetStatePropertyAll(
          const Color.fromARGB(255, 97, 97, 97),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.black,

      selectedItemColor: ColorSlaider.backgroundColorSlaiderWelcommPageSelected,

      unselectedItemColor: ColorText.colorTextDisplayMediumDarkMode,

      selectedIconTheme: const IconThemeData(size: 24),

      unselectedIconTheme: const IconThemeData(size: 24),

      selectedLabelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),

      unselectedLabelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),

      type: BottomNavigationBarType.fixed,
    ),
  );
}

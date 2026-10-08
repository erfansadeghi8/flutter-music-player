import 'package:flutter/material.dart';

//colors for button
class ColorBtn {
  static const Color backgroundColorBtnWelcommDarkmode = Color.fromARGB(
    255,
    0,
    152,
    190,
  );
  static const Color backgroundColorBtnWelcommlightMode = Color.fromARGB(
    255,
    0,
    181,
    226,
  );
  static const Color colorTextLightModeBtn = Color.fromARGB(255, 0, 0, 0);
  static const Color colorTextDarkModeBtn = Color.fromARGB(255, 255, 255, 255);
  static const Color colorNotActiveSwichTimer = Color.fromARGB(220, 92, 92, 92);
}

//colors for Text
class ColorText {
  static const Color colorTextDisplaySmallDarMode = Color.fromARGB(
    255,
    255,
    255,
    255,
  );
  static const Color colorTextDisplaySmallLightMode = Color.fromARGB(
    255,
    0,
    0,
    0,
  );
  static const Color colorTextDisplayMediumLightMode = Color.fromARGB(
    255,
    17,
    17,
    17,
  );
  static const Color colorTextDisplayMediumDarkMode = Color.fromARGB(
    255,
    126,
    126,
    126,
  );
  static const Color colorTextButtonDark = Color.fromARGB(255, 0, 152, 190);
  static const Color colorTextButtonLight = Color.fromARGB(255, 1, 173, 216);
}

//colors for Warning
class Warning {
  static const Color backgroundColorWarningForNameEmpty = Color.fromARGB(
    255,
    150,
    135,
    0,
  );
}

//colors for Slaider
class ColorSlaider {
  static const Color backgroundColorSlaiderWelcommPageSelected = Color.fromARGB(
    255,
    0,
    152,
    190,
  );
  static const Color backgroundColorSlaiderWelcommPageNotSelected =
      Color.fromARGB(137, 168, 168, 168);
}

//colors for Geradient
class GradientColor {
  static const List<Color> backgroundHomeAndWelcomPageDarMode = [
    Color(0xFF020711), // مشکی با ته‌رنگ آبی
    Color(0xFF061225), // سرمه‌ای خیلی تیره
    Color(0xFF00030A), // تقریباً مشکی
    Color(0xFF07172C), // آبی-سرمه‌ای
  ];
  static const List<Color> backgroundHomeAndWelcomPageLightMode = [
    Color(0xFFF5F8FC), // سفید متمایل به آبی
    Color(0xFFEAF2FB), // آبی خیلی روشن
    Color(0xFFFFFFFF), // سفید
    Color(0xFFE8F0F9), // خاکستری-آبی روشن
  ];
}

class BackgrandPageTimer {
  static const List<Color> backgroundTimerDarkMode = [
    Color(0xFF120B2A),
    Color(0xFF1A1240),
    Color(0xFF090617),
    Color(0xFF16102F),
  ];
  static const List<Color> backgroundTimerLightMode = [
    Color(0xFFF4F1FF),
    Color(0xFFEAE5FF),
    Color(0xFFFFFFFF),
    Color(0xFFF0EDFF),
  ];
}

// ignore: camel_case_types
class shadow {
  static const shadowAboutAppDarkMode = Color.fromARGB(255, 253, 253, 253);
  static const shadowAboutAppLightMode = Color.fromARGB(255, 0, 0, 0);
}

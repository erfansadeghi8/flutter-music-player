import 'package:flutter/material.dart';

//colors for button
class ColorBtn {
  static const Color backgroundColorBtnWelcommDarkmode = Color.fromARGB(
    255,
    149,
    32,
    196,
  );
  static const Color backgroundColorBtnWelcommlightMode = Color.fromARGB(
    255,
    208,
    99,
    252,
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
  static const Color colorTextButtonDark = Color.fromARGB(255, 182, 77, 231);
  static const Color colorTextButtonLight = Color.fromARGB(255, 58, 0, 85);
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
    151,
    23,
    211,
  );
  static const Color backgroundColorSlaiderWelcommPageNotSelected =
      Color.fromARGB(137, 168, 168, 168);
}

//colors for Geradient
class GradientColor {
  static const List<Color> backgroundHomeAndWelcomPageDarMode = [
    Color(0xFF040515),
    Color(0xFF0E061E),
    Color(0xFF16082A),
    Color(0xFF050414),
  ];
  static const List<Color> backgroundHomeAndWelcomPageLightMode = [
    Color(0xFFFDF9FF),
    Color(0xFFF6E9FC),
    Color(0xFFEED8F8),
    Color(0xFFE4C4F3),
  ];
}

class BackgrandPageTimer {
  static const List<Color> backgroundTimerDarkMode = [
    Color(0xFF010514), // آبی-بنفش خیلی تیره
    Color(0xFF0D0422), // بنفش تیره
    Color(0xFF1A0A35), // بنفش-آبی
    Color(0xFF0F0630), // بنفش تیره با کمی آبی
  ];
  static const List<Color> backgroundTimerLightMode = [
    Color(0xFFFCF8FF), // کرم مایل به بنفش
    Color(0xFFF5E8FD), // بنفش بسیار ملایم
    Color(0xFFEAD5F7), // بنفش روشن
    Color(0xFFE0C2F0), // بنفش متوسط ملایم
  ];
}

// ignore: camel_case_types
class shadow {
  static const shadowAboutAppDarkMode = Color.fromARGB(255, 253, 253, 253);
  static const shadowAboutAppLightMode = Color.fromARGB(255, 0, 0, 0);
}

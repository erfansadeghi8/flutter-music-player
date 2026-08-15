import 'dart:core';
import 'package:flutter/material.dart';

class AppSize {
  AppSize._(); //private constructor
  /*
  Because we are not going to create an object
  from Appsize. Instead, we want to use the 
  class values ​​directly: 
  */

  static const double xs = 4.0;

  static const double sm = 12.0;

  static const double md = 20.0; // text displaySmall

  static const double lg = 30.0; // text displayMedium

  static const double xl = 32.0;

  static const double xxl = 48.0;

  static const double sizebetweentexts = 20.0; //sizebetweentexts

  static const double circular = 50.0;

  static const double radiusSmall = 8;

  static const double radiusMedium = 12;

  static const double radiusLarge = 20;

  static const double radiusXL = 30;

  static const double radiusXXL = 50;

  static const double iconSmall = 18; // Text Button

  static const double iconMedium = 24;

  static const double iconLarge = 32;

  static const double iconXL = 48;
  static const double fontXS = 10;

  static const double fontSM = 12;

  static const double fontMD = 14;

  static const double fontLG = 16;

  static const double fontlg2 = 18;

  static const double fontXL = 20;

  static const double fontXXL = 28;

  static Size size(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  static double wdith(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double height(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
}

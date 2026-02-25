import 'package:flutter/material.dart';

class AppColors {
  static Color white = Colors.white;
  static Color black = Colors.black;

  static Color primary = const Color(0xFFDEF213);

  static Color background = Colors.black;
  // static Color background = const Color(0xFF0B111E);

  static Color tabBackground = const Color(0xFF262626);

  static Color unselected = const Color(0xFF959595);

  static Color green = const Color(0xFF178B21);
  static Color greenBackground = const Color(0xFFB8EDCE);

  static Color greyGreenBackground = const Color(0xFF4B6040);
  static Color redBackground = const Color(0xFFF0C3C3);

  static Color yellow = const Color(0xFFFFC107);
  static Color red = const Color(0xFFFF0000);

  static const greenYellowGradient = LinearGradient(colors: [Color(0xFFF7FF17), Color(0xFFB1FF1F)]);
  static const colorClosedGreen = Color(0xFF3BB537);

  static Color dullWhite = background;
  static Color lightGrey = const Color(0xffD1D8DD);
  static Color mediumGrey = Colors.grey.shade400;
  static Color darkGrey = const Color(0xff78828A);

  static Color buttonGray = const Color(0xffECF1F6);

  static Color primaryPink = const Color(0xFFDEF213);
  static Color primaryRed = const Color(0xffE53935);
  static Color primaryGreen = const Color(0xff00C566);
  static Color lightBlack = const Color(0xff1D1D2F);
  static Color blackBackground = const Color(0xff171725);
  static Color grayLight = const Color(0xff1E1E1E);

  static const coloGreyText = Color(0xFF8F989F);
  static const colorText = Color(0xFF0C7A68);
  static const lightOrange = Color(0xFFFFE3C9);
  static const orange = Color(0xFFEB9745);
  static const lightGreen = Color(0xFF9FFF82);
  static const lightPrimary = Color(0xFF373737);

  static Color transparent = Colors.transparent;
  static final shimmer = Color(0xFFC1C7E4).withValues(alpha: 0.5);
}

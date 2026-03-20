import 'package:waxxapp/utils/app_constant.dart';
import 'package:flutter/material.dart';

abstract class AppFontStyle {
  static styleW400(Color? color, double? fontSize) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: FontWeight.w400,
      fontFamily: AppConstant.appFontRegular,
    );
  }

  static styleW500(Color? color, double? fontSize, {List<Shadow>? shadows}) {
    return TextStyle(color: color, fontSize: fontSize, fontWeight: FontWeight.w500, fontFamily: AppConstant.appFontRegular, shadows: shadows);
  }

  static styleW600(Color color, double fontSize) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      fontFamily: AppConstant.appFontSemiBold,
    );
  }

  static styleW700(Color? color, double? fontSize, {List<Shadow>? shadows}) {
    return TextStyle(color: color, fontSize: fontSize, fontWeight: FontWeight.w700, fontFamily: AppConstant.appFontBold, shadows: shadows);
  }

  static styleW800(Color? color, double? fontSize) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: FontWeight.w800,
      fontFamily: AppConstant.appFontBold,
    );
  }

  static styleW900(Color? color, double? fontSize) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: FontWeight.w900,
      fontFamily: AppConstant.appFontExtraBold,
    );
  }

  static appBarStyle() {
    return const TextStyle(
      fontSize: 21,
      letterSpacing: 0.4,
      fontFamily: AppConstant.appFontRegular,
      fontWeight: FontWeight.bold,
    );
  }
}

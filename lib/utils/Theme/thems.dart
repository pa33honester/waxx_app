import 'package:waxxapp/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Themes {
  static final light = ThemeData(
    scaffoldBackgroundColor: AppColors.transparent,
    appBarTheme: AppBarTheme(backgroundColor: AppColors.transparent),
  );

  static final darks = ThemeData(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      textTheme: TextTheme(
        bodyMedium: GoogleFonts.plusJakartaSans(color: const Color(0xffffffff)),
      ),
      appBarTheme: const AppBarTheme(iconTheme: IconThemeData(color: Colors.white), color: Color(0xff171725), toolbarTextStyle: TextStyle(color: Colors.white)),
      useMaterial3: false,
      iconTheme: const IconThemeData(color: Colors.white),
      primarySwatch: Colors.pink,
      scaffoldBackgroundColor: AppColors.blackBackground,
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(backgroundColor: Color(0xff171725)));
}

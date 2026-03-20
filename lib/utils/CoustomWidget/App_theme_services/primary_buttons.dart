import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/app_constant.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:google_fonts/google_fonts.dart';

class PrimaryPinkButton extends StatelessWidget {
  final void Function() onTaped;
  final String text;

  const PrimaryPinkButton({
    super.key,
    required this.onTaped,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTaped,
      child: Container(
        height: 58,
        decoration: BoxDecoration(color: AppColors.primaryPink, borderRadius: BorderRadius.circular(30)),
        child: Center(
          child: Text(
            text.toUpperCase(),
            style: AppFontStyle.styleW700(
              AppColors.black,
              16,
            ),
          ),
        ),
      ),
    );
  }
}

class PrimaryWhiteButton extends StatelessWidget {
  final void Function() onTaped;
  final String text;

  const PrimaryWhiteButton({
    super.key,
    required this.onTaped,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTaped,
      child: Container(
        height: 55,
        decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.primaryPink,
            ),
            borderRadius: BorderRadius.circular(24)),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.plusJakartaSans(color: AppColors.primaryPink, fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}

class PrimaryShortWhiteButton extends StatelessWidget {
  final void Function() onTaped;
  final String text;

  const PrimaryShortWhiteButton({
    super.key,
    required this.onTaped,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTaped,
      child: Container(
        height: 37,
        width: Get.width / 3.7,
        decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.primaryPink,
            ),
            borderRadius: BorderRadius.circular(24)),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.plusJakartaSans(color: AppColors.primaryPink, fontSize: 12.5, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}

class PrimaryRoundButton extends StatelessWidget {
  final void Function() onTaped;
  final icon;
  final iconColor;

  const PrimaryRoundButton({
    super.key,
    required this.onTaped,
    required this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTaped,
      child: Container(
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 22,
          color: iconColor,
        ),
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  final void Function() onTaped;
  final text;
  final double weights;
  final containerColor;
  final textColor;

  const FilterButton({
    super.key,
    required this.onTaped,
    required this.text,
    required this.weights,
    required this.containerColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTaped,
      child: Obx(
        () => Container(
          height: 42,
          width: weights,
          decoration: BoxDecoration(border: Border.all(color: containerColor, width: 1), color: isDark.value ? AppColors.blackBackground : const Color(0xffffffff), borderRadius: BorderRadius.circular(50)),
          child: Center(
            child: Text(
              text,
              style: GoogleFonts.plusJakartaSans(color: textColor, fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}

class RatingButton extends StatelessWidget {
  final void Function() onTaped;
  final double weights;
  final containerColor;
  final icons;

  const RatingButton({
    super.key,
    required this.onTaped,
    required this.weights,
    required this.containerColor,
    required this.icons,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTaped,
      child: Container(
        height: 42,
        width: weights,
        decoration: BoxDecoration(border: Border.all(color: containerColor, width: 1), color: Colors.transparent, borderRadius: BorderRadius.circular(50)),
        child: Center(child: icons),
      ),
    );
  }
}

class AppButtonUi extends StatelessWidget {
  const AppButtonUi({
    super.key,
    this.height,
    this.width,
    required this.title,
    this.color,
    this.icon,
    this.gradient,
    required this.callback,
    this.iconSize,
    this.fontSize,
    this.fontColor,
    this.borderColor,
    this.fontWeight,
    this.boxBorder,
    this.iconColor,
  });

  final double? height;
  final double? width;
  final double? iconSize;
  final double? fontSize;
  final String title;
  final Color? color;
  final Color? fontColor;
  final Color? iconColor;
  final Color? borderColor;
  final String? icon;
  final Gradient? gradient;
  final FontWeight? fontWeight;
  final BoxBorder? boxBorder;
  final Callback callback;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: color,
          gradient: gradient,
          border: Border.all(color: borderColor ?? Colors.transparent, width: 1),
        ),
        height: height ?? 56,
        width: width ?? Get.width,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon != null ? Image.asset(icon!, width: iconSize ?? 30, color: iconColor).paddingOnly(right: 10) : const Offstage(),
              Text(
                title,
                style: TextStyle(
                  color: fontColor ?? AppColors.white,
                  fontFamily: AppConstant.appFontBold,
                  fontSize: fontSize ?? 18,
                  letterSpacing: 0.3,
                  fontWeight: fontWeight ?? FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

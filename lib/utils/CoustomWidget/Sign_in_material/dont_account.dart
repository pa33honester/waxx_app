import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:flutter/material.dart';

class DoNotAccount extends StatelessWidget {
  final void Function() onTaped;
  final String tapText;
  final text;
  const DoNotAccount({
    super.key,
    required this.onTaped,
    required this.tapText,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          // style: GoogleFonts.plusJakartaSans(
          //   color: const Color(0xff6C6C6C),
          //   fontWeight: FontWeight.w500,
          // ),
          style: AppFontStyle.styleW600( const Color(0xff6C6C6C), 14),
        ),
        GestureDetector(
          onTap: onTaped,
          child: Text(
            " $tapText",
            // style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, color: AppColors.primaryPink),
         style: AppFontStyle.styleW700(AppColors.primaryPink, 13),
          ),
        ),
      ],
    );
  }
}

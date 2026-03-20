import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

Widget noDataFound({
  required String image,
  String? text,
}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(image, height: 140).paddingOnly(bottom: 20),
        Text(
          text ?? '',
          style: AppFontStyle.styleW600(AppColors.primaryPink, 16),

          // TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.primaryPink),
        ),
      ],
    ),
  );
}

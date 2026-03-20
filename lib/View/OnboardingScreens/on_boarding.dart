import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/all_images.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final pageController = PageController();

List onBoardingImage = [
  onBoardingFst(),
  onBoardingSnd(),
  onBoardingTrd(),
];

onBoardingFst() {
  return Container(
    color: AppColors.black,
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 60),
          child: SizedBox(
            height: Get.height * 0.62,
            width: Get.width,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Image.asset(
                AppImage.entryFst,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        20.height,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  St.onBoardingFstTitle.tr,
                  style: AppFontStyle.styleW900(AppColors.primary, 30),

                ),
              ),
              6.height,
              Text(
                St.onBoardingFstSubtitle.tr,
                textAlign: TextAlign.start,
                style: AppFontStyle.styleW500(AppColors.unselected, 15),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 50,
        ),
      ],
    ),
  );
}

onBoardingSnd() {
  return Container(
    color: AppColors.black,
    child: Column(
      children: [

        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 60),
          child: SizedBox(
            height: Get.height * 0.62,
            width: Get.width,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Image.asset(
                AppImage.entrySecond,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        20.height,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  St.onBoardingSndTitle.tr,
                  style: AppFontStyle.styleW900(AppColors.primary, 28),
                ),
              ),
              6.height,
              Text(
                St.onBoardingSndSubtitle.tr,
                textAlign: TextAlign.start,
                style: AppFontStyle.styleW500(AppColors.unselected, 15),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 50,
        ),
      ],
    ),
  );
}

onBoardingTrd() {
  return Container(
    color: AppColors.black,
    child: Column(
      children: [

        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 60),

          child: SizedBox(
            height: Get.height * 0.62,
            width: Get.width,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Image.asset(
                AppImage.entryThird,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        20.height,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  St.onBoardingTrdTitle.tr,
                  style: AppFontStyle.styleW900(AppColors.primary, 30),
                ),
              ),
              6.height,
              Text(
                St.onBoardingTrdSubtitle.tr,
                textAlign: TextAlign.start,
                style: AppFontStyle.styleW500(AppColors.unselected, 15),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 50,
        ),
      ],
    ),
  );
}

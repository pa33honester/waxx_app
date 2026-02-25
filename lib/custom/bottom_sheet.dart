import 'package:era_shop/custom/circle_button_widget.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/app_asset.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LiveSellingBottomSheet {
  static Future<void> onShow() async {
    await Get.bottomSheet(
      backgroundColor: AppColors.black,
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            20.height,
            Center(
              child: Container(
                height: 3,
                width: 50,
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            10.height,
            Row(
              children: [
                Text(
                  St.searchFilter.tr,
                  style: AppFontStyle.styleW900(AppColors.white, 18),
                ),
                const Spacer(),
                CircleButtonWidget(
                  size: 30,
                  color: AppColors.transparent,
                  callback: Get.back,
                  child: Center(child: Image.asset(AppAsset.icClose, width: 15)),
                ),
              ],
            ),
            10.height,
            Divider(color: AppColors.unselected.withValues(alpha: 0.2)),
            Expanded(
              child: SingleChildScrollView(),
            ),
          ],
        ),
      ),
    );
  }
}

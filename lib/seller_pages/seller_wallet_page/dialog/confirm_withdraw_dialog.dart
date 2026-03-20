import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_asset.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

class ConfirmWithdrawDialogUi {
  static Future<void> onShow(Callback callback) async {
    Get.dialog(
      barrierColor: AppColors.black.withOpacity(0.9),
      Dialog(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        child: Container(
          // height: 400,
          width: 310,
          decoration: BoxDecoration(
            color: AppColors.tabBackground,
            borderRadius: BorderRadius.circular(45),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  10.height,
                  Image.asset(AppAsset.icWithdraw, color: AppColors.red, width: 90),
                  10.height,
                  Text(
                    St.withdraw.tr,
                    style: AppFontStyle.styleW700(AppColors.white, 24),
                  ),
                  10.height,
                  Text(
                    textAlign: TextAlign.center,
                    St.confirmWithdrawDialogText.tr,
                    style: AppFontStyle.styleW400(AppColors.unselected, 12),
                  ),
                  20.height,
                  GestureDetector(
                    onTap: callback,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: AppColors.primary,
                      ),
                      height: 52,
                      width: Get.width,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(St.withdraw.tr, style: AppFontStyle.styleW700(AppColors.black, 16)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  10.height,
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: AppColors.red,
                      ),
                      height: 52,
                      width: Get.width,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(St.cancelText.tr, style: AppFontStyle.styleW700(AppColors.white, 16)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

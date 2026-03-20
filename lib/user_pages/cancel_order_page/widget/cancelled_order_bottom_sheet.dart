import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_asset.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

class CancelledOrderBottomSheet {
  static Future<void> onShow({required Callback callBack}) async {
    Get.dialog(
      barrierColor: AppColors.black.withValues(alpha: 0.9),
      Dialog(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        child: Container(
          height: 450,
          width: 310,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(45),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 170,
                  width: 310,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.red,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(45),
                      topLeft: Radius.circular(45),
                    ),
                  ),
                  child: Image.asset(AppAsset.imgCancelOrder, width: 140),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      10.height,
                      Text(
                        St.orderCancellation.tr,
                        style: AppFontStyle.styleW700(AppColors.red, 16),
                      ),
                      Text(
                        textAlign: TextAlign.center,
                        St.successfully.tr,
                        style: AppFontStyle.styleW900(AppColors.red, 34),
                      ),
                      Text(
                        textAlign: TextAlign.center,
                        St.itIsALongEstablishedFactThat.tr,
                        style: AppFontStyle.styleW500(AppColors.unselected, 12),
                      ),
                      20.height,
                      GestureDetector(
                        onTap: callBack,
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
                                Text(St.viewOrderDetails.tr, style: AppFontStyle.styleW700(AppColors.white, 16)),
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
                            color: AppColors.unselected.withValues(alpha: 0.2),
                          ),
                          height: 52,
                          width: Get.width,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  St.goToHomePage.tr,
                                  style: AppFontStyle.styleW700(AppColors.unselected, 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

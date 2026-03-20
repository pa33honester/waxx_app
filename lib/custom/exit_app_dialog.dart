import 'dart:io';

import 'package:waxxapp/custom/main_button_widget.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExitAppDialog extends StatelessWidget {
  const ExitAppDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: AppColors.tabBackground,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            10.height,
            Text(
              St.exitApp.tr,
              textAlign: TextAlign.center,
              style: AppFontStyle.styleW900(AppColors.white, 20),
            ),
            10.height,
            Text(
              St.exitAppConfirmation.tr,
              textAlign: TextAlign.center,
              style: AppFontStyle.styleW500(AppColors.white, 14),
            ),
            25.height,
            MainButtonWidget(
              height: 50,
              width: Get.width,
              borderRadius: 40,
              child: Text(
                St.cancelSmallText.tr,
                style: AppFontStyle.styleW700(AppColors.black, 16),
              ),
              callback: () {
                Get.back();
                // exitApp = false;
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 10),
              child: GestureDetector(
                onTap: () {
                  // exitApp = true;

                  exit(0);
                  // // Confirm: Close the app
                  // if (Platform.isAndroid) {
                  //   SystemNavigator.pop(); // OR use exit(0);
                  // } else if (Platform.isIOS) {
                  //   exit(0); // force exit on iOS (note: Apple discourages this)
                  // }
                },
                child: Text(
                  St.confirmText.tr,
                  style: AppFontStyle.styleW700(AppColors.white, 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

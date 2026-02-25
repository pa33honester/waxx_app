import 'dart:io';

import 'package:era_shop/custom/main_button_widget.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

class NoInternetDialog extends StatelessWidget {
  const NoInternetDialog({super.key, required this.onRetry});

  final Callback onRetry;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.black,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.wifi_off,
                color: Colors.black,
                size: 40,
              ),
            ),
            SizedBox(height: 20),
            Text(
              St.noInternetConnection.tr,
              textAlign: TextAlign.center,
              style: AppFontStyle.styleW900(AppColors.white, 18),
            ),
            12.height,
            Text(
              St.pleaseCheckYourInternetConnection.tr,
              textAlign: TextAlign.center,
              style: AppFontStyle.styleW500(AppColors.white, 13),
            ),
            24.height,
            MainButtonWidget(
                height: 50,
                width: Get.width,
                borderRadius: 40,
                callback: onRetry,
                child: Text(
                  St.retry.tr,
                  style: AppFontStyle.styleW700(AppColors.black, 16),
                )),
            8.height,
          ],
        ),
      ),
    );
  }
}

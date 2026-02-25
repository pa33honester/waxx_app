import 'dart:async';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class CustomShare {
  static Future onShare({required String title, required String filePath}) async {
    Utils.showLog("Share Method Called Success...");
    Get.dialog(
        Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        barrierDismissible: false); // Start Loading...

    Share.share(title);

    // await FlutterShare.share(title: title, linkUrl: "https://play.google.com/store/apps/details?id=AppPackageName");
    Get.back(); // Stop Loading...
  }

  static Future onShareLink({required String link}) async {
    try {
      Share.share(link);
      Utils.showLog("Share Link Method Called Success...");
    } catch (e) {
      Utils.showLog("Share Link Method Error => $e");
    }
  }

  static Future onShareFile({required String title, required String filePath}) async {
    try {
      Share.shareXFiles([XFile(filePath)], text: title);
      Utils.showLog("Share File Method Called Success...");
    } catch (e) {
      Utils.showLog("Share File Method Error => $e");
    }
  }
}

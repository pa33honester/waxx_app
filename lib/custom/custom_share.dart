import 'dart:async';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class CustomShare {
  // Play Store listing for Waxxapp. Used as the universal share URL now that
  // Branch.io deep linking is disabled — recipients who don't have the app
  // land on the install page instead of a broken `bnc.lt` placeholder link.
  static const String _appStoreUrl =
      "https://play.google.com/store/apps/details?id=com.waxxapp";

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

  // Share a contextual message plus the app store link. `context` is a one-line
  // description ("Sarah's store on Waxxapp", "Check out this auction"); the
  // Play Store URL is always appended so the recipient can install the app.
  static Future onShareApp({String? context, String? subject}) async {
    try {
      final header = (context == null || context.trim().isEmpty)
          ? "Check this out on Waxxapp"
          : context.trim();
      final message = "$header\n$_appStoreUrl";
      await Share.share(message, subject: subject);
    } catch (e) {
      Utils.showLog("Share App Method Error => $e");
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

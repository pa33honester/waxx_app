import 'package:waxxapp/Controller/GetxController/login/apple_login_controller.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/all_images.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Buttons {
  static orContinue() {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 1,
            width: 65,
            color: isDark.value ? AppColors.white : AppColors.darkGrey,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              St.orContinueWith.tr,
              style: AppFontStyle.styleW600(AppColors.darkGrey, 14),
              // style: GoogleFonts.plusJakartaSans(
              //   fontSize: 14,
              //   fontWeight: FontWeight.w500,
              //   color: isDark.value ? AppColors.white : AppColors.darkGrey,
              // ),
            ),
          ),
          Container(
            height: 1,
            width: 65,
            color: isDark.value ? AppColors.white : AppColors.darkGrey,
          ),
        ],
      ),
    );
  }

  static googleButton({required void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55,
        decoration: BoxDecoration(
            border: Border.all(
              color: isDark.value ? AppColors.white : AppColors.black,
            ),
            color: AppColors.grayLight,
            borderRadius: BorderRadius.circular(24)),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Image(
                  image: AssetImage(AppImage.googleIcon),
                  height: 24,
                ),
              ),
              Text(
                St.continueWithGoogle.tr,
                style: AppFontStyle.styleW600(AppColors.white, 14),
                // style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static newButton({required void Function()? onTap, required String? text, String? image}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55,
        decoration: BoxDecoration(
            border: Border.all(
              color: isDark.value ? AppColors.white : AppColors.black,
            ),
            color: AppColors.grayLight,
            borderRadius: BorderRadius.circular(30)),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(color: Color(0xff5B5B5B).withValues(alpha: .29), shape: BoxShape.circle),
                  child: Image(
                    image: AssetImage(image ?? AppImage.googleIcon),
                    height: 24,
                  ),
                ),
                10.width,
                Expanded(
                  child: Text(
                    text ?? '',
                    style: AppFontStyle.styleW600(AppColors.white, 14),
                    // style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static mobileLoginButton({required void Function()? onTap, required String? text, String? image}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55,
        decoration: BoxDecoration(
            border: Border.all(
              color: isDark.value ? AppColors.white : AppColors.black,
            ),
            color: AppColors.grayLight,
            borderRadius: BorderRadius.circular(30)),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Container(
                //   padding: EdgeInsets.all(10),
                //   decoration: BoxDecoration(color: Color(0x5B5B5B4A), shape: BoxShape.circle),
                //   child: Image(
                //     image: AssetImage(image ?? AppImage.googleIcon),
                //     height: 24,
                //   ),
                // ),
                // 10.width,
                Expanded(
                  child: Center(
                    child: Text(
                      text ?? '',
                      style: AppFontStyle.styleW600(AppColors.white, 16),
                      // style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static appleButton() {
    AppleLoginController appleLoginController = Get.put(AppleLoginController());
    return GestureDetector(
      onTap: () async {
        await appleLoginController.loginWithApple();
      },
      child: Container(
        height: 55,
        decoration: BoxDecoration(
            border: Border.all(
              color: isDark.value ? AppColors.white : AppColors.black,
            ),
            color: AppColors.grayLight,
            borderRadius: BorderRadius.circular(30)),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Image(
                  image: AssetImage(AppImage.appleIcon),
                  color: AppColors.white,
                  height: 20,
                ),
              ),
              Text(
                St.continueWithApple.tr,
                style: AppFontStyle.styleW600(AppColors.white, 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static demoLoginButton({required void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55,
        decoration: BoxDecoration(
            border: Border.all(
              color: isDark.value ? AppColors.white : AppColors.black,
            ),
            color: AppColors.grayLight,
            borderRadius: BorderRadius.circular(30)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(7),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(color: Color(0xff5B5B5B).withValues(alpha: .29), shape: BoxShape.circle),
              child: Image(
                image: AssetImage(AppImage.demoIcon),
                height: 20,
                width: 20,
              ),
            ),
            Expanded(
              child: Text(
                St.demoLogIn.tr,
                textAlign: TextAlign.center,
                style: AppFontStyle.styleW600(AppColors.white, 14),
              ),
            ),
            55.width,
          ],
        ),
      ),
    );
  }
}

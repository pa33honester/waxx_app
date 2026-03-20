import 'dart:async';
import 'dart:developer';

import 'package:waxxapp/Controller/GetxController/login/google_login_controller.dart';
import 'package:waxxapp/Controller/GetxController/user/delete_user_account_controller.dart';
import 'package:waxxapp/custom/custom_color_bg_widget.dart';
import 'package:waxxapp/custom/main_button_widget.dart';
import 'package:waxxapp/custom/simple_app_bar_widget.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/Theme/theme_service.dart';
import 'package:waxxapp/utils/app_asset.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:waxxapp/utils/show_toast.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

class SettingView extends StatelessWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    final googleLoginController = Get.put(GoogleLoginController());
    final deleteUserAccountController = Get.put(DeleteUserAccountController());

    Timer(
      const Duration(milliseconds: 300),
      () {
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarColor: AppColors.transparent,
            statusBarIconBrightness: Brightness.light,
          ),
        );
      },
    );

    return CustomColorBgWidget(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.transparent,
            surfaceTintColor: AppColors.transparent,
            flexibleSpace: const SimpleAppBarWidget(title: "Setting"),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                25.height,
                // SettingItemWidget(
                //   title: St.notification.tr,
                //   icon: AppAsset.icNotificationFill,
                //   iconSize: 20,
                // ),
                // 15.height,
                SettingItemWidget(
                  title: St.language.tr,
                  icon: AppAsset.icLanguage,
                  iconSize: 23,
                  callback: () => Get.toNamed("/Language"),
                ),
                15.height,
                SettingItemWidget(
                  title: St.security.tr,
                  icon: AppAsset.icSecurity,
                  iconSize: 23,
                  callback: () => Get.toNamed("/LegalAndPolicies"),
                ),
                15.height,
                SettingItemWidget(
                  title: St.legalAndPolicies.tr,
                  icon: AppAsset.icPolicies,
                  iconSize: 20,
                  callback: () => Get.toNamed("/LegalAndPolicies"),
                ),
                15.height,
                SettingItemWidget(
                  title: St.helpAndSupport.tr,
                  icon: AppAsset.icHelp,
                  iconSize: 28,
                  callback: () => Get.toNamed("/HelpAndSupport"),
                ),
                15.height,

                MainButtonWidget(
                  height: 60,
                  width: Get.width,
                  borderRadius: 15,
                  padding: const EdgeInsets.all(5),
                  color: AppColors.tabBackground,
                  callback: () async {
                    Get.defaultDialog(
                      backgroundColor: AppColors.tabBackground,
                      title: "",
                      titlePadding: EdgeInsets.zero,
                      titleStyle: AppFontStyle.styleW600(AppColors.white, 18),
                      radius: 30,
                      content: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              10.height,
                              Text(
                                St.logOutAccount.tr,
                                textAlign: TextAlign.center,
                                style: AppFontStyle.styleW800(AppColors.white, 20),
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
                                callback: () => Get.back(),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20, bottom: 10),
                                child: GestureDetector(
                                  onTap: () async {
                                    googleLoginController.googleUser == null ? googleLoginController.logOut() : null;
                                    Get.offAllNamed("/SignIn");
                                    getStorage.erase();
                                    isDemoSeller = false;
                                    isSellerRequestSand = false;
                                    isSeller = false;
                                    sellerId = '';
                                    imageXFile = null;
                                  },
                                  child: Text(
                                    St.logout.tr,
                                    style: AppFontStyle.styleW700(AppColors.white, 16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );

                    // googleLoginController.googleUser == null ? googleLoginController.logOut() : null;
                    // Get.offAllNamed("/SignIn");
                    // getStorage.erase();
                    // isDemoSeller = false;
                    // isSellerRequestSand = false;
                    // becomeSeller = false;
                  },
                  child: Row(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Image.asset(AppAsset.icLogout, width: 22, color: AppColors.black),
                      ),
                      15.width,
                      Text(
                        St.logout.tr,
                        style: AppFontStyle.styleW700(AppColors.white, 16),
                      ),
                    ],
                  ),
                ),
                15.height,
                getStorage.read("isDemoLogin") ?? false || isDemoSeller
                    ? SizedBox.shrink()
                    : MainButtonWidget(
                        height: 60,
                        width: Get.width,
                        borderRadius: 15,
                        padding: const EdgeInsets.all(5),
                        color: AppColors.red,
                        callback: () {
                          Get.defaultDialog(
                            backgroundColor: AppColors.tabBackground,
                            title: "",
                            titlePadding: EdgeInsets.zero,
                            titleStyle: AppFontStyle.styleW600(AppColors.white, 18),
                            radius: 30,
                            content: Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    10.height,
                                    Image.asset(AppAsset.icRemove, fit: BoxFit.cover, height: 50, width: 50),
                                    30.height,
                                    Text(
                                      St.deleteAccount.tr,
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
                                      callback: () => Get.back(),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20, bottom: 10),
                                      child: GestureDetector(
                                        onTap: (getStorage.read("isDemoLogin") ?? false || isDemoSeller == true)
                                            ? () => displayToast(message: St.thisIsDemoUser.tr)
                                            : () async {
                                                log("UserId ::: $loginUserId");
                                                await deleteUserAccountController.deleteAccount(loginUserId);
                                              },
                                        child: Text(
                                          St.removeAccount.tr,
                                          style: AppFontStyle.styleW700(AppColors.red, 16),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Image.asset(AppAsset.icRemove, width: 22, color: AppColors.red),
                            ),
                            15.width,
                            Text(
                              St.removeAccount.tr,
                              style: AppFontStyle.styleW700(AppColors.white, 16),
                            ),
                          ],
                        ),
                      ),
                15.height,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SettingItemWidget extends StatelessWidget {
  const SettingItemWidget({super.key, required this.title, required this.icon, this.child, this.callback, required this.iconSize});

  final String title;
  final String icon;
  final Widget? child;
  final Callback? callback;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return MainButtonWidget(
      height: 60,
      width: Get.width,
      borderRadius: 15,
      padding: const EdgeInsets.all(5),
      color: AppColors.tabBackground,
      callback: callback,
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset(icon, width: iconSize, color: AppColors.black),
          ),
          15.width,
          Text(
            title,
            style: AppFontStyle.styleW700(AppColors.white, 16),
          ),
          10.width,
          const Spacer(),
          child ?? Image.asset(AppAsset.icArrowRight, width: 10, color: AppColors.unselected),
          15.width,
        ],
      ),
    );
  }
}

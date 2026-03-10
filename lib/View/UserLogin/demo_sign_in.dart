import 'dart:io';

import 'package:era_shop/View/UserLogin/mobile_login/controller/mobile_login_controller.dart';
import 'package:era_shop/View/UserLogin/mobile_login/view/mobile_login_screen.dart';
import 'package:era_shop/custom/exit_app_dialog.dart';
import 'package:era_shop/utils/CoustomWidget/Sign_in_material/dont_account.dart';
import 'package:era_shop/utils/CoustomWidget/Sign_in_material/other_button.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/Theme/theme_service.dart';
import 'package:era_shop/utils/all_images.dart';
import 'package:era_shop/utils/app_asset.dart';
import 'package:era_shop/utils/app_circular.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

import '../../Controller/ApiControllers/seller/api_seller_data_controller.dart';
import '../../Controller/GetxController/login/google_login_controller.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  SellerDataController sellerDataController = Get.put(SellerDataController());
  GoogleLoginController googleLoginController = Get.put(GoogleLoginController());
  MobileLoginController mobileLoginController = Get.put(MobileLoginController());

  RxBool demoLoginLoading = false.obs;
  RxBool demoUserLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        showDialog(
          context: context,
          builder: (context) => const ExitAppDialog(),
        );
        if (didPop) {
          return;
        }
      },
      child: Stack(
        children: [
          Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: AppColors.primaryPink,
            body: SafeArea(
              child: SizedBox(
                height: Get.height,
                width: Get.width,
                child: Column(
                  children: [
                    SizedBox(
                      height: Get.height / 15,
                    ),
                    Text(
                      St.welcomeTitle.tr,
                      style: AppFontStyle.styleW800(AppColors.black, 25),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        St.welcomeSubtitle.tr,
                        style: AppFontStyle.styleW800(AppColors.black, 14),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: AlignmentDirectional.bottomCenter,
                        child: Obx(
                          () => Container(
                            height: Get.height / (1.4) + 15,
                            width: Get.width,
                            decoration: BoxDecoration(color: AppColors.black, borderRadius: const BorderRadius.vertical(top: Radius.circular(30))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: SizedBox(
                                child: SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 40,
                                      ),
                                      const PhoneNoTextField(),
                                      16.height,
                                      GestureDetector(
                                        onTap: () {
                                          mobileLoginController.sendOtp();
                                        },
                                        child: Container(
                                          height: 55,
                                          decoration: BoxDecoration(
                                            color: AppColors.primary,
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                AppImage.mobileIcon,
                                                height: 22,
                                              ),
                                              10.width,
                                              Text(
                                                St.mobileLogin.tr,
                                                style: AppFontStyle.styleW700(AppColors.black, 16),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 35),
                                        child: Buttons.orContinue(),
                                      ),
                                      16.height,
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Buttons.newButton(
                                              onTap: () {
                                                Get.toNamed("/SignInEmail");
                                              },
                                              image: AppImage.messageWhite,
                                              text: "Email Login",
                                            ),
                                          ),
                                          10.width,
                                          Expanded(
                                            child: Buttons.newButton(
                                              image: AppImage.googleIcon,
                                              onTap: () {
                                                googleLoginController.googleLogin();
                                              },
                                              text: St.googleLogIn.tr,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Platform.isIOS
                                          ? Padding(
                                              padding: const EdgeInsets.only(top: 15),
                                              child: Buttons.appleButton(),
                                            )
                                          : const SizedBox(),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 30),
                                        child: DoNotAccount(
                                          onTaped: () {
                                            Get.toNamed("/SignUp");
                                          },
                                          tapText: St.signUpText.tr,
                                          text: St.donHaveAccount.tr,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Obx(() => sellerDataController.loadingForDemoSeller.value || googleLoginController.isLoading.value || demoLoginLoading.value || demoUserLoading.value ? ScreenCircular.blackScreenCircular() : const SizedBox.shrink())
        ],
      ),
    );
  }
}

class LoginSuccessUi {
  static Future<void> onShow({required Callback callBack}) async {
    Get.dialog(
      barrierColor: AppColors.black.withValues(alpha: 0.9),
      Dialog(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        child: Container(
          // height: 390,
          width: 310,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(45),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 170,
                  width: 310,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.primaryPink,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(45),
                      topLeft: Radius.circular(45),
                    ),
                  ),
                  child: Image.asset(AppAsset.icLoginSuccess, width: 140),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      10.height,
                      Text(
                        St.loginSuccess.tr,
                        textAlign: TextAlign.center,
                        style: AppFontStyle.styleW800(AppColors.black, 26),
                      ),
                      Text(
                        textAlign: TextAlign.center,
                        St.loginLine.tr,
                        style: AppFontStyle.styleW600(AppColors.unselected, 12),
                      ),
                      // Text(
                      //   textAlign: TextAlign.center,
                      //   St.itIsLongEstablished.tr,
                      //   style: AppFontStyle.styleW500(AppColors.unselected, 12),
                      // ),
                      20.height,
                      GestureDetector(
                        onTap: callBack,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: AppColors.primaryPink,
                          ),
                          height: 52,
                          width: Get.width,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(St.continueText.tr, style: AppFontStyle.styleW700(AppColors.black, 16)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      15.height,
                      // GestureDetector(
                      //   onTap: () => Get.back(),
                      //   child: Container(
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(100),
                      //       color: AppColors.unselected.withValues(alpha:0.2),
                      //     ),
                      //     height: 52,
                      //     width: Get.width,
                      //     child: Center(
                      //       child: Row(
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //           Text(St.goToHomePage.tr,
                      //               style: AppFontStyle.styleW700(
                      //                   AppColors.unselected, 16)),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
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

import 'package:waxxapp/custom/simple_app_bar_widget.dart';
import 'package:waxxapp/utils/CoustomWidget/Sign_in_material/common_sign_in_button.dart';
import 'package:waxxapp/utils/CoustomWidget/Sign_in_material/dont_account.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

import '../../../../Controller/GetxController/user/UserPasswordManage/user_password_controller.dart';
import '../../../../utils/app_circular.dart';

// ignore: must_be_immutable
class UserEnterOtp extends StatelessWidget {
  UserEnterOtp({super.key});
  UserPasswordController userPasswordController = Get.put(UserPasswordController());
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: AppColors.transparent,
              shadowColor: AppColors.black.withValues(alpha: 0.4),
              flexibleSpace: SimpleAppBarWidget(title: St.enterOTP.tr),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(left: Get.width / 20, right: Get.width / 20),
              child: SizedBox(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      // Row(
                      //   children: [
                      //     SignInBackButton(
                      //       onTaped: () {
                      //         Get.back();
                      //       },
                      //     ),
                      //   ],
                      // ),
                      // SizedBox(
                      //   height: Get.height / 15,
                      // ),
                      // Obx(
                      //   () => Text(
                      //     St.enterOTP.tr,
                      //     style: isDark.value ? SignInTitleStyle.whiteTitle : SignInTitleStyle.blackTitle,
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: SizedBox(
                          width: Get.width / 1.3,
                          height: 40,
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: "${St.otpSubtitleEmail.tr} ",
                              style: AppFontStyle.styleW500(AppColors.unselected, 14),
                              children: <TextSpan>[
                                TextSpan(
                                  text: userPasswordController.enterEmail.text,
                                  style: AppFontStyle.styleW700(AppColors.white, 14),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 45),
                        child: GetBuilder<UserPasswordController>(
                          builder: (controller) => Pinput(
                            controller: userPasswordController.verifyOtpText,
                            // separator: const SizedBox(
                            //   width: 20,
                            // ),
                            keyboardType: TextInputType.number,
                            cursor: Container(
                              height: 23,
                              width: 2,
                              color: AppColors.primaryPink,
                            ),
                            submittedPinTheme: PinTheme(
                              height: 55,
                              width: 55,
                              textStyle: AppFontStyle.styleW700(AppColors.white, 15),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(12)),
                                color: AppColors.tabBackground,
                              ),
                            ),
                            defaultPinTheme: PinTheme(
                              height: 55,
                              width: 55,
                              textStyle: AppFontStyle.styleW700(AppColors.white, 15),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(12)),
                                color: AppColors.tabBackground,
                              ),
                            ),
                            followingPinTheme: PinTheme(
                              height: 55,
                              width: 55,
                              textStyle: AppFontStyle.styleW700(AppColors.white, 15),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(12)),
                                color: AppColors.tabBackground,
                              ),
                            ),
                          ),
                        ),
                      ),
                      CommonSignInButton(
                          onTaped: () {
                            userPasswordController.verifyOtp();
                          },
                          text: St.continueText.tr),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 25),
                        child: DoNotAccount(
                            onTaped: () {
                              userPasswordController.resendOtpByUser();
                            },
                            tapText: St.resendCodeText.tr,
                            text: St.donReceiveCode.tr),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Obx(
          () => userPasswordController.verifyOtpLoading.value || userPasswordController.resendOtpLoading.value
              ? ScreenCircular.blackScreenCircular()
              : const SizedBox(),
        ),
      ],
    );
  }
}

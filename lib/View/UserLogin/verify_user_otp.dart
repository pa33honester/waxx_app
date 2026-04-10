// ignore_for_file: must_be_immutable

import 'package:waxxapp/Controller/GetxController/login/user_login_controller.dart';
import 'package:waxxapp/utils/CoustomWidget/Sign_in_material/common_sign_in_button.dart';
import 'package:waxxapp/utils/CoustomWidget/Sign_in_material/sign_in_back_button.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

import '../../Controller/GetxController/login/verify_user_otp_controller.dart';
import '../../utils/app_circular.dart';

class VerifyUserOtp extends StatelessWidget {
  final String pageIs;
  UserLoginController userLoginController = Get.put(UserLoginController());
  UserVerifyOtpController userVerifyOtpController = Get.put(UserVerifyOtpController());
  VerifyUserOtp({super.key, required this.pageIs});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
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
                      Row(
                        children: [
                          SignInBackButton(
                            onTaped: () {
                              Get.back();
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: Get.height / 15,
                      ),
                      Text(
                        St.enterOTP.tr,
                        style: AppFontStyle.styleW600(AppColors.white, 20),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: SizedBox(
                          width: Get.width / 1.3,
                          height: 40,
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(text: "${St.otpSubtitleEmail.tr} ", style: GoogleFonts.plusJakartaSans(color: AppColors.darkGrey), children: <TextSpan>[
                              TextSpan(
                                text: userLoginController.eMailController.text,
                                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, color: AppColors.white),
                              ),
                            ]),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 45),
                        child: GetBuilder<UserLoginController>(
                          builder: (controller) => Pinput(
                            controller: userVerifyOtpController.verifyOtpWhenLogin,
                            keyboardType: TextInputType.number,
                            cursor: Container(
                              height: 23,
                              width: 2,
                              color: AppColors.primaryPink,
                            ),
                            submittedPinTheme: PinTheme(
                              height: 55,
                              width: 55,
                              textStyle: GoogleFonts.plusJakartaSans(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 2,
                                  color: AppColors.primaryPink,
                                ),
                                borderRadius: const BorderRadius.all(Radius.circular(20)),
                                color: isDark.value ? AppColors.blackBackground : AppColors.white,
                              ),
                            ),
                            defaultPinTheme: PinTheme(
                              height: 55,
                              width: 55,
                              textStyle: GoogleFonts.plusJakartaSans(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: AppColors.primaryPink,
                                ),
                                borderRadius: const BorderRadius.all(Radius.circular(20)),
                                color: isDark.value ? AppColors.blackBackground : AppColors.white,
                              ),
                            ),
                            followingPinTheme: PinTheme(
                              height: 55,
                              width: 55,
                              textStyle: GoogleFonts.plusJakartaSans(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: AppColors.primaryPink,
                                ),
                                borderRadius: const BorderRadius.all(Radius.circular(20)),
                                color: isDark.value ? AppColors.blackBackground : AppColors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      CommonSignInButton(
                          onTaped: () {
                            userVerifyOtpController.verifyOtp(
                                email: pageIs == "SignUp" ? userLoginController.eMailController.text : userLoginController.signInEMailController.text,
                                password: pageIs == "SignUp" ? userLoginController.passwordController.text : userLoginController.signInPasswordController.text,
                                otp: userVerifyOtpController.verifyOtpWhenLogin.text,
                                pageIs: pageIs);
                          },
                          text: St.continueText.tr),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 25),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  St.donReceiveCode.tr,
                                  style: GoogleFonts.plusJakartaSans(
                                    color: const Color(0xff6C6C6C),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Obx(
                                  () => GestureDetector(
                                    onTap: () => pageIs == "SignUp" ? userLoginController.resendOtpWhenUserSignUp() : userLoginController.resendOtpWhenUserSignIn(),
                                    child: userLoginController.resendCodeLoading.value
                                        ? CupertinoActivityIndicator(color: AppColors.primaryPink)
                                        : Text(
                                            St.resendCodeText.tr,
                                            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, color: AppColors.primaryPink),
                                          ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Obx(() => userVerifyOtpController.verifyOtpLoading.value ? ScreenCircular.blackScreenCircular() : const SizedBox())
      ],
    );
  }
}

import 'dart:developer';

import 'package:waxxapp/Controller/GetxController/login/verify_user_otp_controller.dart';
import 'package:waxxapp/custom/custom_color_bg_widget.dart';
import 'package:flutter/material.dart';
import 'package:waxxapp/Controller/GetxController/seller/seller_common_controller.dart';
import 'package:waxxapp/custom/main_button_widget.dart';
import 'package:waxxapp/custom/simple_app_bar_widget.dart';
import 'package:waxxapp/utils/CoustomWidget/Sign_in_material/dont_account.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/show_toast.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

class SellerEmailVerify extends StatelessWidget {
  SellerEmailVerify({super.key});

  UserVerifyOtpController userVerifyOtpController = Get.put(UserVerifyOtpController());
  SellerCommonController sellerCommonController = Get.put(SellerCommonController());
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return CustomColorBgWidget(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.transparent,
            surfaceTintColor: AppColors.transparent,
            flexibleSpace: SimpleAppBarWidget(title: St.verifyDetails.tr),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              15.height,
              Text(
                St.enterOTP.tr,
                style: AppFontStyle.styleW900(AppColors.primary, 20),
              ),
              15.height,
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: SizedBox(
                  width: Get.width / 1.3,
                  height: 40,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(text: "${St.otpSubtitleEmail.tr} ", style: GoogleFonts.plusJakartaSans(color: AppColors.darkGrey), children: <TextSpan>[
                      TextSpan(
                        text: sellerCommonController.emailController.text,
                        style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, color: AppColors.white),
                      ),
                    ]),
                  ),
                ),
              ),
              50.height,
              Pinput(
                length: 4,
                keyboardType: TextInputType.number,
                cursor: Container(
                  height: 23,
                  width: 2,
                  color: AppColors.primaryPink,
                ),
                submittedPinTheme: PinTheme(
                  height: 50,
                  width: 50,
                  textStyle: AppFontStyle.styleW700(AppColors.white, 18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.tabBackground,
                  ),
                ),
                defaultPinTheme: PinTheme(
                  height: 50,
                  width: 50,
                  textStyle: AppFontStyle.styleW700(AppColors.white, 18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.tabBackground,
                  ),
                ),
                controller: sellerCommonController.otpController,
                followingPinTheme: PinTheme(
                  height: 50,
                  width: 50,
                  textStyle: AppFontStyle.styleW700(AppColors.white, 18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.tabBackground,
                  ),
                ),
              ),
              25.height,
              DoNotAccount(
                  onTaped: () async {
                    await resendOtp();
                  },
                  tapText: St.resendCodeText.tr,
                  text: St.donReceiveCode.tr),
            ],
          ),
        ),
        bottomNavigationBar: MainButtonWidget(
          height: 55,
          width: Get.width,
          margin: const EdgeInsets.all(15),
          color: AppColors.primary,
          child: Text(
            St.continueText.tr.toUpperCase(),
            style: AppFontStyle.styleW700(AppColors.black, 16),
          ),
          callback: () async {
            try {
              Get.dialog(
                Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                ),
                barrierDismissible: false,
              );
              PhoneAuthCredential credential = PhoneAuthProvider.credential(
                verificationId: SellerCommonController.otpVerificationId,
                smsCode: sellerCommonController.otpController.text,
              );
              await auth.signInWithCredential(credential);
              Get.toNamed("/SellerStoreDetails");
              // Get.toNamed("/SellerAddressDetails");
            } catch (e) {
              Get.toNamed("/SellerStoreDetails");
              if (e is FirebaseAuthException) {
                if (e.code == 'invalid-verification-code') {
                  displayToast(message: St.invalidOTP.tr);
                } else {
                  log('Firebase Auth Exception: ${e.code}');
                }
              } else {
                log('Unexpected error: $e');
              }
            }
          },
        ),
      ),
    );
  }

  Future<void> resendOtp() async {
    try {
      Get.dialog(
        Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        ),
        barrierDismissible: false,
      );
      sellerCommonController.otpController.clear();
      await userVerifyOtpController.getOtp(email: sellerCommonController.emailController.text);
      userVerifyOtpController.userSandOtp!.status == true ? Get.toNamed("/SellerStoreDetails") : displayToast(message: St.invalidEmail.tr);
    } catch (e) {
      Get.back();
    } finally {
      Get.back();
    }
  }
}

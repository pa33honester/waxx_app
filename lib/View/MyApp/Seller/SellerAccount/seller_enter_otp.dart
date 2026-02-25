import 'dart:developer';

import 'package:era_shop/Controller/GetxController/seller/seller_common_controller.dart';
import 'package:era_shop/custom/custom_color_bg_widget.dart';
import 'package:era_shop/custom/main_button_widget.dart';
import 'package:era_shop/custom/simple_app_bar_widget.dart';
import 'package:era_shop/utils/CoustomWidget/Sign_in_material/dont_account.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:era_shop/utils/show_toast.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

// ignore: must_be_immutable
class SellerEnterOtp extends StatefulWidget {
  const SellerEnterOtp({super.key});

  @override
  State<SellerEnterOtp> createState() => _SellerEnterOtpState();
}

class _SellerEnterOtpState extends State<SellerEnterOtp> {
  SellerCommonController sellerController = Get.put(SellerCommonController());

  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    String otpCode = "";
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
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: "${St.otpSubtitlePhone.tr}\n",
                  style: TextStyle(color: AppColors.unselected, fontSize: 12, height: 1.5),
                  children: <TextSpan>[
                    TextSpan(
                      text: "${sellerController.countryCode} ${sellerController.phoneController.text}",
                      style: AppFontStyle.styleW700(AppColors.white, 12),
                    ),
                  ],
                ),
              ),
              50.height,
              Pinput(
                onChanged: (value) {
                  otpCode = value;
                },
                length: 6,
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
              // CommonSignInButton(
              //     onTaped: () async {
              //       try {
              //         PhoneAuthCredential credential = PhoneAuthProvider.credential(
              //           verificationId: SellerCommonController.otpVerificationId,
              //           smsCode: otpCode,
              //         );
              //         await auth.signInWithCredential(credential);
              //         Get.toNamed("/SellerAddressDetails");
              //       } catch (e) {
              //         if (e is FirebaseAuthException) {
              //           if (e.code == 'invalid-verification-code') {
              //             displayToast(message: St.invalidOTP.tr);
              //           } else {
              //             log('Firebase Auth Exception: ${e.code}');
              //           }
              //         } else {
              //           log('Unexpected error: $e');
              //         }
              //       }
              //     },
              //     text: St.continueText.tr),
              25.height,
              DoNotAccount(
                  onTaped: () async {
                    displayToast(message: St.pleaseWaitToast.tr);
                    await FirebaseAuth.instance.verifyPhoneNumber(
                      phoneNumber: "+${sellerController.countryCode} ${sellerController.mobileNumberController.text}",
                      verificationCompleted: (PhoneAuthCredential credential) {
                        Get.toNamed("/SellerAddressDetails");
                      },
                      verificationFailed: (FirebaseAuthException e) {
                        log("verification Failed Error :: $e");
                        displayToast(message: "Mobile Verification Failed");
                      },
                      codeSent: (String verificationId, int? resendToken) {
                        displayToast(message: St.otpSendSuccessfully.tr);
                      },
                      codeAutoRetrievalTimeout: (String verificationId) {},
                    );
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
                smsCode: otpCode,
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
}

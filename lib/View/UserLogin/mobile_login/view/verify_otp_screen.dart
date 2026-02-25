import 'package:era_shop/View/UserLogin/mobile_login/controller/mobile_login_controller.dart';
import 'package:era_shop/custom/main_button_widget.dart';
import 'package:era_shop/custom/simple_app_bar_widget.dart';
import 'package:era_shop/utils/CoustomWidget/Sign_in_material/dont_account.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({super.key});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final controller = Get.find<MobileLoginController>();

  @override
  Widget build(BuildContext context) {
    controller.otpController.clear();
    return Scaffold(
      backgroundColor: AppColors.black,
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
            GetBuilder<MobileLoginController>(builder: (logic) {
              return RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: "${St.otpSubtitlePhone.tr}\n",
                  style: AppFontStyle.styleW500(AppColors.unselected, 12),
                  children: <TextSpan>[
                    TextSpan(
                      text: "$dialCode ${logic.numberController.text}",
                      style: AppFontStyle.styleW700(AppColors.white, 13),
                    ),
                  ],
                ),
              );
            }),
            50.height,
            GetBuilder<MobileLoginController>(builder: (logic) {
              return Pinput(
                length: 6,
                keyboardType: TextInputType.number,
                cursor: Container(
                  height: 23,
                  width: 2,
                  color: AppColors.primaryPink,
                ),
                controller: logic.otpController,
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
              );
            }),
            25.height,
            GetBuilder<MobileLoginController>(builder: (logic) {
              return DoNotAccount(
                  onTaped: () async {
                    logic.onResendOtpClick();
                  },
                  tapText: St.resendCodeText.tr,
                  text: St.donReceiveCode.tr);
            }),
          ],
        ),
      ),
      bottomNavigationBar: GetBuilder<MobileLoginController>(builder: (logic) {
        return MainButtonWidget(
          height: 55,
          width: Get.width,
          margin: const EdgeInsets.all(15),
          color: AppColors.primary,
          child: Text(
            St.continueText.tr.toUpperCase(),
            style: AppFontStyle.styleW700(AppColors.black, 16),
          ),
          callback: () {
            logic.verifyOtp();
          },
        );
      }),
    );
  }
}

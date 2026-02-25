import 'dart:developer';

import 'package:era_shop/View/UserLogin/mobile_login/controller/mobile_login_controller.dart';
import 'package:era_shop/main.dart';
import 'package:era_shop/utils/CoustomWidget/Sign_in_material/common_sign_in_button.dart';
import 'package:era_shop/utils/CoustomWidget/Sign_in_material/sign_in_back_button.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/Zego/ZegoUtils/device_orientation.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class MobileLoginScreen extends StatelessWidget {
  MobileLoginScreen({super.key});

  final controller = Get.put(MobileLoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: Get.width / 20, right: Get.width / 20),
          child: Column(
            children: [
              15.height,
              Row(
                children: [
                  SignInBackButton(onTaped: () {
                    Get.back();
                  })
                ],
              ),
              SizedBox(
                height: Get.height / 15,
              ),
              Text(St.loginWithMobile.tr, style: AppFontStyle.styleW700(AppColors.white, 20)),
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: SizedBox(
                  width: Get.width / 1.3,
                  height: 40,
                  child: Text(
                    St.enterYourMobileNumberToReceiveAVerificationCode.tr,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(color: AppColors.unselected),
                  ),
                ),
              ),
              40.height,
              PhoneNoTextField(),
              Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: GetBuilder<MobileLoginController>(
                  builder: (logic) {
                    return CommonSignInButton(
                        onTaped: () {
                          logic.sendOtp();
                        },
                        text: St.sendOtp.tr);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PhoneNoTextField extends StatelessWidget {
  const PhoneNoTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          St.contactNumber.tr,
          style: AppFontStyle.styleW500(AppColors.unselected, 12),
        ),
        10.height,
        GetBuilder<MobileLoginController>(builder: (logic) {
          return IntlPhoneField(
            onCountryChanged: (value) {
              log("Country Code => ${value.dialCode}");
              dialCode = value.dialCode;
              countryCode = value.code;
              getDialCode();
              // logic.phoneFirstDigit = "+${value.dialCode}";
            },
            flagsButtonPadding: const EdgeInsets.all(8),
            dropdownIconPosition: IconPosition.trailing,
            controller: logic.numberController,
            obscureText: false,
            cursorColor: AppColors.unselected,
            dropdownTextStyle: AppFontStyle.styleW700(AppColors.white, 15),
            keyboardType: TextInputType.number,
            showCountryFlag: true,
            style: AppFontStyle.styleW600(AppColors.white, 16),
            dropdownIcon: Icon(
              Icons.arrow_drop_down,
              color: AppColors.white,
            ),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              hintStyle: AppFontStyle.styleW600(AppColors.black, 16),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.transparent),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppColors.transparent,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppColors.transparent,
                ),
              ),
              filled: true,
              fillColor: AppColors.tabBackground,
              errorStyle: AppFontStyle.styleW700(AppColors.red, 10),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppColors.red,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppColors.transparent,
                ),
              ),
              counterStyle: AppFontStyle.styleW700(Colors.red, 12),
            ),
            initialCountryCode: countryCode,
          );
        }),
      ],
    );
  }
}

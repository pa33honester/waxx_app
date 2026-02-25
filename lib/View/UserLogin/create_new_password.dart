// ignore_for_file: must_be_immutable

import 'package:era_shop/Controller/GetxController/login/user_login_controller.dart';
import 'package:era_shop/utils/CoustomWidget/Sign_in_material/common_sign_in_button.dart';
import 'package:era_shop/utils/CoustomWidget/Sign_in_material/common_sign_in_passwordfield.dart';
import 'package:era_shop/utils/CoustomWidget/Sign_in_material/sign_in_back_button.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateNewPassword extends StatelessWidget {
  UserLoginController userLoginController = Get.put(UserLoginController());

  CreateNewPassword({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: Get.width / 20, right: Get.width / 20),
          child: SizedBox(
            child: Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    SignInBackButton(onTaped: () {
                      Get.back();
                    })
                  ],
                ),
                SizedBox(
                  height: Get.height / 26,
                ),
                Text(St.createNewPassword.tr, textAlign: TextAlign.center, style: AppFontStyle.styleW600(AppColors.white, 18)),
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: SizedBox(
                    width: Get.width / 1.3,
                    height: 40,
                    child: Text(
                      St.createNewPasswordSubtitle.tr,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(color: AppColors.darkGrey),
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    child: CommonSignInPasswordField(
                      titleText: St.newPasswordTextFieldTitle.tr,
                      hintText: St.newPasswordTextFieldHintText.tr,
                      controllerType: "CreateNewPassword",
                    )),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: CommonSignInPasswordField(
                      titleText: St.confirmPasswordTextFieldTitle.tr,
                      hintText: St.confirmPasswordTextFieldHintText.tr,
                      controllerType: "CreateConfirmPassword",
                    )),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: CommonSignInButton(
                      onTaped: () {
                        userLoginController.resendOtpWhenEmpty();
                      },
                      text: St.continueText.tr),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

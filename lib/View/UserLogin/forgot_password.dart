import 'package:era_shop/Controller/GetxController/login/user_login_controller.dart';
import 'package:era_shop/utils/CoustomWidget/Sign_in_material/common_sign_in_button.dart';
import 'package:era_shop/utils/CoustomWidget/Sign_in_material/common_sign_in_textfield.dart';
import 'package:era_shop/utils/CoustomWidget/Sign_in_material/sign_in_back_button.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    UserLoginController userLoginController = Get.put(UserLoginController());

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
                  height: Get.height / 15,
                ),
                Text(St.forgotPassword.tr, style: AppFontStyle.styleW600(AppColors.white, 18)),
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: SizedBox(
                    width: Get.width / 1.3,
                    height: 40,
                    child: Text(
                      St.forgotPasswordSubtitle.tr,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(color: AppColors.darkGrey),
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    child: CommonSignInTextField(
                      titleText: St.emailTextFieldTitle.tr,
                      hintText: St.emailTextFieldHintText.tr,
                      controllerType: "ForgotPassword",
                    )),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: CommonSignInButton(
                      onTaped: () {
                        userLoginController.forgotPasswordWhenEmpty();
                      },
                      text: St.continueText.tr),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

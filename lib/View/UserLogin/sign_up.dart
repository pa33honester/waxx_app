import 'package:waxxapp/Controller/GetxController/login/user_login_controller.dart';
import 'package:waxxapp/utils/CoustomWidget/App_theme_services/primary_buttons.dart';
import 'package:waxxapp/utils/CoustomWidget/App_theme_services/text_titles.dart';
import 'package:waxxapp/utils/CoustomWidget/Sign_in_material/common_sign_in_button.dart';
import 'package:waxxapp/utils/CoustomWidget/Sign_in_material/common_sign_in_passwordfield.dart';
import 'package:waxxapp/utils/CoustomWidget/Sign_in_material/common_sign_in_textfield.dart';
import 'package:waxxapp/utils/CoustomWidget/Sign_in_material/dont_account.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_circular.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class SignUp extends StatelessWidget {
  SignUp({super.key});
  UserLoginController userLoginController = Get.put(UserLoginController());

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.black,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: AppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
              actions: [
                SizedBox(
                  width: Get.width,
                  height: double.maxFinite,
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, top: 10),
                        child: PrimaryRoundButton(
                          onTaped: () {
                            Get.back();
                          },
                          icon: Icons.arrow_back_rounded,
                          iconColor: AppColors.white,
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: GeneralTitle(title: St.signUpText.tr),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          body: SafeArea(
              child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: SizedBox(
              height: Get.height,
              width: Get.width,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    Text(
                      St.completeAccount.tr,
                      style: AppFontStyle.styleW600(AppColors.white, 18),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        St.completeAccountSubtitle.tr,
                        style: GoogleFonts.plusJakartaSans(color: AppColors.darkGrey),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    CommonSignInTextField(
                      titleText: St.firstNameTextFieldTitle.tr,
                      hintText: St.firstNameTextFieldHintText.tr,
                      controllerType: "FirstName",
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    CommonSignInTextField(
                      titleText: St.emailTextFieldTitle.tr,
                      hintText: St.emailTextFieldHintText.tr,
                      controllerType: "Email",
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    CommonSignInPasswordField(
                      titleText: St.passwordTextFieldTitle.tr,
                      hintText: St.passwordTextFieldHintText.tr,
                      controllerType: "Password",
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    CommonSignInPasswordField(
                      titleText: St.confirmPasswordTextFieldTitle.tr,
                      hintText: St.confirmPasswordTextFieldHintText.tr,
                      controllerType: "ConfirmPassword",
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: CommonSignInButton(
                          onTaped: () {
                            userLoginController.sandOtpWhenSignUp();
                          },
                          text: St.signUpText.tr),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 28),
                      child: DoNotAccount(
                          onTaped: () {
                            Get.toNamed("/SignIn");
                          },
                          tapText: St.signInText.tr,
                          text: St.alreadyHaveAccount.tr),
                    ),
                  ],
                ),
              ),
            ),
          )),
        ),
        Obx(() => userLoginController.signUpOtpLoading.value ? ScreenCircular.blackScreenCircular() : const SizedBox())
      ],
    );
  }
}

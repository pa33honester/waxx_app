// ignore_for_file: must_be_immutable

import 'package:waxxapp/utils/CoustomWidget/Sign_in_material/common_sign_in_button.dart';
import 'package:waxxapp/utils/CoustomWidget/Sign_in_material/sign_in_back_button.dart';
import 'package:waxxapp/utils/CoustomWidget/Sign_in_material/sign_in_titles.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../Controller/GetxController/user/UserPasswordManage/user_password_controller.dart';
import '../../../../utils/CoustomWidget/App_theme_services/textfields.dart';
import '../../../../utils/app_circular.dart';

class UserCreatePassword extends StatelessWidget {
  // UserLoginController userLoginController = Get.put(UserLoginController());
  UserPasswordController userPasswordController = Get.put(UserPasswordController());

  UserCreatePassword({super.key});

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
                          SignInBackButton(onTaped: () {
                            Get.back();
                          })
                        ],
                      ),
                      SizedBox(
                        height: Get.height / 15,
                      ),
                      Obx(
                        () => Text(
                          St.createNewPassword.tr,
                          textAlign: TextAlign.center,
                          style: isDark.value ? SignInTitleStyle.whiteTitle : SignInTitleStyle.blackTitle,
                        ),
                      ),
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
                          child: ChangePasswordField(
                            titleText: St.newPasswordTextFieldTitle.tr,
                            hintText: St.newPasswordTextFieldHintText.tr,
                            controllerType: "UserCreatePassword",
                          )),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: ChangePasswordField(
                            titleText: St.confirmPasswordTextFieldTitle.tr,
                            hintText: St.confirmPasswordTextFieldHintText.tr,
                            controllerType: "UserCreateConfirmPassword",
                          )),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: CommonSignInButton(
                            onTaped: () {
                              // userLoginController.resendOtpWhenEmpty();
                              userPasswordController.userCreateNewPassword();
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
          ),
        ),
        Obx(
          () => userPasswordController.createPasswordLoading.value ? ScreenCircular.blackScreenCircular() : const SizedBox(),
        ),
      ],
    );
  }
}

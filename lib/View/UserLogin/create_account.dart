import 'dart:io';

import 'package:waxxapp/utils/CoustomWidget/Sign_in_material/common_sign_in_button.dart';
import 'package:waxxapp/utils/CoustomWidget/Sign_in_material/common_sign_in_textfield.dart';
import 'package:waxxapp/utils/CoustomWidget/Sign_in_material/dont_account.dart';
import 'package:waxxapp/utils/CoustomWidget/Sign_in_material/other_button.dart';
import 'package:waxxapp/utils/CoustomWidget/Sign_in_material/sign_in_titles.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Controller/GetxController/login/google_login_controller.dart';
import '../../utils/app_circular.dart';

class CreateAccount extends StatelessWidget {
  CreateAccount({Key? key}) : super(key: key);

  GoogleLoginController googleLoginController = Get.put(GoogleLoginController());

  @override
  Widget build(BuildContext context) {
    final formkey = GlobalKey<FormState>();

    return Stack(
      children: [
        Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: AppColors.primaryPink,
          body: SafeArea(
            child: SizedBox(
              height: Get.height,
              width: Get.width,
              child: Column(
                children: [
                  SizedBox(
                    height: Get.height / 15,
                  ),
                  Text(
                    St.createAccount.tr,
                    style: SignInTitleStyle.whiteTitle,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      "Lorem ipsum dolor sit amet",
                      style: GoogleFonts.plusJakartaSans(color: AppColors.white),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: AlignmentDirectional.bottomCenter,
                      child: Obx(
                        () => Container(
                          height: Get.height / (1.4) + 15,
                          width: Get.width,
                          decoration: BoxDecoration(color: isDark.value ? AppColors.blackBackground : const Color(0xffffffff), borderRadius: const BorderRadius.vertical(top: Radius.circular(30))),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
                            child: SizedBox(
                              child: Column(
                                children: [
                                  SizedBox(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Form(
                                          key: formkey,
                                          child: CommonSignInTextField(
                                            titleText: St.emailTextFieldTitle.tr,
                                            hintText: St.enterYourEmailAddress.tr,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(top: 30),
                                      child: CommonSignInButton(
                                        text: St.conWithEmail.tr,
                                        onTaped: () {
                                          if (formkey.currentState!.validate()) {
                                            Get.toNamed("/SignInEmail");
                                          }
                                        },
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 35),
                                    child: Buttons.orContinue(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 30),
                                    child: Buttons.googleButton(
                                      onTap: () {
                                        googleLoginController.googleLogin();
                                      },
                                    ),
                                  ),
                                  Platform.isIOS
                                      ? Padding(
                                          padding: const EdgeInsets.only(top: 15),
                                          child: Buttons.appleButton(),
                                        )
                                      : const SizedBox(),
                                  Padding(
                                    padding: EdgeInsets.only(top: Get.height / 17),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        DoNotAccount(
                                            onTaped: () {
                                              Get.toNamed("/SignInEmail");
                                            },
                                            tapText: St.login.tr,
                                            text: St.alreadyHaveAccount.tr),
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
                  ),
                ],
              ),
            ),
          ),
        ),
        Obx(() => googleLoginController.isLoading.value ? ScreenCircular.blackScreenCircular() : const SizedBox.shrink())
      ],
    );
  }
}

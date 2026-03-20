// ignore_for_file: must_be_immutable

import 'package:waxxapp/Controller/GetxController/user/UserPasswordManage/user_password_controller.dart';
import 'package:waxxapp/custom/simple_app_bar_widget.dart';
import 'package:waxxapp/utils/CoustomWidget/App_theme_services/primary_buttons.dart';
import 'package:waxxapp/utils/CoustomWidget/App_theme_services/textfields.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/Theme/theme_service.dart';
import 'package:waxxapp/utils/app_circular.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/globle_veriables.dart';
import '../../../../utils/show_toast.dart';

class ChangePassword extends StatelessWidget {
  UserPasswordController userPasswordController = Get.put(UserPasswordController());

  ChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.black,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: AppColors.transparent,
              shadowColor: AppColors.black.withValues(alpha: 0.4),
              flexibleSpace: SimpleAppBarWidget(title: St.changePassword.tr),
            ),
          ),
          // appBar: PreferredSize(
          //   preferredSize: const Size.fromHeight(60),
          //   child: AppBar(
          //     elevation: 0,
          //     automaticallyImplyLeading: false,
          //     actions: [
          //       SizedBox(
          //         width: Get.width,
          //         height: double.maxFinite,
          //         child: Stack(
          //           children: [
          //             Padding(
          //               padding: const EdgeInsets.only(left: 15, top: 10),
          //               child: PrimaryRoundButton(
          //                 onTaped: () {
          //                   Get.back();
          //                 },
          //                 icon: Icons.arrow_back_rounded,
          //               ),
          //             ),
          //             Align(
          //               alignment: Alignment.center,
          //               child: Padding(
          //                 padding: const EdgeInsets.only(top: 5),
          //                 child: GeneralTitle(title: St.changePassword.tr),
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 15),
            child: PrimaryPinkButton(
              onTaped: getStorage.read("isDemoLogin") ?? false || isDemoSeller ? () => displayToast(message: St.thisIsDemoUser.tr) : () => userPasswordController.changePasswordByUser(),
              text: St.submit.tr,
            ),
          ),
          body: SafeArea(
              child: SizedBox(
            height: Get.height,
            width: Get.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 25),
                      child: SizedBox(
                        height: 60,
                        child: Text(
                          St.profileCPSubtitle.tr,
                          style: AppFontStyle.styleW500(AppColors.unselected, 12),
                        ),
                      ),
                    ),
                    ChangePasswordField(
                      controllerType: "oldPassword",
                      titleText: St.oldPassword.tr,
                      hintText: St.oldPassword.tr,
                    ).paddingOnly(bottom: 15),
                    Divider(
                      color: AppColors.darkGrey.withValues(alpha: 0.30),
                      thickness: 1,
                      height: 35,
                    ),
                    ChangePasswordField(
                      controllerType: "changePassword",
                      titleText: St.newPasswordTextFieldTitle.tr,
                      hintText: St.newPasswordTextFieldTitle.tr,
                    ),
                    ChangePasswordField(
                      controllerType: "changeConfirmPassword",
                      titleText: St.confirmPasswordTextFieldTitle.tr,
                      hintText: St.confirmPasswordTextFieldTitle.tr,
                    ).paddingOnly(bottom: 20, top: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 7),
                              child: Icon(
                                Icons.done_rounded,
                                size: 20,
                                color: AppColors.primaryGreen,
                              ),
                            ),
                            Text(
                              St.passwordLengthNotice.tr,
                              style: GoogleFonts.plusJakartaSans(color: AppColors.primaryGreen, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 7),
                              child: Icon(
                                Icons.done_rounded,
                                size: 20,
                                color: AppColors.primaryGreen,
                              ),
                            ),
                            Text(
                              "There must be a unique code like @!#",
                              style: GoogleFonts.plusJakartaSans(color: AppColors.primaryGreen, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )),
        ),
        Obx(() => userPasswordController.changePasswordLoading.value ? ScreenCircular.blackScreenCircular() : const SizedBox.shrink())
      ],
    );
  }
}

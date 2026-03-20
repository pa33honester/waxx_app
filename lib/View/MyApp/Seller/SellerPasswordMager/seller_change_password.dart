// ignore_for_file: must_be_immutable

import 'package:waxxapp/custom/simple_app_bar_widget.dart';
import 'package:waxxapp/utils/CoustomWidget/App_theme_services/primary_buttons.dart';
import 'package:waxxapp/utils/CoustomWidget/App_theme_services/textfields.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_circular.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../Controller/GetxController/seller/seller_common_controller.dart';
import '../../../../utils/globle_veriables.dart';

class SellerChangePassword extends StatelessWidget {
  // UserPasswordController userPasswordController = Get.put(UserPasswordController());
  SellerCommonController sellerCommonController = Get.put(SellerCommonController());

  SellerChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
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
              onTaped: () => isDemoSeller == true ? displayToast(message: St.thisIsDemoUser.tr) : sellerCommonController.changePasswordBySeller(),
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
                          style: AppFontStyle.styleW600(AppColors.white, 16),
                        ),
                      ),
                    ),
                    PrimaryPasswordField(
                      controllerType: "SellerAddOldPassword",
                      titleText: St.oldPassword.tr,
                      hintText: St.enterOldPassword.tr,
                    ).paddingOnly(bottom: 15),
                    Divider(
                      color: AppColors.darkGrey.withValues(alpha: 0.30),
                      thickness: 1,
                      height: 35,
                    ),
                    PrimaryPasswordField(
                      controllerType: "SellerChangePassword",
                      titleText: St.passwordTextFieldTitle.tr,
                      hintText: St.passwordTextFieldHintText.tr,
                    ),
                    PrimaryPasswordField(
                      controllerType: "SellerChangeConfirmPassword",
                      titleText: St.confirmPasswordTextFieldTitle.tr,
                      hintText: St.confirmPasswordTextFieldHintText.tr,
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
                              "${St.thereMustBeAUniqueCodeLike.tr} @!#",
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
        Obx(() => sellerCommonController.changePasswordLoading.value ? ScreenCircular.blackScreenCircular() : const SizedBox.shrink())
      ],
    );
  }
}

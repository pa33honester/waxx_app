import 'dart:async';

import 'package:waxxapp/user_pages/bottom_bar_page/controller/bottom_bar_controller.dart';
import 'package:waxxapp/user_pages/bottom_bar_page/view/bottom_bar_view.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/Zego/ZegoUtils/device_orientation.dart';
import 'package:waxxapp/utils/app_asset.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SellerAccountVerification extends StatefulWidget {
  const SellerAccountVerification({super.key});

  @override
  State<SellerAccountVerification> createState() => _AccountVerification();
}

class _AccountVerification extends State<SellerAccountVerification> {
  @override
  Widget build(BuildContext context) {
    Timer(
      const Duration(milliseconds: 100),
      () {
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarColor: AppColors.transparent,
            statusBarIconBrightness: Brightness.light,
          ),
        );
      },
    );
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.transparent,
        // bottomNavigationBar: Padding(
        //   padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        //   child: PrimaryPinkButton(
        //       onTaped: () {
        //         // here navigate
        //       },
        //       text: Strings.continueText),
        // ),
        // appBar: PreferredSize(
        //   preferredSize: const Size.fromHeight(60),
        //   child: AppBar(
        //     automaticallyImplyLeading: false,
        //     backgroundColor: AppColors.transparent,
        //     surfaceTintColor: AppColors.transparent,
        //     flexibleSpace: SimpleAppBarWidget(title: St.sellerAccount.tr),
        //   ),
        // ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 300,
                width: Get.width,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: MediaQuery.of(context).viewPadding.top + 15,
                      child: SizedBox(
                        width: Get.width,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  final controller = BottomBarController();
                                  controller.onChangeBottomBar(0);

                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (context) => const BottomBarView()),
                                    (route) => false,
                                  );
                                },
                                child: Container(
                                  height: 48,
                                  width: 48,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: AppColors.white.withValues(alpha: 0.3),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Image.asset(AppAsset.icBack, color: AppColors.black, width: 15),
                                ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    St.sellerAccount.tr,
                                    style: AppFontStyle.styleW900(AppColors.black, 18),
                                  ),
                                ),
                              ),
                              48.width,
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top + 25),
                      child: Image.asset(
                        AppAsset.imgVerification,
                        width: 200,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 35,
              ),
              Center(
                child: Text(
                  "Registration Verifying...",
                  style: AppFontStyle.styleW900(AppColors.primary, 22),
                ),
              ),
              5.height,
              Center(
                child: Text(
                  "Submission Successful",
                  style: AppFontStyle.styleW500(AppColors.unselected, 15),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 10, bottom: 20),
              //   child: Text(
              //     St.verifyToSelling.tr,
              //     style: GoogleFonts.plusJakartaSans(color: AppColors.darkGrey),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 15),
              //   child: Text(
              //     St.thankYouForCreatingAnAccount.tr,
              //     style: AppFontStyle.styleW500(AppColors.unselected, 12),
              //   ),
              15.height,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  "All of the details you have submitted has been received by Us. We will check and update you on this once we have an update for you.",
                  style: AppFontStyle.styleW500(AppColors.unselected, 13),
                ),
              ),
              15.height,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  "It will take around 3 to 4 business days to check and verify your profile",
                  style: AppFontStyle.styleW500(AppColors.unselected, 13),
                ),
              ),
              15.height,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  "Write us on below details if you have any questions and queries.",
                  style: AppFontStyle.styleW500(AppColors.unselected, 13),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

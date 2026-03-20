import 'package:waxxapp/utils/CoustomWidget/App_theme_services/primary_buttons.dart';
import 'package:waxxapp/utils/CoustomWidget/App_theme_services/text_titles.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/globle_veriables.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Security extends StatefulWidget {
  const Security({Key? key}) : super(key: key);

  @override
  State<Security> createState() => _SecurityState();
}

class _SecurityState extends State<Security> {
  bool isFaceId = true;
  bool isRememberPassword = true;
  bool isTouchId = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: GeneralTitle(title: St.security.tr),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
          child: SizedBox(
        height: Get.height,
        width: Get.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              const SizedBox(
                height: 18,
              ),
              Obx(
                () => Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: isDark.value ? AppColors.lightBlack : Colors.transparent,
                    border: Border.all(color: isDark.value ? Colors.grey.shade600.withValues(alpha: 0.30) : Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10),
                    // color: Colors.grey,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 50,
                          // color: Colors.grey,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                St.faceId.tr,
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                              Transform.scale(
                                scale: 0.8,
                                transformHitTests: false,
                                child: CupertinoSwitch(
                                  activeColor: AppColors.primaryPink,
                                  value: isFaceId,
                                  onChanged: (value) {
                                    setState(() {});
                                    isFaceId = value;
                                  },
                                ),
                              ),
                              // GestureDetector(
                              //   child: Switch(
                              //     inactiveTrackColor: Color(0xffEDF2F7),
                              //     value: remainder,
                              //     onChanged: (value) {
                              //       setState(() {});
                              //       remainder = value;
                              //     },
                              //   ),
                              // )
                            ],
                          ),
                        ),
                        Divider(
                          height: 9,
                          color: AppColors.darkGrey.withValues(alpha: 0.40),
                        ),
                        SizedBox(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                St.rememberPassword.tr,
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                              Transform.scale(
                                scale: 0.8,
                                transformHitTests: false,
                                child: CupertinoSwitch(
                                  activeColor: AppColors.primaryPink,
                                  value: isRememberPassword,
                                  onChanged: (value) {
                                    setState(() {});
                                    isRememberPassword = value;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          height: 9,
                          color: AppColors.darkGrey.withValues(alpha: 0.40),
                        ),
                        SizedBox(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                St.touchId.tr,
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                              Transform.scale(
                                scale: 0.8,
                                transformHitTests: false,
                                child: CupertinoSwitch(
                                  activeColor: AppColors.primaryPink,
                                  value: isTouchId,
                                  onChanged: (value) {
                                    setState(() {});
                                    isTouchId = value;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}

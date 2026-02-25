import 'package:era_shop/utils/CoustomWidget/App_theme_services/primary_buttons.dart';
import 'package:era_shop/utils/CoustomWidget/App_theme_services/text_titles.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/globle_veriables.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  bool isRemainder = true;
  bool isDelevery = true;
  // bool isMessage = true;
  bool isExpired = true;
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
                      child: GeneralTitle(title: St.notification.tr),
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
              Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: isDark.value ? AppColors.lightBlack : Colors.transparent,
                  border: Border.all(color: isDark.value ? Colors.grey.shade600.withValues(alpha: 0.30) : Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                  // color: Colors.grey,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          St.messageNotification.tr,
                          style: TextStyle(color: isDark.value ? AppColors.white : Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        // color: Colors.grey,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              St.paymentReminder.tr,
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
                                value: isRemainder,
                                onChanged: (value) {
                                  setState(() {});
                                  isRemainder = value;
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
                        // color: Colors.grey,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              St.productDelivery.tr,
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
                                value: isDelevery,
                                onChanged: (value) {
                                  setState(() {});
                                  isDelevery = value;
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
                      // SizedBox(
                      //   height: 50,
                      //   // color: Colors.grey,
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Text(
                      //         "Message",
                      //         style: GoogleFonts.plusJakartaSans(
                      //           fontWeight: FontWeight.w500,
                      //           fontSize: 16,
                      //         ),
                      //       ),
                      //       Transform.scale(
                      //         scale: 0.8,
                      //         transformHitTests: false,
                      //         child: CupertinoSwitch(
                      //           activeColor: AppColors.primaryPink,
                      //           value: isMessage,
                      //           onChanged: (value) {
                      //             setState(() {});
                      //             isMessage = value;
                      //           },
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // Divider(
                      //   height: 9,
                      //   color: AppColors.primaryDarkGreey.withValues(alpha:0.40),
                      // ),
                      SizedBox(
                        height: 50,
                        // color: Colors.grey,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              St.expiredVoucher.tr,
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
                                value: isExpired,
                                onChanged: (value) {
                                  setState(() {});
                                  isExpired = value;
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
            ],
          ),
        ),
      )),
    );
  }
}

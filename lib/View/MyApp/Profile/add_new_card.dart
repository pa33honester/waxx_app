import 'package:era_shop/utils/CoustomWidget/App_theme_services/primary_buttons.dart';
import 'package:era_shop/utils/CoustomWidget/App_theme_services/text_titles.dart';
import 'package:era_shop/utils/CoustomWidget/App_theme_services/textfields.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AddNewCard extends StatelessWidget {
  const AddNewCard({Key? key}) : super(key: key);

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
                      child: GeneralTitle(title: St.addNewCard.tr),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 15),
        child: PrimaryPinkButton(
            onTaped: () {
              Get.back();
              Get.snackbar(
                duration: const Duration(seconds: 4),
                St.appName.tr,
                St.newCardAddedSuccessfully.tr,
              );
            },
            text: St.addCard.tr),
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
                const SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: PrimaryTextField(
                    titleText: St.cardNumber.tr,
                    hintText: St.enterCardNumber.tr,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: PrimaryTextField(
                    titleText: St.cardHolderName.tr,
                    hintText: St.enterHolderName.tr,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: Get.width / 2.3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            St.expired.tr,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              color: isDark.value ? AppColors.white : AppColors.mediumGrey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 7),
                            child: Obx(
                              () => TextFormField(
                                style: TextStyle(color: isDark.value ? AppColors.dullWhite : AppColors.black),
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: isDark.value ? AppColors.blackBackground : AppColors.dullWhite,
                                    hintText: "MM/YY",
                                    hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 16),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: isDark.value ? BorderSide(color: Colors.grey.shade800) : BorderSide.none, borderRadius: BorderRadius.circular(24)),
                                    border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primaryPink), borderRadius: BorderRadius.circular(26))),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: Get.width / 2.3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            St.cvvCode.tr,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              color: isDark.value ? AppColors.white : AppColors.mediumGrey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 7),
                            child: Obx(
                              () => TextFormField(
                                style: TextStyle(color: isDark.value ? AppColors.dullWhite : AppColors.black),
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: isDark.value ? AppColors.blackBackground : AppColors.dullWhite,
                                    hintText: St.cvvCode.tr,
                                    hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 16),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: isDark.value ? BorderSide(color: Colors.grey.shade800) : BorderSide.none, borderRadius: BorderRadius.circular(24)),
                                    border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primaryPink), borderRadius: BorderRadius.circular(26))),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}

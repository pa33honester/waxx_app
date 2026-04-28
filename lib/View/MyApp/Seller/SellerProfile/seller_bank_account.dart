import 'package:waxxapp/custom/main_button_widget.dart';
import 'package:waxxapp/custom/simple_app_bar_widget.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:waxxapp/utils/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SellerBankAccount extends StatelessWidget {
  const SellerBankAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.transparent,
          surfaceTintColor: AppColors.transparent,
          flexibleSpace: SimpleAppBarWidget(title: St.bankAccount.tr),
        ),
      ),
      body: Container(
        height: 280,
        width: Get.width,
        padding: EdgeInsets.symmetric(horizontal: 15),
        margin: EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: AppColors.tabBackground,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 25,
            ),
            Text(
              editBankName,
              style: AppFontStyle.styleW700(AppColors.white, 17),
            ),
            const SizedBox(
              height: 22,
            ),
            Text(
              "${St.accountNumTitle.tr} :",
              style: AppFontStyle.styleW500(AppColors.unselected, 12),
            ),
            const SizedBox(
              height: 7,
            ),
            Text(
              editMomoNumber,
              style: AppFontStyle.styleW700(AppColors.white, 13),
            ),
            const SizedBox(
              height: 22,
            ),
            Text(
              "${St.iFSCCode.tr} :",
              style: AppFontStyle.styleW500(AppColors.unselected, 12),
            ),
            const SizedBox(
              height: 7,
            ),
            Text(
              editNetworkName,
              style: AppFontStyle.styleW700(AppColors.white, 13),
            ),
            const SizedBox(
              height: 22,
            ),
            Text(
              "${St.branchName.tr} :",
              style: AppFontStyle.styleW500(AppColors.unselected, 12),
            ),
            const SizedBox(
              height: 7,
            ),
            Text(
              editMomoName,
              style: AppFontStyle.styleW700(AppColors.white, 13),
            ),
          ],
        ),
      ),
      bottomNavigationBar: MainButtonWidget(
        height: 55,
        width: Get.width,
        margin: const EdgeInsets.all(15),
        color: AppColors.primary,
        child: Text(
          St.changeBankDetails.tr.toUpperCase(),
          style: AppFontStyle.styleW700(AppColors.black, 16),
        ),
        callback: () => isDemoSeller == true ? displayToast(message: St.thisIsDemoUser.tr) : Get.toNamed("/SellerEditBank"),
      ),
    );
  }
}

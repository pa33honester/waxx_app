import 'package:era_shop/custom/simple_app_bar_widget.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:era_shop/utils/show_toast.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SellerAddress extends StatelessWidget {
  const SellerAddress({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.transparent,
          surfaceTintColor: AppColors.transparent,
          flexibleSpace: SimpleAppBarWidget(title: St.myAddress.tr),
        ),
      ),
      body: SizedBox(
        height: Get.height,
        width: Get.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            children: [
              25.height,
              Container(
                width: Get.width,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: AppColors.tabBackground,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SmallTitle(title: "$editFirstName $editLastName"),
                    Text(
                      "$editFirstName $editLastName",
                      style: AppFontStyle.styleW700(AppColors.white, 18),
                    ),
                    10.height,

                    Text(
                      editPhoneNumber ?? "",
                      style: AppFontStyle.styleW600(AppColors.unselected, 13),
                    ),
                    10.height,
                    Text(
                      "$editSellerAddress, $editLandmark,\n$editCity, $editPinCode.",
                      style: AppFontStyle.styleW600(AppColors.unselected, 13),
                    ),
                    10.height,

                    GestureDetector(
                      onTap: () {
                        isDemoSeller == true ? displayToast(message: St.thisIsDemoUser.tr) : Get.toNamed("/SellerEditAddress");
                      },
                      child: Container(
                        height: 32,
                        width: Get.width / 2.7,
                        decoration: BoxDecoration(
                          color: AppColors.redBackground,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            St.changeAddress.tr,
                            style: AppFontStyle.styleW600(AppColors.red, 13),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

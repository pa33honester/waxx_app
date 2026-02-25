import 'package:era_shop/seller_pages/select_product_for_streame/controller/select_product_for_controller.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/app_asset.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectProductWidget extends StatelessWidget {
  const SelectProductWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: GetBuilder<SelectProductsForStreamerController>(builder: (logic) {
        return Container(
          color: AppColors.black,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: AppColors.tabBackground,
                      shape: BoxShape.circle,
                    ),
                    child: Center(child: Image.asset(AppAsset.icBack, width: 25)),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      St.txtSelectProduct.tr,
                      style: AppFontStyle.styleW700(AppColors.white, 19),
                    ),
                  ),
                ),
                50.width,
              ],
            ),
          ),
        );
      }),
    );
  }
}

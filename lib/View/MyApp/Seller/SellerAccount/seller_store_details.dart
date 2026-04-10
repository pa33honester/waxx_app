import 'package:waxxapp/Controller/GetxController/seller/seller_common_controller.dart';
import 'package:waxxapp/View/MyApp/Seller/SellerAccount/seller_login.dart';
import 'package:waxxapp/custom/custom_color_bg_widget.dart';
import 'package:waxxapp/custom/main_button_widget.dart';
import 'package:waxxapp/custom/simple_app_bar_widget.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_asset.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SellerStoreDetails extends StatelessWidget {
  SellerStoreDetails({super.key});
  final controller = Get.put(SellerCommonController());

  @override
  Widget build(BuildContext context) {
    return CustomColorBgWidget(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.transparent,
            surfaceTintColor: AppColors.transparent,
            flexibleSpace: SimpleAppBarWidget(title: St.sellerAccount.tr),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                15.height,
                Center(child: Image.asset(AppAsset.icStoreProduct, color: AppColors.primary, height: 50, fit: BoxFit.cover, width: 50)),
                15.height,
                Center(
                  child: Text(
                    St.completeSellerAccount.tr,
                    style: AppFontStyle.styleW900(AppColors.primary, 20),
                    textAlign: TextAlign.center,
                  ),
                ),
                10.height,
                Center(
                  child: Text(
                    St.securelyProcessYourPayment.tr,
                    style: AppFontStyle.styleW500(AppColors.unselected, 12),
                  ),
                ),
                25.height,
                SellerItemWidget(
                  hintText: St.enterStoreName.tr,
                  title: St.storeName.tr,
                  keyboardType: TextInputType.name,
                  controller: controller.businessNameController,
                ),
                25.height,
                // SellerItemWidget(
                //   title: St.description.tr,
                //   keyboardType: TextInputType.name,
                //   controller: controller.descriptionController,
                //   // maxLines: 5,
                // ),
                Text(
                  St.description.tr,
                  style: AppFontStyle.styleW500(AppColors.unselected, 12),
                ),
                10.height,
                MainButtonWidget(
                  width: Get.width,
                  borderRadius: 12,
                  padding: const EdgeInsets.only(left: 15),
                  color: AppColors.tabBackground,
                  child: TextFormField(
                    controller: controller.descriptionController,
                    cursorColor: AppColors.unselected,
                    keyboardType: TextInputType.name,
                    style: AppFontStyle.styleW700(AppColors.white, 15),
                    decoration: InputDecoration(
                      hintText: St.enterDescription.tr,
                      hintStyle: AppFontStyle.styleW600(AppColors.unselected, 12),
                      border: InputBorder.none,
                    ),
                    maxLines: 5,
                  ),
                ),
                25.height,
                Text(
                  St.logo.tr,
                  style: AppFontStyle.styleW500(AppColors.unselected, 12),
                ),
                10.height,
                Row(
                  children: [
                    GetBuilder<SellerCommonController>(
                      builder: (context) {
                        return controller.selectedImage == null
                            ? GestureDetector(
                                onTap: () {
                                  controller.getLogoFromGallery();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(1),
                                  child: Container(
                                    height: 140,
                                    width: 120,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: AppColors.unselected.withValues(alpha: .5),
                                        width: 1.5,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    child: Column(
                                      // crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add,
                                          color: AppColors.unselected,
                                        ),
                                        Text(
                                          'Add Logo',
                                          style: AppFontStyle.styleW500(AppColors.unselected, 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : Stack(
                                children: [
                                  Container(
                                    height: 140,
                                    width: 120,
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                      color: AppColors.tabBackground,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Image.file(
                                      controller.selectedImage!,
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: GestureDetector(
                                      onTap: () => controller.removeLogo(),
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryRed,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          size: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                      },
                    ),
                  ],
                ),
                10.height,
              ],
            ),
          ),
        ),
        bottomNavigationBar: MainButtonWidget(
          height: 55,
          width: Get.width,
          margin: const EdgeInsets.all(15),
          color: AppColors.primary,
          child: Text(
            St.nextText.tr.toUpperCase(),
            style: AppFontStyle.styleW700(AppColors.black, 16),
          ),
          callback: () => controller.onSubmitSellerStoreDetails(),
        ),
      ),
    );
  }
}

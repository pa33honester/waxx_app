import 'package:era_shop/Controller/GetxController/seller/delete_catalog_controller.dart';
import 'package:era_shop/custom/main_button_widget.dart';
import 'package:era_shop/seller_pages/listing/controller/listing_controller.dart';
import 'package:era_shop/seller_pages/listing/widget/category_widget.dart';
import 'package:era_shop/seller_pages/listing/widget/description_widget.dart';
import 'package:era_shop/seller_pages/listing/widget/item_specific_widget.dart';
import 'package:era_shop/seller_pages/listing/widget/photos_widget.dart';
import 'package:era_shop/seller_pages/listing/widget/preferences_widget.dart';
import 'package:era_shop/seller_pages/listing/widget/pricing_widget.dart';
import 'package:era_shop/seller_pages/listing/widget/title_widget.dart';
import 'package:era_shop/utils/CoustomWidget/App_theme_services/primary_buttons.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/app_asset.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:era_shop/utils/show_toast.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ListingSummary extends StatelessWidget {
  ListingSummary({super.key});

  final controller = Get.put(ListingController());
  final deleteCatalogController = Get.put(DeleteCatalogController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.transparent,
          shadowColor: AppColors.grayLight.withValues(alpha: 0.4),
          surfaceTintColor: AppColors.transparent,
          flexibleSpace: SafeArea(
            child: Container(
              color: AppColors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        height: 48,
                        width: 48,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(AppAsset.icBack, width: 15),
                      ),
                    ),
                    20.width,
                    Text(
                      St.listingSummary.tr,
                      style: AppFontStyle.styleW900(AppColors.white, 18),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PhotosWidget(),
            TitleWidget(),
            CategoryWidget(),
            ItemSpecificWidget(),
            DescriptionWidget(),
            PricingWidget(),
            PreferencesWidget(),
            GetBuilder<ListingController>(builder: (controller) {
              return MainButtonWidget(
                height: 60,
                callback: () async {
                  isDemoSeller == true ? displayToast(message: St.thisIsDemoUser.tr).then((value) => Get.back()) : await controller.onSubmit();
                },
                child: Text(
                  controller.isEdit ? 'Edit Item' : St.listAnItem.tr,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: AppFontStyle.styleW700(AppColors.black, 15),
                ),
              ).paddingOnly(left: 16, right: 16, top: 30);
            }),
            MainButtonWidget(
              height: 60,
              callback: () {
                Get.toNamed('/PreviewScreen');
              },
              border: Border.all(color: AppColors.primary),
              color: Colors.transparent,
              child: Text(
                St.preview.tr,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: AppFontStyle.styleW700(AppColors.primary, 15),
              ),
            ).paddingAll(16),
            if (controller.isEdit)
              MainButtonWidget(
                height: 55,
                width: Get.width,
                color: AppColors.red,
                child: Text(
                  St.removeCatalog.tr.toUpperCase(),
                  style: AppFontStyle.styleW700(AppColors.white, 16),
                ),
                callback: () {
                  isDemoSeller == true
                      ? displayToast(message: St.thisIsDemoUser.tr)
                      : Get.defaultDialog(
                          backgroundColor: isDark.value ? AppColors.blackBackground : AppColors.white,
                          title: St.doYouReallyWantToRemoveThisProduct.tr,
                          titlePadding: const EdgeInsets.only(top: 45, left: 20, right: 20),
                          titleStyle: GoogleFonts.plusJakartaSans(color: isDark.value ? AppColors.white : AppColors.black, height: 1.4, fontSize: 18, fontWeight: FontWeight.w600),
                          content: Column(
                            children: [
                              SizedBox(
                                height: Get.height / 30,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 30),
                                child: PrimaryPinkButton(
                                    onTaped: () {
                                      Get.back();
                                    },
                                    text: St.cancelSmallText.tr),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20, bottom: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    deleteCatalogController.getDeleteData();
                                    Get.back();
                                    // Get.offNamed("/SellerCatalogScreen");
                                  },
                                  child: Text(
                                    St.remove.tr,
                                    style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.red),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                },
              ).paddingOnly(left: 16, right: 16, bottom: 16),
          ],
        ),
      ),
    );
  }
}

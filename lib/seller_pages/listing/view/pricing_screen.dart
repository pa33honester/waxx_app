import 'package:era_shop/utils/globle_veriables.dart';
import 'package:flutter/material.dart';
import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:cool_dropdown/models/cool_dropdown_item.dart';
import 'package:era_shop/seller_pages/listing/controller/listing_controller.dart';
import 'package:era_shop/seller_pages/listing/widget/listing_app_bar_widget.dart';
import 'package:era_shop/seller_pages/listing/widget/title_form_filed.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class PricingScreen extends StatelessWidget {
  const PricingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) => Get.find<ListingController>().daysDropDownController.close(),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: GetBuilder<ListingController>(
              builder: (controller) {
                return ListingAppBarWidget(
                  title: St.pricing.tr,
                  showCheckIcon: true,
                  isCheckEnabled: controller.hasPricing,
                  onCheckTap: () {
                    Get.back();
                  },
                );
              },
            )),
        body: GetBuilder<ListingController>(
          builder: (controller) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(
                    title: St.buyItNow.tr,
                  ),
                  8.height,
                  Text(St.buyersCanPurchaseImmediatelyAtThisPrice.tr, style: AppFontStyle.styleW500(AppColors.unselected, 14)),
                  20.height,
                  ValueListenableBuilder<TextEditingValue>(
                      valueListenable: controller.buyItNowPriceController,
                      builder: (context, value, child) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          controller.update();
                        });
                        return TitleFormFiled(
                          hintText: '${St.buyItNowPrice.tr} ($currencySymbol)',
                          controller: controller.buyItNowPriceController,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          onChanged: (value) => controller.update(),
                        );
                      }),
                  18.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(onTap: () => controller.toggleMoreOptions(!controller.isMoreOptionsEnabled), child: !controller.isMoreOptionsEnabled ? Text(St.moreOptions.tr, style: AppFontStyle.styleW700(AppColors.white, 16)) : Offstage()),
                    ],
                  ),
                  if (controller.isMoreOptionsEnabled) ...[
                    Utils.buildDivider(),
                    12.height,
                    _buildOffers(controller),
                    12.height,
                    Utils.buildDivider(),
                    12.height,
                  ],
                  16.height,
                  Text(St.shippingCharge.tr, style: AppFontStyle.styleW600(AppColors.white, 16)),
                  16.height,
                  TitleFormFiled(
                    controller: controller.shippingChargeController,
                    hintText: St.enterShippingCharge.tr,
                    keyboardType: TextInputType.number,
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildOffers(ListingController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(St.offers.tr, style: AppFontStyle.styleW600(AppColors.white, 16)),
        GestureDetector(
          onTap: () {
            Get.toNamed('/Offers');
          },
          child: Text(
            controller.isOffersAllowed ? St.yes.tr : St.no.tr,
            style: AppFontStyle.styleW600(controller.isOffersAllowed ? AppColors.primary : AppColors.white, 14),
          ),
        )
      ],
    );
  }
}

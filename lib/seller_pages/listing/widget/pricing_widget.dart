import 'package:era_shop/seller_pages/listing/controller/listing_controller.dart';
import 'package:era_shop/seller_pages/listing/widget/container_widget.dart';
import 'package:era_shop/seller_pages/listing/widget/list_title.dart';
import 'package:era_shop/utils/Strings/strings.dart';
import 'package:era_shop/utils/app_colors.dart';
import 'package:era_shop/utils/font_style.dart';
import 'package:era_shop/utils/globle_veriables.dart';
import 'package:era_shop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PricingWidget extends StatelessWidget {
  const PricingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: GetBuilder<ListingController>(
        builder: (controller) {
          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            15.height,
            ListTitle(
              title: St.pricing.tr,
              onTap: () {
                Get.toNamed("/Pricing")?.then(
                  (value) => controller.update(),
                );
              },
              showCheckIcon: controller.hasPricing,
            ),
            22.height,
            _buildPricingContent(controller),
          ]);
        },
      ),
    );
  }

  Widget _buildPricingContent(ListingController controller) {
    return _buildBuyItNowContent(controller);
  }

  Widget _buildEmptyState(ListingController controller) {
    return ContainerWidget(
      onTap: () {
        Get.toNamed("/Pricing")?.then(
          (value) => controller.update(),
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.info,
            color: AppColors.unselected,
            size: 18,
          ),
          10.width,
          Expanded(
            child: Text(
              St.pleaseProvideAStartingBidForYourItem.tr,
              style: AppFontStyle.styleW500(AppColors.unselected, 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBuyItNowContent(ListingController controller) {
    bool hasPrice = controller.buyItNowPriceController.text.isNotEmpty;

    if (!hasPrice) {
      return _buildEmptyState(controller);
    }

    return ContainerDataWidget(
      tap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            St.buyItNow.tr,
            style: AppFontStyle.styleW700(AppColors.primary, 14),
          ),
          10.height,
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  St.itemPrice.tr,
                  style: AppFontStyle.styleW500(AppColors.unselected, 12),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  ":",
                  style: AppFontStyle.styleW500(AppColors.white, 12),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  "$currencySymbol ${controller.buyItNowPriceController.text}",
                  style: AppFontStyle.styleW600(AppColors.white, 13),
                ),
              ),
            ],
          ),
          if (controller.isMoreOptionsEnabled && controller.isOffersAllowed && controller.minimumOfferAmountController.text.isNotEmpty) ...[
            10.height,
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    St.offers.tr,
                    style: AppFontStyle.styleW500(AppColors.unselected, 12),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    ":",
                    style: AppFontStyle.styleW600(AppColors.white, 12),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    "$currencySymbol ${controller.minimumOfferAmountController.text}",
                    style: AppFontStyle.styleW600(AppColors.white, 13),
                  ),
                ),
              ],
            ),
          ],
          if (controller.shippingChargeController.text.isNotEmpty) ...[
            10.height,
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    St.shippingCharge.tr,
                    style: AppFontStyle.styleW500(AppColors.unselected, 12),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    ":",
                    style: AppFontStyle.styleW500(AppColors.white, 12),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    "$currencySymbol ${controller.shippingChargeController.text}",
                    style: AppFontStyle.styleW600(AppColors.white, 13),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

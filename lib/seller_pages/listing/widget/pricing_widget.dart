import 'package:waxxapp/seller_pages/listing/controller/listing_controller.dart';
import 'package:waxxapp/seller_pages/listing/widget/container_widget.dart';
import 'package:waxxapp/seller_pages/listing/widget/list_title.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:waxxapp/utils/utils.dart';
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
          ..._buildDeliveryOptionsSummary(controller),
        ],
      ),
    );
  }

  // Shape B (v1.0.10): Pricing now captures up to three delivery scopes
  // with their own prices. Render one row per filled scope so the summary
  // matches what the seller actually entered. Falls back to the legacy
  // single shippingCharges row when only that field is populated (edit
  // flow on a v1.0.9 product the seller hasn't re-saved under Shape B).
  List<Widget> _buildDeliveryOptionsSummary(ListingController controller) {
    final entries = <_DeliveryRow>[
      _DeliveryRow(St.deliveryLocal.tr, controller.localShippingChargeController.text),
      _DeliveryRow(St.deliveryNationwide.tr, controller.nationwideShippingChargeController.text),
      _DeliveryRow(St.deliveryInternational.tr, controller.internationalShippingChargeController.text),
    ].where((r) => r.value.trim().isNotEmpty).toList();

    if (entries.isEmpty) {
      if (controller.shippingChargeController.text.trim().isEmpty) return const [];
      entries.add(_DeliveryRow(St.shippingCharge.tr, controller.shippingChargeController.text));
    }

    return [
      for (final r in entries) ...[
        10.height,
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                r.label,
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
                "$currencySymbol ${r.value}",
                style: AppFontStyle.styleW600(AppColors.white, 13),
              ),
            ),
          ],
        ),
      ],
    ];
  }
}

class _DeliveryRow {
  final String label;
  final String value;
  _DeliveryRow(this.label, this.value);
}

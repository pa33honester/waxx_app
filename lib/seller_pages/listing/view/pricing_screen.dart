import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:flutter/material.dart';
import 'package:waxxapp/seller_pages/listing/controller/listing_controller.dart';
import 'package:waxxapp/seller_pages/listing/widget/listing_app_bar_widget.dart';
import 'package:waxxapp/seller_pages/listing/widget/promo_code_picker.dart';
import 'package:waxxapp/seller_pages/listing/widget/title_form_filed.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/utils.dart';
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
                  // Shape B per-option shipping (v1.0.10): 3 optional
                  // price inputs, one per delivery scope. Replaces the
                  // v1.0.9 single dropdown + single charge field.
                  Text(St.deliveryOptions.tr, style: AppFontStyle.styleW600(AppColors.white, 16)),
                  6.height,
                  Text(
                    St.leaveBlankToNotOffer.tr,
                    style: AppFontStyle.styleW500(AppColors.unselected, 12),
                  ),
                  16.height,
                  _buildDeliveryOptionRow(
                    label: St.deliveryLocal.tr,
                    hint: St.enterLocalDeliveryCharge.tr,
                    fieldController: controller.localShippingChargeController,
                  ),
                  10.height,
                  _buildDeliveryOptionRow(
                    label: St.deliveryNationwide.tr,
                    hint: St.enterNationwideDeliveryCharge.tr,
                    fieldController: controller.nationwideShippingChargeController,
                  ),
                  10.height,
                  _buildDeliveryOptionRow(
                    label: St.deliveryInternational.tr,
                    hint: St.enterInternationalDeliveryCharge.tr,
                    fieldController: controller.internationalShippingChargeController,
                  ),
                  20.height,
                  // Promo Codes section — sellers opt their product into one
                  // or more admin-managed PromoCodes. Multi-select sheet.
                  Utils.buildDivider(),
                  12.height,
                  _buildPromoCodes(controller),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPromoCodes(ListingController controller) {
    return Obx(() {
      final selectedCount = controller.selectedPromoCodeIds.length;
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => openPromoCodePicker(controller),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Promo Codes', style: AppFontStyle.styleW600(AppColors.white, 16)),
            Row(
              children: [
                Text(
                  selectedCount == 0 ? 'None' : '$selectedCount selected',
                  style: AppFontStyle.styleW600(
                    selectedCount == 0 ? AppColors.white : AppColors.primary,
                    14,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.chevron_right_rounded, color: AppColors.white, size: 20),
              ],
            ),
          ],
        ),
      );
    });
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

  /// One row of the Shape B 3-input panel — a left-aligned scope label
  /// (Local / Nationwide / International) and a right-aligned numeric
  /// price field. All three rows are optional; an empty input means the
  /// seller doesn't offer that delivery scope and the buyer never sees
  /// it as a checkout option.
  Widget _buildDeliveryOptionRow({
    required String label,
    required String hint,
    required TextEditingController fieldController,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 4,
          child: Text(
            label,
            style: AppFontStyle.styleW500(AppColors.white, 14),
          ),
        ),
        Expanded(
          flex: 6,
          child: TitleFormFiled(
            controller: fieldController,
            hintText: hint,
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }
}


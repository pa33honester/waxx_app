import 'package:waxxapp/utils/globle_veriables.dart';
import 'package:flutter/material.dart';
import 'package:waxxapp/ApiService/seller/promo_code_list_service.dart';
import 'package:waxxapp/seller_pages/listing/controller/listing_controller.dart';
import 'package:waxxapp/seller_pages/listing/widget/listing_app_bar_widget.dart';
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
                  Text(St.shippingCharge.tr, style: AppFontStyle.styleW600(AppColors.white, 16)),
                  16.height,
                  TitleFormFiled(
                    controller: controller.shippingChargeController,
                    hintText: St.enterShippingCharge.tr,
                    keyboardType: TextInputType.number,
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
        onTap: () => _openPromoCodeSheet(controller),
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

  Future<void> _openPromoCodeSheet(ListingController controller) async {
    await controller.loadPromoCodes();

    Get.bottomSheet(
      Container(
        color: AppColors.black,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Promo Codes', style: AppFontStyle.styleW700(AppColors.white, 16)),
              8.height,
              Text(
                'Pick the promo codes that apply to this listing. Buyers using a code at checkout get the matching discount.',
                style: AppFontStyle.styleW400(AppColors.unselected, 12),
              ),
              16.height,
              Obx(() {
                if (controller.isLoadingPromoCodes.value) {
                  return const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final options = controller.availablePromoCodes;
                if (options.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: Center(
                      child: Text(
                        'No promo codes are configured by the admin yet.',
                        style: AppFontStyle.styleW500(AppColors.unselected, 13),
                      ),
                    ),
                  );
                }
                return ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: Get.height * 0.55),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: options.length,
                    separatorBuilder: (_, __) => const Divider(height: 1, color: Colors.white10),
                    itemBuilder: (_, i) => _PromoCodeRow(option: options[i], controller: controller),
                  ),
                );
              }),
              12.height,
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Get.back(),
                  child: Text('Done', style: AppFontStyle.styleW700(AppColors.primary, 14)),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: AppColors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
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

class _PromoCodeRow extends StatelessWidget {
  const _PromoCodeRow({required this.option, required this.controller});

  final PromoCodeOption option;
  final ListingController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selected = controller.selectedPromoCodeIds.contains(option.id);
      return InkWell(
        onTap: () => controller.togglePromoCode(option.id),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Icon(
                selected ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                color: selected ? AppColors.primary : AppColors.unselected,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(option.code, style: AppFontStyle.styleW700(AppColors.white, 14)),
                    if (option.discountLabel.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(option.discountLabel, style: AppFontStyle.styleW500(AppColors.unselected, 11)),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

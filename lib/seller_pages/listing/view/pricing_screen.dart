import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:cool_dropdown/models/cool_dropdown_item.dart';
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
                  // Delivery scope picker — sits above the existing
                  // shipping-charge field so the seller picks WHAT the
                  // charge covers, then enters how much.
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(St.deliveryBySeller.tr, style: AppFontStyle.styleW600(AppColors.white, 16)),
                      _buildDeliveryTypeDropdown(controller),
                    ],
                  ),
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

  /// Right-aligned CoolDropdown matching the visual style of the
  /// handling-time picker on the Preferences screen. Backend stores the
  /// lowercase enum value (`local`/`nationwide`/`international`); the
  /// dropdown shows localized labels via St.delivery*.tr.
  Widget _buildDeliveryTypeDropdown(ListingController controller) {
    // Rebuild the items list each time so locale / current-selection
    // changes flow through. The placeholder uses an empty string for the
    // null-selected state.
    controller.deliveryTypeDropdownItems
      ..clear()
      ..add(CoolDropdownItem<String>(label: St.selectDeliveryType.tr, value: ""))
      ..add(CoolDropdownItem<String>(label: St.deliveryLocal.tr, value: "local"))
      ..add(CoolDropdownItem<String>(label: St.deliveryNationwide.tr, value: "nationwide"))
      ..add(CoolDropdownItem<String>(label: St.deliveryInternational.tr, value: "international"));

    final saved = controller.selectedDeliveryType;
    final defaultItem = controller.deliveryTypeDropdownItems.firstWhere(
      (it) => it.value == (saved ?? ""),
      orElse: () => controller.deliveryTypeDropdownItems.first,
    );

    return CoolDropdown<String>(
      controller: controller.deliveryTypeDropDownController,
      dropdownList: controller.deliveryTypeDropdownItems,
      defaultItem: defaultItem,
      onChange: (value) =>
          controller.setDeliveryType(value.isEmpty ? null : value),
      resultOptions: ResultOptions(
        width: 180,
        render: ResultRender.label,
        boxDecoration: const BoxDecoration(
          color: Colors.transparent,
          border: Border(),
        ),
        openBoxDecoration: const BoxDecoration(
          color: Colors.transparent,
          border: Border(),
        ),
        textStyle: AppFontStyle.styleW600(AppColors.unselected, 13),
      ),
      dropdownOptions: DropdownOptions(
        width: 200,
        top: 10,
        selectedItemAlign: SelectedItemAlign.center,
        curve: Curves.bounceInOut,
        color: AppColors.tabBackground,
        align: DropdownAlign.right,
        animationType: DropdownAnimationType.scale,
      ),
      dropdownItemOptions: DropdownItemOptions(
        textStyle: AppFontStyle.styleW500(AppColors.unselected, 14),
        selectedTextStyle: AppFontStyle.styleW700(AppColors.primary, 14),
        selectedBoxDecoration: BoxDecoration(color: AppColors.white.withValues(alpha: 0.08)),
        padding: const EdgeInsets.only(left: 20),
        selectedPadding: const EdgeInsets.only(left: 20),
      ),
    );
  }
}


import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:cool_dropdown/models/cool_dropdown_item.dart';
import 'package:waxxapp/seller_pages/listing/controller/listing_controller.dart';
import 'package:waxxapp/seller_pages/listing/widget/listing_app_bar_widget.dart';
import 'package:waxxapp/utils/Strings/strings.dart';
import 'package:waxxapp/utils/app_colors.dart';
import 'package:waxxapp/utils/font_style.dart';
import 'package:waxxapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PreferencesScreen extends StatelessWidget {
  const PreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) => Get.find<ListingController>().businessDaysDropDownController.close(),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: GetBuilder<ListingController>(
              builder: (controller) {
                return ListingAppBarWidget(
                  title: St.preferences.tr,
                  showCheckIcon: true,
                  isCheckEnabled: controller.hasPreferences,
                  onCheckTap: () {
                    Get.back();
                  },
                );
              },
            )),
        body: GetBuilder<ListingController>(builder: (controller) {
          final locationParts = [
            if (controller.countryController.text.isNotEmpty) controller.countryController.text,
            if (controller.stateController.text.isNotEmpty) controller.stateController.text,
            if (controller.cityController.text.isNotEmpty) controller.cityController.text,
          ];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Utils.buildDivider(),
              GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(St.handlingTime.tr, style: AppFontStyle.styleW700(AppColors.white, 15)),
                      _buildDropdown(value: controller.selectedBusinessDays, items: controller.businessDays, onChanged: controller.selectBusinessDays, controller: controller),
                    ],
                  ),
                ),
              ),
              Utils.buildDivider(),
              GestureDetector(
                onTap: () {
                  Get.toNamed('/ItemLocation')?.then(
                    (value) => controller.update(),
                  );
                },
                child: Container(
                  color: AppColors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(St.itemLocation.tr, style: AppFontStyle.styleW700(AppColors.white, 15)),
                          ],
                        ),
                        if (locationParts.isNotEmpty)
                          Text(
                            locationParts.join(', '),
                            style: AppFontStyle.styleW600(AppColors.primary, 16),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              Utils.buildDivider(),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(St.requireImmediatePayment.tr, style: AppFontStyle.styleW700(AppColors.white, 15)),
                          Text(St.getPaidRightAwayWhenABuyerChooseToBuyItNow.tr, style: AppFontStyle.styleW500(AppColors.unselected, 14)),
                        ],
                      ),
                    ),
                    12.width,
                    Switch(
                      value: controller.isImmediatePaymentEnabled,
                      onChanged: controller.toggleImmediatePayment,
                      activeColor: AppColors.primary,
                      inactiveThumbColor: AppColors.unselected,
                      inactiveTrackColor: AppColors.unselected.withValues(alpha: .45),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    required ListingController controller,
  }) {
    controller.businessDaysDropdownItems.clear();
    controller.businessDaysDropdownItems.add(
      CoolDropdownItem<String>(
        label: St.selectHandlingTime.tr,
        value: "",
      ),
    );
    for (var item in items) {
      controller.businessDaysDropdownItems.add(
        CoolDropdownItem<String>(
          label: item,
          value: item,
        ),
      );
    }

    CoolDropdownItem<String> defaultItem;
    if (controller.selectedBusinessDays != null && items.contains(controller.selectedBusinessDays)) {
      final selectedIndex = items.indexOf(controller.selectedBusinessDays!);
      defaultItem = controller.businessDaysDropdownItems[selectedIndex + 1];
    } else {
      defaultItem = controller.businessDaysDropdownItems.first;
    }

    return CoolDropdown<String>(
      controller: controller.businessDaysDropDownController,
      dropdownList: controller.businessDaysDropdownItems,
      defaultItem: defaultItem,
      onChange: onChanged,
      resultOptions: ResultOptions(
        width: 180,
        render: ResultRender.label,
        boxDecoration: const BoxDecoration(
          color: Colors.transparent,
          border: Border(), // No border
        ),
        openBoxDecoration: BoxDecoration(
          color: Colors.transparent,
          border: Border(),
        ),
        textStyle: AppFontStyle.styleW600(AppColors.unselected, 13),
      ),
      dropdownOptions: DropdownOptions(
        width: 176,
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
